#import "StatusMenuHeaderViewController.h"
#import "Location.h"
#import "SkyhookLocationController.h"
#import "FireEagleController.h"
#import "wpsapi.h"

@interface StatusMenuHeaderViewController(Private)

- (void)configureViewForLocation:(Location *)location;
- (void)configureViewForError:(NSError *)error;
- (void)setLocationSpinnerForUpdateStatus:(BOOL)updateInProgress;
- (void)setFireEagleSpinnerForUpdateStatus:(BOOL)updateInProgress;


@end

@implementation StatusMenuHeaderViewController

- (id) init {
	self = [super init];
	if (self != nil) {
		[self initWithNibName:@"StatusMenu" bundle:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationDidChange:) name:UpdatedLocationNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationUpdateDidFail:) name:FailedLocationUpdateNotification object:nil];
		
		[[SkyhookLocationController sharedInstance] addObserver:self forKeyPath:@"updateInProgress" options:NSKeyValueObservingOptionNew context:NULL];
		[[FireEagleController sharedInstance] addDelegate:self];
	}
	return self;
}

- (void)viewWillAppear {
	
	if (![[FireEagleController sharedInstance] hasAccessToken]) {
		[fireEagleLabel setStringValue:@"Not signed in"];
	} else if ([[FireEagleController sharedInstance] lastUpdateAt] == nil) {
		[fireEagleLabel setStringValue:@"Updating shortly"];
	} else {    
		NSString *timeString = [NSDate stringForDisplayFromDate:[[FireEagleController sharedInstance] lastUpdateAt] prefixed:YES];
		[fireEagleLabel setStringValue:[NSString stringWithFormat:@"Updated %@", timeString]];
	}     
	
	[updatedAtLabel setFont:[NSFont systemFontOfSize:10]];
	[updatedAtLabel setTextColor:[NSColor grayColor]];
	
	if ([[SkyhookLocationController sharedInstance] lastUpdateError]) {
		[self configureViewForError:[[SkyhookLocationController sharedInstance] lastUpdateError]];
	} else if ([[SkyhookLocationController sharedInstance] lastKnownLocation]) {
		[self configureViewForLocation:[[SkyhookLocationController sharedInstance] lastKnownLocation]];
	}
	// spinner will only animate if view is drawn
	[locationSpinner performSelector:@selector(startAnimation:)
						  withObject:self
						  afterDelay:0.0
							 inModes:[NSArray 
									  arrayWithObject:NSEventTrackingRunLoopMode]];
	
	[fireEagleSpinner performSelector:@selector(startAnimation:)
						   withObject:self
						   afterDelay:0.0
							  inModes:[NSArray 
									   arrayWithObject:NSEventTrackingRunLoopMode]];
	
}

- (void)locationDidChange:(NSNotification *)notification {
	Location *location = notification.object;
	[self configureViewForLocation:location];
}

- (void)locationUpdateDidFail:(NSNotification *)notification {
	NSError *error = notification.object;
	[self configureViewForError:error];
}

- (void)configureViewForLocation:(Location *)location {
	[currentLocationLabel setStringValue:[NSString stringWithFormat:@"%0.4f, %0.4f", location.coordinate.latitude, location.coordinate.longitude]];
	
	NSString *timeString = [NSDate stringForDisplayFromDate:[location timestamp] prefixed:YES];  
	[updatedAtLabel setStringValue:[NSString stringWithFormat:@"%@", timeString]];
}

- (void)configureViewForError:(NSError *)error {
	NSString *errorText;
	
	switch (error.code) {
		case WPS_ERROR_NO_WIFI_IN_RANGE:
			errorText = @"No wifi in range";
			break;
		case WPS_ERROR_WIFI_NOT_AVAILABLE:
			errorText = @"Airport is disabled";
			break;
		case WPS_ERROR_SERVER_UNAVAILABLE:
			errorText = @"Server unavailable";
			break;
		case WPS_ERROR_TIMEOUT:
			errorText = @"Timed out";
			break;
		case WPS_ERROR_LOCATION_CANNOT_BE_DETERMINED:
			errorText = @"Unknown location";
			break;
		default:
			errorText = @"Unknown error";
			break;
	}
	
	[currentLocationLabel setStringValue:errorText];
	
	//NSString *timeString = [NSDate stringForDisplayFromDate:[NSDate date] prefixed:YES];
	//[updatedAtLabel setStringValue:[NSString stringWithFormat:@"Update failed %@", timeString]];
	[updatedAtLabel setStringValue:@""];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
	if ([object isEqual:[SkyhookLocationController sharedInstance]]) {
		BOOL locationUpdateInProgress = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		[self setLocationSpinnerForUpdateStatus:locationUpdateInProgress];
	}
}

#pragma mark FireEagleControllerDelegate

- (void)fireEagleUpdateDidStart {
	[fireEagleIcon setHidden:YES];
	[fireEagleSpinner setHidden:NO];
}

- (void)fireEagleUpdateDidFinish {
	//  NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init]  autorelease];
	//  [dateFormatter setDateStyle:NSDateFormatterNoStyle];
	//  [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	//  NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
	//  
	//  [fireEagleLabel setStringValue:[NSString stringWithFormat:@"Updated at %@", timeString]];
	
	NSString *timeString = [NSDate stringForDisplayFromDate:[NSDate date] prefixed:YES];
	[fireEagleLabel setStringValue:[NSString stringWithFormat:@"Updated %@", timeString]];
	[fireEagleIcon setHidden:NO];
	[fireEagleSpinner setHidden:YES];
}

- (void)fireEagleUpdateDidFailWithError:(NSError *)error {
	[fireEagleLabel setStringValue:@"Last update failed"];
	[fireEagleIcon setHidden:NO];
	[fireEagleSpinner setHidden:YES];
}

- (void)setLocationSpinnerForUpdateStatus:(BOOL)updateInProgress {
	if (updateInProgress) {
		[locationIcon setHidden:YES];
		[locationSpinner setHidden:NO];
		//[locationSpinner startAnimation:self];
	} else {
		[locationIcon setHidden:NO];
		[locationSpinner setHidden:YES];
		//[locationSpinner stopAnimation:self];
	}
}


@end
