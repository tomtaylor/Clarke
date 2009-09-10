//
//  BaseLocationController.h
//  firehook
//
//  Created by Tom Taylor on 10/09/2009.
//  Copyright 2009 Really Interesting Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Location.h"

#define UpdatedLocationNotification @"updatedLocationNotification"
#define FailedLocationUpdateNotification @"failedLocationUpdateNotification"

#define LastKnownLocationLatitudeDefaultsKey @"lastKnownLocationLatitudeDefaultsKey"
#define LastKnownLocationLongitudeDefaultsKey @"lastKnownLocationLongitudeDefaultsKey"
#define LastKnownLocationTimestampDefaultsKey @"lastKnownLocationTimestampDefaultsKey"

@interface BaseLocationController : NSObject {
	id delegate;
	Location *lastKnownLocation;
	NSError *lastUpdateError;
	NSTimer *locationUpdateTimer;
	BOOL isRunning;
}

@property (readonly) Location *lastKnownLocation;
@property (readonly) NSError *lastUpdateError;
@property (assign) id delegate;
@property (readonly) BOOL isRunning;

- (void)startUpdating;
- (void)stopUpdating;

+ (BaseLocationController *)sharedInstance;

@end
