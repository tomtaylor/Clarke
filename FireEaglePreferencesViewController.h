#import <Cocoa/Cocoa.h>
#import "FireEagleController.h"

@interface FireEaglePreferencesViewController : NSViewController {
  IBOutlet NSView *loggedOutView;
  IBOutlet NSView *loggedInView;
  IBOutlet NSTextField *loggedOutLabel;
  IBOutlet NSTextField *loggedOutSubtitle;
  IBOutlet NSProgressIndicator *progressIndicator;
  
  IBOutlet NSButton *loggedOutButton;
  FireEagleController *theFireEagleController;
}

@property (retain) IBOutlet NSView *loggedOutView;
@property (retain) IBOutlet NSView *loggedInView;

- (IBAction)signIn:(id)sender;
- (IBAction)signOut:(id)sender;

@end
