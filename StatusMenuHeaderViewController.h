#import <Cocoa/Cocoa.h>
#import "FireEagleController.h"

@interface StatusMenuHeaderViewController : NSViewController <FireEagleControllerDelegate> {
  IBOutlet NSTextField *currentLocationLabel;
  IBOutlet NSTextField *updatedAtLabel;
  IBOutlet NSImageView *locationIcon;
  IBOutlet NSProgressIndicator *locationSpinner;
  
  IBOutlet NSProgressIndicator *fireEagleSpinner;
  IBOutlet NSImageView *fireEagleIcon;
  IBOutlet NSTextField *fireEagleLabel;
}

- (void)viewWillAppear;

- (void)configureViewForLocation:(Location *)location;
- (void)configureViewForError:(NSError *)error;

@end
