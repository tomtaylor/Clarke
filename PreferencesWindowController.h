#import <Cocoa/Cocoa.h>
#import "FireEaglePreferencesViewController.h"
#import "GeneralPreferencesViewController.h"
#import "AboutPreferencesViewController.h"

@interface PreferencesWindowController : NSWindowController <NSToolbarDelegate> {
  FireEaglePreferencesViewController *theFireEaglePreferencesController;
  GeneralPreferencesViewController *theGeneralPreferencesController;
  AboutPreferencesViewController *theAboutPreferencesController;
  NSToolbar *theToolbar;
}

- (void)selectGeneral:(id)sender;
- (void)selectFireEagle:(id)sender;

@end
