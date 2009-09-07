//
//  LocationController.h
//  firehook
//
//  Created by Tom Taylor on 29/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Location.h"

#define UpdatedLocationNotification @"updatedLocationNotification"
#define FailedLocationUpdateNotification @"failedLocationUpdateNotification"

@interface SkyhookLocationController : NSObject {
	id delegate;
	Location *lastKnownLocation;
	NSError *lastUpdateError;
	NSTimer *locationUpdateTimer;
	BOOL isRunning;
	BOOL needsToStop;
	BOOL updateInProgress;
}

+ (SkyhookLocationController *)sharedInstance;

@property (readonly) Location *lastKnownLocation;
@property (readonly) NSError *lastUpdateError;
@property (assign) id delegate;
@property (readonly) BOOL updateInProgress;
@property (readonly) BOOL isRunning;

- (void)refreshLocation;
- (void)startUpdating;
- (void)stopUpdating;

@end

