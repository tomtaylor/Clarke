//
//  CoreLocationController.m
//  firehook
//
//  Created by Tom Taylor on 10/09/2009.
//  Copyright 2009 Really Interesting Group. All rights reserved.
//

#import "CoreLocationController.h"


@implementation CoreLocationController

- (id)init {
	self = [super init];
	if (self != nil) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
	}
	return self;
}

- (void)startUpdating {
	[locationManager startUpdatingLocation];
	isRunning = YES;
}

- (void)stopUpdating {
	[locationManager stopUpdatingLocation];
	isRunning = NO;
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager 
		didUpdateToLocation:(CLLocation *)newLocation 
					 fromLocation:(CLLocation *)oldLocation 
{
	NSDate* eventDate = newLocation.timestamp;
	NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
	
	if (abs(howRecent) < 120) { // less than two minutes old
		Location *newClarkeLocation = [[Location alloc] init];
		CLLocationCoordinate2D coordinate;
		coordinate.latitude = newLocation.coordinate.latitude;
		coordinate.longitude = newLocation.coordinate.longitude;
		newClarkeLocation.coordinate = coordinate;
		newClarkeLocation.timestamp = newLocation.timestamp;
		
		[lastKnownLocation autorelease];
		lastKnownLocation = [newClarkeLocation retain];
		
		[lastUpdateError release];
		lastUpdateError = nil;
		
		[[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.latitude forKey:LastKnownLocationLatitudeDefaultsKey];
		[[NSUserDefaults standardUserDefaults] setFloat:newLocation.coordinate.longitude forKey:LastKnownLocationLongitudeDefaultsKey];
		[[NSUserDefaults standardUserDefaults] setObject:newLocation.timestamp forKey:LastKnownLocationTimestampDefaultsKey];
		[[NSUserDefaults standardUserDefaults] synchronize];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:UpdatedLocationNotification object:newClarkeLocation];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	NSLog(@"Location Manager failed with errors: %@", error);
	[[NSNotificationCenter defaultCenter] postNotificationName:FailedLocationUpdateNotification object:error];
}

@end
