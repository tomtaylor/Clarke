//
//  BaseLocationController.m
//  firehook
//
//  Created by Tom Taylor on 10/09/2009.
//  Copyright 2009 Really Interesting Group. All rights reserved.
//

#import "BaseLocationController.h"

@implementation BaseLocationController

@synthesize lastKnownLocation;
@synthesize lastUpdateError;
@synthesize delegate;
@synthesize isRunning;

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
		isRunning = NO;
	}
	return self;
}

- (void)startUpdating {
	[self doesNotRecognizeSelector:_cmd];
}

- (void)stopUpdating {
	[self doesNotRecognizeSelector:_cmd];
}

#pragma mark Singleton Methods

static BaseLocationController *sharedLocationController = nil;

+ (BaseLocationController *)sharedInstance {
	@synchronized(self) {
		if (sharedLocationController == nil) {
			sharedLocationController = [[self alloc] init];
		}
	}
	return sharedLocationController;
}

@end
