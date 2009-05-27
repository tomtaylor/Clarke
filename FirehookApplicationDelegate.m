#import "FirehookApplicationDelegate.h"

#ifdef DEBUG
  #define LOCATION_INTERVAL 30
#else
  #define LOCATION_INTERVAL 300
#endif

#define IDLE_TIMEOUT 300

@interface FirehookApplicationDelegate(Private)

- (void)rescheduleLocationRefreshTimer;
- (NSView *)statusMenuHeaderView;

- (void)configureDefaultSettings;
- (void)doFirstRunIfNeeded;
- (void)tellUserAboutStatusMenu;
- (void)askUserWhetherToStartAtBoot;
- (void)openPreferences;

- (BOOL)shouldPauseUpdatesWhenIdle;

@end


@implementation FirehookApplicationDelegate

@synthesize locationController;

- (id) init {
  self = [super init];
  if (self != nil) {
    locationController = [LocationController sharedInstance];
    locationController.delegate = self;
    thePreferencesWindowController = [[PreferencesWindowController alloc] init];
    theStatusHeaderViewController = [[StatusMenuHeaderViewController alloc] init];
    theFireEagleController = [FireEagleController sharedInstance];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  locationController.delegate = nil;
  [thePreferencesWindowController release];
  [theStatusHeaderViewController release];
  [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification {
  systemIdleTimer = [[RHSystemIdleTimer alloc] initSystemIdleTimerWithTimeInterval:IDLE_TIMEOUT];
  [systemIdleTimer setDelegate:self];
  isIdle = NO;
  
  [self configureDefaultSettings];
  [self activateStatusMenu];
  
  [self doFirstRunIfNeeded];
  
  // register for location updates & fire the first request
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:UpdatedLocationNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdateDidFail:) name:FailedLocationUpdateNotification object:nil];
  [locationController refreshLocation];
  
  // register for awake from sleep notifications
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self 
                                                         selector: @selector(receiveWakeNote:) 
                                                             name: NSWorkspaceDidWakeNotification 
                                                           object: nil];
}

- (void)configureDefaultSettings {
  [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObjectsAndKeys:@"YES", @"pauseUpdatesWhenIdle", nil]];
  
}

- (void)doFirstRunIfNeeded {
  if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstRunDone"]) {
    [self openPreferences];
    [self tellUserAboutStatusMenu];
    
    [thePreferencesWindowController selectFireEagle:self];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstRunDone"];
  } else if (![[NSUserDefaults standardUserDefaults] boolForKey:@"secondRunDone"]) {
    //[self askUserWhetherToStartAtBoot];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"secondRunDone"];
  }
}

- (void)tellUserAboutStatusMenu {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert addButtonWithTitle:@"OK"];
  [alert setMessageText:@"Clarke is now running in the system menu"];
  [alert setInformativeText:@"It will attempt to triangulate your position every 5 minutes using nearby wireless access points, and if you sign into Fire Eagle it will update your location there."];
  [alert setAlertStyle:NSInformationalAlertStyle];
  [alert beginSheetModalForWindow:thePreferencesWindowController.window modalDelegate:self didEndSelector:NULL contextInfo:NULL];
  [alert release];
}

- (void)askUserWhetherToStartAtBoot {
  NSAlert *alert = [[NSAlert alloc] init];
  [alert addButtonWithTitle:@"Yes"];
  [alert addButtonWithTitle:@"No"];
  [alert setMessageText:@"Run Clarke automatically when this computer starts up?"];
  [alert setInformativeText:@"You can change this at any time in the preferences."];
  [alert setAlertStyle:NSWarningAlertStyle];
  
  if ([alert runModal] == NSAlertFirstButtonReturn) {
    GeneralPreferencesViewController *g = [[GeneralPreferencesViewController alloc] init];
    [g addMainBundleToLoginItems];
    [g release];
  }
  [alert release];
}

- (void) receiveWakeNote: (NSNotification*) note {
  NSLog(@"Application woke from sleep - refreshing");
  [locationController refreshLocation];
}

- (void)activateStatusMenu {
  NSStatusBar *bar = [NSStatusBar systemStatusBar];
  
  theStatusItem = [bar statusItemWithLength:NSSquareStatusItemLength];
  [theStatusItem retain];
  
  [theStatusItem setImage:[NSImage imageNamed:@"status-bar-icon-ok.png"]];
  [theStatusItem setHighlightMode:YES];
  
  NSMenu *theMenu = [[NSMenu alloc] init];
  [theMenu setDelegate:self];
  [theMenu setAutoenablesItems:NO];
  
  NSMenuItem *statusMenuHeaderItem = [[NSMenuItem alloc] init];
  [statusMenuHeaderItem setView:theStatusHeaderViewController.view];
  [theMenu addItem:statusMenuHeaderItem];
  [statusMenuHeaderItem release];
  
  [theMenu addItem:[NSMenuItem separatorItem]];
  
  nearbyItem = [[NSMenuItem alloc] initWithTitle:@"Nearby" action:NULL keyEquivalent:@""];
  NSMenu *nearbyMenu = [[NSMenu alloc] init];
  [nearbyMenu addItemWithTitle:@"Flickr" action:@selector(openFlickr) keyEquivalent:@""];
  [nearbyMenu addItemWithTitle:@"Google Maps" action:@selector(openGoogleMaps) keyEquivalent:@""];
  [nearbyMenu addItemWithTitle:@"OpenStreetMap" action:@selector(openOpenStreetMap) keyEquivalent:@""];
  [nearbyMenu addItemWithTitle:@"Yahoo Maps" action:@selector(openYahoo) keyEquivalent:@""];
  [nearbyItem setSubmenu:nearbyMenu];
  [theMenu addItem:nearbyItem];
  [nearbyMenu release];
  [nearbyItem release];
  
  if ([[LocationController sharedInstance] lastKnownLocation] == nil) {
    [nearbyItem setEnabled:NO];
  }
  
  NSMenuItem *openPreferencesItem = [[NSMenuItem alloc] initWithTitle:@"Preferences..." action:@selector(openPreferences) keyEquivalent:@","];
  [openPreferencesItem setKeyEquivalentModifierMask:NSCommandKeyMask];
  [theMenu addItem:openPreferencesItem];
  [openPreferencesItem release];
  
  NSMenuItem *quitMenuItem = [[NSMenuItem alloc] initWithTitle:@"Quit" action:@selector(quit) keyEquivalent:@"Q"];
  [quitMenuItem setKeyEquivalentModifierMask:NSCommandKeyMask];
  [theMenu addItem:quitMenuItem];
  [quitMenuItem release];
  
  [theStatusItem setMenu:theMenu];
  [theMenu release];
}

- (void)locationDidChange:(NSNotification *)notification {
  [nearbyItem setEnabled:YES];
  Location *location = notification.object;
  NSLog(@"Location did change: %@", location);
  
  if ([theFireEagleController hasAccessToken]) {
    if (!([self shouldPauseUpdatesWhenIdle] && isIdle)) {
      [theFireEagleController updateLocation:location];
    }
  }
  
  [self rescheduleLocationRefreshTimer];
}

- (void)locationUpdateDidFail:(NSError *)error {
  [self rescheduleLocationRefreshTimer];
}

- (void)rescheduleLocationRefreshTimer {
  NSInteger updateInterval = LOCATION_INTERVAL;
  locationUpdateTimer = [NSTimer timerWithTimeInterval:updateInterval target:locationController selector:@selector(refreshLocation) userInfo:nil repeats:NO];
  [[NSRunLoop currentRunLoop] addTimer:locationUpdateTimer forMode:NSRunLoopCommonModes];
}

- (void)menuWillOpen:(NSMenu *)menu {
  [theStatusHeaderViewController viewWillAppear];
}


- (void)openPreferences {
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  [thePreferencesWindowController showWindow:self];
}

- (void)openFlickr {
  Location *location = [[LocationController sharedInstance] lastKnownLocation];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.flickr.com/nearby/%f,%f", location.coordinate.latitude, location.coordinate.longitude]];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)openGoogleMaps {
  Location *location = [[LocationController sharedInstance] lastKnownLocation];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.google.com/?q=%f,%f", location.coordinate.latitude, location.coordinate.longitude]];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)openOpenStreetMap {
  Location *location = [[LocationController sharedInstance] lastKnownLocation];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.openstreetmap.org/?lat=%f&lon=%f&zoom=15&layers=B000FTF", location.coordinate.latitude, location.coordinate.longitude]];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)openYahoo {
  Location *location = [[LocationController sharedInstance] lastKnownLocation];
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.yahoo.com/?lat=%f&lon=%f&zoom=16", location.coordinate.latitude, location.coordinate.longitude]];
  [[NSWorkspace sharedWorkspace] openURL:url];
}

- (void)quit {
  [[NSApplication sharedApplication] terminate:self];
}

- (void)timerBeginsIdling:(id)sender {
  NSLog(@"Clarke began idling");
  isIdle = YES;
}

- (void)timerFinishedIdling:(id)sender {
  NSLog(@"Clarke awoke from idling");
  isIdle = NO;
  
  if ([self shouldPauseUpdatesWhenIdle]) {
    [locationController refreshLocation];
  }
}

- (BOOL)shouldPauseUpdatesWhenIdle {
  return [[NSUserDefaults standardUserDefaults] boolForKey:@"pauseUpdatesWhenIdle"];
}

@end
