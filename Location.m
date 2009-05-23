#import "Location.h"

@implementation Location

@synthesize coordinate;
@synthesize timestamp;

- (NSString *)description {
  return [NSString stringWithFormat:@"%f, %f at %@", self.coordinate.latitude, self.coordinate.longitude, self.timestamp];
}

@end
