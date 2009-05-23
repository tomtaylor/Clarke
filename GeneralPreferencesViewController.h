//
//  GeneralPreferencesViewController.h
//  firehook
//
//  Created by Tom Taylor on 13/05/2009.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GeneralPreferencesViewController : NSViewController {
  LSSharedFileListRef loginItemsListRef;
}

@property BOOL launchOnLogin;

- (void)addMainBundleToLoginItems;

@end
