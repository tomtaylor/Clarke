#import "FireEaglePreferencesViewController.h"
#import "FireEagleController.h"
#import "SkyhookLocationController.h"

@interface FireEaglePreferencesViewController(Private)

- (void)viewWillLoad;

@end


@implementation FireEaglePreferencesViewController

@synthesize loggedOutView, loggedInView, waitingForAuthorizationView, oauthVerifier;

- (id) init {
  self = [super init];
  if (self != nil) {
    [self initWithNibName:@"FireEaglePreferences" bundle:nil];
    theFireEagleController = [FireEagleController sharedInstance];
    [theFireEagleController addDelegate:self];
  }
  return self;
}

- (void) dealloc
{
  [theFireEagleController removeDelegate:self];
  [super dealloc];
}


- (void)awakeFromNib {
  if ([[FireEagleController sharedInstance] hasAccessToken]) {
    [self.view addSubview:self.loggedInView];
  } else {
    [self.view addSubview:self.loggedOutView];
    [theFireEagleController clearTokens];
  }
}

- (IBAction)signIn:(id)sender {
  if ([theFireEagleController hasRequestToken]) {
    NSLog(@"Requesting access token with verifier: %@", [self.oauthVerifier stringValue]);
    [theFireEagleController getAccessTokenWithVerifier:[self.oauthVerifier stringValue]];
  } else {
    NSLog(@"Requesting request token");
    [theFireEagleController getRequestToken]; 
  }
  [progressIndicator startAnimation:self];
}

- (IBAction)signOut:(id)sender {
  [theFireEagleController logout];
  [theFireEagleController clearTokens];
  [oauthVerifier setStringValue:@""];
  [self.view replaceSubview:loggedInView with:loggedOutView];
}

#pragma mark FireEagleControllerDelegate
    
- (void)requestTokenDidFinish {
  [progressIndicator stopAnimation:self];
  [[NSWorkspace sharedWorkspace] openURL:[theFireEagleController getAuthorizeURL]];
  
  [self.view replaceSubview:loggedOutView with:waitingForAuthorizationView];
  // this replicates the text in the NIB (which is overridden on failure, so it needs to be reset)
  [loggedOutLabel setStringValue:@"When you have given Clarke permission, enter the verification code and click Continue."];
}

- (void)requestTokenDidFailWithError:(NSError *)error {
  [progressIndicator stopAnimation:self];
  [loggedOutLabel setStringValue:@"There was a problem signing you into Fire Eagle. Please try authorizing again."];
  [loggedOutSubtitle setHidden:YES];
  [loggedOutButton setTitle:@"Try again"];
}

- (void)accessTokenDidFinish {
  NSLog(@"Access token did finish in Fire Eagle Preferences view.");
  [progressIndicator stopAnimation:self];
  [self.view replaceSubview:waitingForAuthorizationView with:loggedInView];
  
  Location *lastKnownLocation = [[SkyhookLocationController sharedInstance] lastKnownLocation];
  if (lastKnownLocation) {
    [theFireEagleController updateLocation:lastKnownLocation];
  }
}

- (void)accessTokenDidFailWithError:(NSError *)error {
  NSLog(@"Access token did fail in Fire Eagle Preferences view.");
  [progressIndicator stopAnimation:self];
  
  NSAlert *alert = [[NSAlert alloc] init];
  [alert addButtonWithTitle:@"Try again"];
  [alert setMessageText:@"That verification code didn't seem to be correct"];
  [alert setInformativeText:@"Please try again, making sure you type the verification code correctly."];
  [alert setAlertStyle:NSWarningAlertStyle];
  
  // TODO: allow retry of badly typed verification code
  if ([alert runModal] == NSAlertFirstButtonReturn) { // try again
    [theFireEagleController clearTokens];
    [self.view replaceSubview:waitingForAuthorizationView with:loggedOutView];
  }
  
  [alert release];
}

@end
