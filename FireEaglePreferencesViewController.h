#import <Cocoa/Cocoa.h>
#import "FireEagleController.h"

@interface FireEaglePreferencesViewController : NSViewController {
  IBOutlet NSView *loggedOutView;
  IBOutlet NSView *loggedInView;
  IBOutlet NSView *waitingForAuthorizationView;
  IBOutlet NSTextField *loggedOutLabel;
  IBOutlet NSTextField *loggedOutSubtitle;
  IBOutlet NSTextField *oauthVerifier;
  IBOutlet NSProgressIndicator *progressIndicator;
  IBOutlet NSMenu *menu;
  
  IBOutlet NSButton *loggedOutButton;
  FireEagleController *theFireEagleController;
}

@property (retain) IBOutlet NSView *loggedOutView;
@property (retain) IBOutlet NSView *loggedInView;
@property (retain) IBOutlet NSView *waitingForAuthorizationView;
@property (retain) IBOutlet NSTextField *oauthVerifier;

- (IBAction)signIn:(id)sender;
- (IBAction)signOut:(id)sender;

@end
