//
//  FirehookApplicationDelegate.h
//  firehook
//
//  Created by Tom Taylor on 30/04/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LocationController.h"
#import "Location.h"
#import "PreferencesWindowController.h"
#import "FireEagleController.h"
#import "StatusMenuHeaderViewController.h"
#import "RHSystemIdleTimer.h"

@interface FirehookApplicationDelegate : NSObject {
  LocationController *locationController;
  PreferencesWindowController *thePreferencesWindowController;
  FireEagleController *theFireEagleController;
  
  RHSystemIdleTimer *systemIdleTimer;
  BOOL isIdle;
  
  NSStatusItem *theStatusItem;
  NSMenuItem *nearbyItem;
  StatusMenuHeaderViewController *theStatusHeaderViewController;
}

@property (readonly) LocationController *locationController;

- (void)activateStatusMenu;
- (void)locationDidChange:(NSNotification *)notification;

@end
