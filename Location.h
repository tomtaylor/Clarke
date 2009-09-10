#import <Cocoa/Cocoa.h>
#import <CoreLocation/CoreLocation.h>

//#if __MAC_OS_X_VERSION_MIN_REQUIRED < 1060
//
//typedef double CLLocationDegrees;
//
//typedef struct {
//	CLLocationDegrees latitude;
//	CLLocationDegrees longitude;
//} CLLocationCoordinate2D;
//
//#endif

@interface Location : NSObject {
	CLLocationCoordinate2D coordinate;
	NSDate *timestamp;
}

@property CLLocationCoordinate2D coordinate;
@property (retain) NSDate *timestamp;

-(double)distanceFrom:(Location *)otherLocation;

@end