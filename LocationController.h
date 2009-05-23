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

@interface LocationController : NSObject {
  id delegate;
  Location *lastKnownLocation;
  NSError *lastUpdateError;
  BOOL updateInProgress;
}

+ (LocationController *)sharedInstance;

@property (readonly) Location *lastKnownLocation;
@property (readonly) NSError *lastUpdateError;
@property (assign) id delegate;
@property (readonly) BOOL updateInProgress;

- (void)refreshLocation;

@end

@protocol LocationControllerDelegate

- (void)locationDidChange:(Location *)location;

@end

