#import "LocationController.h"
#import "wpsapi.h"
#import "SkyhookApiKey.h"

#define LastKnownLocationLatitudeDefaultsKey @"lastKnownLocationLatitudeDefaultsKey"
#define LastKnownLocationLongitudeDefaultsKey @"lastKnownLocationLongitudeDefaultsKey"
#define LastKnownLocationTimestampDefaultsKey @"lastKnownLocationTimestampDefaultsKey"

@interface LocationController(Private)

- (void)fireNotificationForLocation:(Location *)location;
- (void)fireNotificationForError:(NSError *)error;
- (NSString *)registeredUsername;

@end

@implementation LocationController

@synthesize lastKnownLocation;
@synthesize delegate;
@synthesize updateInProgress;
@synthesize lastUpdateError;

- (id)init {
  self = [super init];
  if (self != nil) {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:LastKnownLocationTimestampDefaultsKey]) {
      lastKnownLocation = [[Location alloc] init];
      CLLocationCoordinate2D _coordinate;
      _coordinate.latitude = [[NSUserDefaults standardUserDefaults] floatForKey:LastKnownLocationLatitudeDefaultsKey];
      _coordinate.longitude = [[NSUserDefaults standardUserDefaults] floatForKey:LastKnownLocationLongitudeDefaultsKey];
      lastKnownLocation.coordinate = _coordinate;
      lastKnownLocation.timestamp = [[NSUserDefaults standardUserDefaults] objectForKey:LastKnownLocationTimestampDefaultsKey];
    }
  }
  return self;
}


- (void)refreshLocation {
  [self willChangeValueForKey:@"updateInProgress"];
  updateInProgress = YES;
  [self didChangeValueForKey:@"updateInProgress"];
  [self performSelectorInBackground:@selector(refreshLocationInBackground) withObject:nil];
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
    CFRelease(uuidObj);
    NSLog(@"Generated username for Skyhook: %@", uuidString);
    
    newAuthentication.username = [uuidString UTF8String]; // convert to c string
    
    WPS_ReturnCode authRc;
    authRc = WPS_register_user(&authentication, &newAuthentication);
    if (authRc != WPS_OK) {
      NSLog(@"Registration with Skyhook failed.");
      NSError *error = [NSError errorWithDomain:@"locationController (authentication)" code:authRc userInfo:nil];
      [self performSelectorOnMainThread:@selector(locationUpdateFailedWithError:) withObject:error waitUntilDone:YES];
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
    // Use the location object - your code here
    
    Location *newLocation = [[[Location alloc] init] autorelease];
    CLLocationCoordinate2D coordinate;
    coordinate.longitude = location->longitude;
    coordinate.latitude = location->latitude;
    newLocation.coordinate = coordinate;
    newLocation.timestamp = [NSDate date]; // now
    
    [lastKnownLocation autorelease];
    lastKnownLocation = [newLocation retain];
    
    [[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.latitude forKey:LastKnownLocationLatitudeDefaultsKey];
    [[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.longitude forKey:LastKnownLocationLongitudeDefaultsKey];
    [[NSUserDefaults standardUserDefaults] setObject:newLocation.timestamp forKey:LastKnownLocationTimestampDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSelectorOnMainThread:@selector(locationDidMoveTo:) withObject:newLocation waitUntilDone:NO];
    
    // Free the location object
    WPS_free_location(location); 
  } else {
    if (rc == WPS_ERROR_UNAUTHORIZED) {
      NSLog(@"Authentication failure from Skyhook. Wipe the stored username so it re-registers on next update.");
      [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"skyhookUsername"];
    }
    
    NSError *error = [NSError errorWithDomain:@"locationController" code:rc userInfo:nil];
    [self performSelectorOnMainThread:@selector(locationUpdateFailedWithError:) withObject:error waitUntilDone:NO];
  }
  
  [pool release];
}

- (NSString *)registeredUsername {
  return [[NSUserDefaults standardUserDefaults] stringForKey:@"skyhookUsername"];
}

- (void)locationDidMoveTo:(Location *)newLocation {
  [lastUpdateError release];
  lastUpdateError = nil;
  [self willChangeValueForKey:@"updateInProgress"];
  updateInProgress = NO;
  [self fireNotificationForLocation:newLocation];
  [self didChangeValueForKey:@"updateInProgress"];
}

- (void)locationUpdateFailedWithError:(NSError *)error {
  [lastUpdateError release];
  lastUpdateError = nil;
  lastUpdateError = [error retain];
  [self willChangeValueForKey:@"updateInProgress"];
  updateInProgress = NO;
  NSLog(@"Location update failed with error: %@", error);
  [self fireNotificationForError:error];
  [self didChangeValueForKey:@"updateInProgress"];
}

- (void)fireNotificationForLocation:(Location *)location {
  [[NSNotificationCenter defaultCenter] postNotificationName:UpdatedLocationNotification object:location];
}

- (void)fireNotificationForError:(NSError *)error {
  [[NSNotificationCenter defaultCenter] postNotificationName:FailedLocationUpdateNotification object:error];
}

#pragma mark Singleton Methods

static LocationController *sharedLocationController = nil;

+ (LocationController *)sharedInstance {
  @synchronized(self) {
    if (sharedLocationController == nil) {
      sharedLocationController = [[self alloc] init]; // assignment not done here
    }
  }
  return sharedLocationController;
}


@end
