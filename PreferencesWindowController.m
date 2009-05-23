#import "PreferencesWindowController.h"
#import "FirehookApplicationDelegate.h"

@interface PreferencesWindowController(Private)

@end


@implementation PreferencesWindowController

- (id) init {
  self = [super init];
  if (self != nil) {
    [self initWithWindowNibName:@"Preferences"];
    theFireEaglePreferencesController = [[FireEaglePreferencesViewController alloc] init];
    theGeneralPreferencesController = [[GeneralPreferencesViewController alloc] init];
    theAboutPreferencesController = [[AboutPreferencesViewController alloc] init];
  }
  return self;
}

- (void) dealloc {
  [theFireEaglePreferencesController release];
  [theGeneralPreferencesController release];
  [theAboutPreferencesController release];
  [theToolbar release];
  [super dealloc];
}

- (void) awakeFromNib {
  // create the toolbar object
  theToolbar = [[NSToolbar alloc] initWithIdentifier:@"Preferences Toolbar"];
  
  // set initial toolbar properties
  [theToolbar setAllowsUserCustomization:NO];
  [theToolbar setAutosavesConfiguration:YES];
  [theToolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
  
  // set our controller as the toolbar delegate
  [theToolbar setDelegate:self];
  
  // attach the toolbar to our window
  [self.window setToolbar:theToolbar];
  
  // clean up
  [theToolbar release];
  
  [self selectGeneral:self];
}

#pragma mark NSToolbarDelegate

static NSString *GeneralToolbarItemIdentifier = @"General Toolbar Item";
static NSString *FireEagleToolbarItemIdentifier = @"Fire Eagle Toolbar Item";
static NSString *AboutToolbarItemIdentifier = @"About Toolbar Item";

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
  return [NSArray arrayWithObjects:GeneralToolbarItemIdentifier, 
          FireEagleToolbarItemIdentifier,
          NSToolbarFlexibleSpaceItemIdentifier,
          AboutToolbarItemIdentifier,
          nil];
}

- (NSArray *) toolbarDefaultItemIdentifiers: (NSToolbar *)toolbar {
  return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
  return [self toolbarAllowedItemIdentifiers:toolbar];
}
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
     itemForItemIdentifier:(NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag
{
  NSToolbarItem *toolbarItem = nil;
  toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
  [toolbarItem setTarget:self];
  
  if ([itemIdentifier isEqualTo:GeneralToolbarItemIdentifier]) {
    toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    [toolbarItem setLabel:@"General"];
    [toolbarItem setPaletteLabel:[toolbarItem label]];
    [toolbarItem setToolTip:@"General Preferences"];
    [toolbarItem setImage:[NSImage imageNamed:@"NSPreferencesGeneral"]];
    [toolbarItem setAction:@selector(selectGeneral:)];
    //[toolbarItem setAction:@selector(save:)];
  } else if ([itemIdentifier isEqualTo:FireEagleToolbarItemIdentifier]) {
    [toolbarItem setLabel:@"Fire Eagle"];
    [toolbarItem setPaletteLabel:[toolbarItem label]];
    [toolbarItem setToolTip:@"Fire Eagle Preferences"];
    [toolbarItem setImage:[NSImage imageNamed:@"fireeagle-phoenix.png"]];
    [toolbarItem setAction:@selector(selectFireEagle:)];
  } else if ([itemIdentifier isEqualTo:AboutToolbarItemIdentifier]) {
    [toolbarItem setLabel:@"About"];
    [toolbarItem setPaletteLabel:[toolbarItem label]];
    [toolbarItem setToolTip:@"About"];
    [toolbarItem setImage:[NSImage imageNamed:@"clarke-icon.icns"]];
    [toolbarItem setAction:@selector(selectAbout:)];
  }
  
  return [toolbarItem autorelease];
}

- (void)selectGeneral:(id)sender {
  [theToolbar setSelectedItemIdentifier:GeneralToolbarItemIdentifier];
  [[self window] setContentView:[theGeneralPreferencesController view]];
}

- (void)selectFireEagle:(id)sender {
  [theToolbar setSelectedItemIdentifier:FireEagleToolbarItemIdentifier];
  [[self window] setContentView:[theFireEaglePreferencesController view]];
}

- (void)selectAbout:(id)sender {
  [theToolbar setSelectedItemIdentifier:AboutToolbarItemIdentifier];
  [[self window] setContentView:[theAboutPreferencesController view]];  
}

@end
