#import "SkyhookLocationController.h"
#import "wpsapi.h"
#import "SkyhookApiKey.h"

#ifdef DEBUG
#define LOCATION_INTERVAL 10
#else
#define LOCATION_INTERVAL 60
#endif

@interface SkyhookLocationController(Private)

- (void)refreshLocation;
- (void)fireNotificationForLocation:(Location *)location;
- (void)fireNotificationForError:(NSError *)error;
- (NSString *)registeredUsername;

@end

@implementation SkyhookLocationController

- (id)init {
	self = [super init];
	if (self != nil) {
		needsToStop = NO;
	}
	return self;
}

- (void)killLocationRefreshTimer {
	[locationUpdateTimer invalidate];
	[locationUpdateTimer release];
	locationUpdateTimer = nil;
}

- (void)rescheduleLocationRefreshTimer {
	NSInteger updateInterval = LOCATION_INTERVAL;
	
	[self killLocationRefreshTimer]; // ensure it's not running

	locationUpdateTimer = [NSTimer timerWithTimeInterval:updateInterval target:self selector:@selector(refreshLocation) userInfo:nil repeats:NO];
	[[NSRunLoop currentRunLoop] addTimer:locationUpdateTimer forMode:NSRunLoopCommonModes];
}

- (void)startUpdating {
	needsToStop = NO;
	isRunning = YES;
	[self refreshLocation];
}

- (void)stopUpdating {
	[self killLocationRefreshTimer];
	needsToStop = YES;
	isRunning = NO;
}

- (void)refreshLocation {
	[self killLocationRefreshTimer];
	[self performSelectorInBackground:@selector(refreshLocationInBackground) withObject:nil];
}

- (void)tidyAndScheduleNextRefresh {
	if (!needsToStop) {
		[self rescheduleLocationRefreshTimer];
	}
}

- (void)refreshLocationInBackground {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	WPS_SimpleAuthentication authentication;
	authentication.username = SKYHOOK_MASTER_USERNAME;
	authentication.realm = SKYHOOK_MASTER_REALM;
	
	WPS_SimpleAuthentication newAuthentication;
	newAuthentication.realm = authentication.realm;
	
	// register if needed
	if ([self registeredUsername] == nil) {
		NSLog(@"Need to register with Skyhook");
		
		//create a new UUID
		CFUUIDRef uuidObj = CFUUIDCreate(nil); 
		NSString *uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
		[uuidString autorelease];
		CFRelease(uuidObj);
		NSLog(@"Generated username for Skyhook: %@", uuidString);
		newAuthentication.username = [uuidString UTF8String]; // convert to c string
		
		WPS_ReturnCode authRc;
		authRc = WPS_register_user(&authentication, &newAuthentication);
		if (authRc != WPS_OK) {
			NSLog(@"Registration with Skyhook failed.");
			NSError *error = [NSError errorWithDomain:@"locationController (authentication)" code:authRc userInfo:nil];
			[self performSelectorOnMainThread:@selector(locationUpdateFailedWithError:) withObject:error waitUntilDone:YES];
			[pool release];
			return;
		} else {
			NSLog(@"Registration with Skyhook succeeded, storing username");
			[[NSUserDefaults standardUserDefaults] setObject:uuidString forKey:@"skyhookUsername"];
		}
	} else {
		// already registered
		NSLog(@"Already registered with Skyhook. Username: %@", [self registeredUsername]);
		newAuthentication.username = [[self registeredUsername] UTF8String];
	}
    
	WPS_ReturnCode rc;
	// populated with the location results
	WPS_Location* location; 
	rc = WPS_location(&newAuthentication,
					  WPS_NO_STREET_ADDRESS_LOOKUP,
					  &location);
	if (rc == WPS_OK) {
		Location *newLocation = [[[Location alloc] init] autorelease];
		CLLocationCoordinate2D coordinate;
		coordinate.longitude = location->longitude;
		coordinate.latitude = location->latitude;
		newLocation.coordinate = coordinate;
		newLocation.timestamp = [NSDate date]; // now
		
		if ([newLocation distanceFrom:lastKnownLocation] > 0.5) { // 500m
			NSLog(@"From: %f,%f", lastKnownLocation.coordinate.latitude, lastKnownLocation.coordinate.longitude);
			NSLog(@"To: %f,%f", newLocation.coordinate.latitude, newLocation.coordinate.longitude);
			NSLog(@"Distance between locations: %fkm", [newLocation distanceFrom:lastKnownLocation]);
			[self performSelectorOnMainThread:@selector(locationDidMoveTo:) withObject:newLocation waitUntilDone:NO];
			
			[lastKnownLocation autorelease];
			lastKnownLocation = [newLocation retain];
			
			[[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.latitude forKey:LastKnownLocationLatitudeDefaultsKey];
			[[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.longitude forKey:LastKnownLocationLongitudeDefaultsKey];
			[[NSUserDefaults standardUserDefaults] setObject:newLocation.timestamp forKey:LastKnownLocationTimestampDefaultsKey];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		WPS_free_location(location); 
	} else {
		if (rc == WPS_ERROR_UNAUTHORIZED) {
			NSLog(@"Authentication failure from Skyhook. Wipe the stored username so it re-registers on next update.");
			[[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"skyhookUsername"];
		}
		
		NSError *error = [NSError errorWithDomain:@"locationController" code:rc userInfo:nil];
		[self performSelectorOnMainThread:@selector(locationUpdateFailedWithError:) withObject:error waitUntilDone:YES];
	}
	
	[self performSelectorOnMainThread:@selector(tidyAndScheduleNextRefresh) withObject:nil waitUntilDone:NO];
	
	[pool release];
}

- (NSString *)registeredUsername {
	return [[NSUserDefaults standardUserDefaults] stringForKey:@"skyhookUsername"];
}

- (void)locationDidMoveTo:(Location *)newLocation {
	[lastUpdateError release];
	lastUpdateError = nil;
	[self fireNotificationForLocation:newLocation];
}

- (void)locationUpdateFailedWithError:(NSError *)error {
	[lastUpdateError release];
	lastUpdateError = nil;
	lastUpdateError = [error retain];
	NSLog(@"Location update failed with error: %@", error);
	[self fireNotificationForError:error];
}

- (void)fireNotificationForLocation:(Location *)location {
	[[NSNotificationCenter defaultCenter] postNotificationName:UpdatedLocationNotification object:location];
}

- (void)fireNotificationForError:(NSError *)error {
	[[NSNotificationCenter defaultCenter] postNotificationName:FailedLocationUpdateNotification object:error];
}

@end