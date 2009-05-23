#import "GeneralPreferencesViewController.h"

static void
loginItemsChanged(LSSharedFileListRef listRef, void *context)
{
  GeneralPreferencesViewController *controller = context;
  
  // Emit change notification for the bindnings. We can't do will/did
  // around the change but this will have to do.
  [controller willChangeValueForKey:@"launchOnLogin"];
  [controller didChangeValueForKey:@"launchOnLogin"];
}

@implementation GeneralPreferencesViewController

- (id) init
{
  self = [super init];
  if (self != nil) {
    [self initWithNibName:@"GeneralPreferences" bundle:nil];
    
    // login items
    loginItemsListRef = LSSharedFileListCreate(NULL,
                                               kLSSharedFileListSessionLoginItems,
                                               NULL);
    if (loginItemsListRef) {
      // Add an observer so we can update the UI if changed externally.
      LSSharedFileListAddObserver(loginItemsListRef,
                                  CFRunLoopGetMain(),
                                  kCFRunLoopCommonModes,
                                  loginItemsChanged,
                                  self);
    }
  }
  return self;
}

// Get an NSArray with the items.
- (NSArray *)loginItems
{
  CFArrayRef snapshotRef = LSSharedFileListCopySnapshot(loginItemsListRef, NULL);
  
  // Use toll-free bridging to get an NSArray with nicer API
  // and memory management.
  return [NSMakeCollectable(snapshotRef) autorelease];
}

// Return a CFRetained item for the app's bundle, if there is one.
- (LSSharedFileListItemRef)mainBundleLoginItemCopy
{
  NSArray *loginItems = [self loginItems];
  NSURL *bundleURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
  
  for (id item in loginItems) {
    LSSharedFileListItemRef itemRef = (LSSharedFileListItemRef)item;
    CFURLRef itemURLRef;
    
    if (LSSharedFileListItemResolve(itemRef, 0, &itemURLRef, NULL) == noErr) {
      // Again, use toll-free bridging.
      NSURL *itemURL = (NSURL *)[NSMakeCollectable(itemURLRef) autorelease];
      if ([itemURL isEqual:bundleURL]) {
        CFRetain(item);
        return (LSSharedFileListItemRef)item;
      }
    }
  }
  
  return NULL;
}

- (void)addMainBundleToLoginItems
{
  // We use the URL to the app itself (i.e. the main bundle).
  NSURL *bundleURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
  
  // Ask to be hidden on launch. The key name to use was a bit hard to find, but can
  // be found by inspecting the plist ~/Library/Preferences/com.apple.loginwindow.plist
  // and looking at some existing entries. Thanks to Anders for the hint!
  NSDictionary *properties;
  properties = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES]
                                           forKey:@"com.apple.loginitem.HideOnLaunch"];
  
  LSSharedFileListItemRef itemRef;
  itemRef = LSSharedFileListInsertItemURL(loginItemsListRef,
                                          kLSSharedFileListItemLast,
                                          NULL,
                                          NULL,
                                          (CFURLRef)bundleURL,
                                          (CFDictionaryRef)properties,
                                          NULL);
  if (itemRef) {
    CFRelease(itemRef);
  }
}

- (void)removeMainBundleFromLoginItems
{
  // Try to get the item corresponding to the main bundle URL.
  LSSharedFileListItemRef itemRef = [self mainBundleLoginItemCopy];
  if (!itemRef)
    return;
  
  LSSharedFileListItemRemove(loginItemsListRef, itemRef);
  
  CFRelease(itemRef);
}

#pragma mark Property accessor methods
- (BOOL)launchOnLogin
{
  if (!loginItemsListRef)
    return NO;
  
  LSSharedFileListItemRef itemRef = [self mainBundleLoginItemCopy];    
  if (!itemRef)
    return NO;
  
  CFRelease(itemRef);
  return YES;
}

- (void)setLaunchOnLogin:(BOOL)value
{
  if (!loginItemsListRef)
    return;
  
  if (!value) {
    [self removeMainBundleFromLoginItems];
  } else {
    [self addMainBundleToLoginItems];
  }
}

- (void) dealloc
{
  if (loginItemsListRef) {
    LSSharedFileListRemoveObserver(loginItemsListRef,
                                   CFRunLoopGetMain(),
                                   kCFRunLoopCommonModes,
                                   loginItemsChanged,
                                   self);
    CFRelease(loginItemsListRef);
  }  
  [super dealloc];
}



@end
