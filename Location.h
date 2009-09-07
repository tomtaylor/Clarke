#import <Cocoa/Cocoa.h>

typedef double CLLocationDegrees;

typedef struct {
	CLLocationDegrees latitude;
	CLLocationDegrees longitude;
} CLLocationCoordinate2D;

@interface Location : NSObject {
	CLLocationCoordinate2D coordinate;
	NSDate *timestamp;
}

@property CLLocationCoordinate2D coordinate;
@property (retain) NSDate *timestamp;

-(double)distanceFrom:(Location *)otherLocation;

@end