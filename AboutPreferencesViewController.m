#import "AboutPreferencesViewController.h"
#import "DSClickableURLTextField.h"

@implementation AboutPreferencesViewController

- (id)init {
  self = [super init];
  if (self != nil) {
    [self initWithNibName:@"AboutView" bundle:nil];
  }
  return self;
}

- (void)awakeFromNib {
  DSClickableURLTextField *aboutTextField = [[DSClickableURLTextField alloc] initWithFrame:NSMakeRect(20, 20, 440, 150)];
  
  NSData *data = [@"<body style='font-family: Helvetica; font-size: 12px'><p>Clarke was made by <a href='http://tomtaylor.co.uk'>Tom Taylor</a>. It uses <a href='http://www.skyhookwireless.com/'>Skyhook</a> for positioning, the <a href='http://code.google.com/p/oauthconsumer/'>OAuthConsumer framework</a> for interacting with <a href='http://fireeagle.yahoo.net/'>Fire Eagle</a>, and an icon from the <a href='http://www.pinvoke.com/'>Fugue icon set</a>.</p><p>Clarke is named after <a href='http://en.wikipedia.org/wiki/Arthur_C._Clarke'>Arthur C. Clarke</a>, author and futurist, who first posited the idea of a space elevator.</p><blockquote><em>\"'And what keeps it up?' said Grandma Josephine.<br />'Skyhooks,' said Mr Wonka.\"</em><br />&mdash;<a href='http://en.wikipedia.org/wiki/Charlie_and_the_Great_Glass_Elevator'>Charlie and the Great Glass Elevator</a></blockquote>" dataUsingEncoding:NSUTF8StringEncoding];
  NSAttributedString *htmlString = [[NSAttributedString alloc] initWithHTML:data documentAttributes:nil];
  [aboutTextField setAttributedStringValue:htmlString];
  [htmlString release];
  
  [aboutTextField setAlignment:NSCenterTextAlignment];
  [aboutTextField setBordered:NO];
  [aboutTextField setDrawsBackground:NO];
  [self.view addSubview:aboutTextField];
  [aboutTextField release];
  
  NSString *currentVersion = [NSString stringWithFormat: @"Clarke %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
  [clarkeVersion setStringValue:currentVersion];
}


@end
