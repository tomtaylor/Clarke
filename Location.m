#import "Location.h"

@interface Location(Private)

- (double)degreesToRadians:(double)degrees;

@end

@implementation Location

@synthesize coordinate;
@synthesize timestamp;

- (NSString *)description {
  return [NSString stringWithFormat:@"%f, %f at %@", self.coordinate.latitude, self.coordinate.longitude, self.timestamp];
}

// Stolen from: http://www.jaimerios.com/?p=39
// returns km
- (double)distanceFrom:(Location *)otherLocation {
	double nLat1 = self.coordinate.latitude;
	double nLon1 = self.coordinate.longitude;
	
	double nLat2 = otherLocation.coordinate.latitude;
	double nLon2 = otherLocation.coordinate.longitude;
	
	double nRadius = 6371; // Earth's radius in Kilometers
	// Get the difference between our two points
	// then convert the difference into radians
	
	double nDLat = [self degreesToRadians:(nLat2 - nLat1)];
	double nDLon = [self degreesToRadians:(nLon2 - nLon1)];
	
	// Here is the new line
	nLat1 = [self degreesToRadians:nLat1];
	nLat2 = [self degreesToRadians:nLat2];
	
	double nA = pow ( sin(nDLat/2), 2 ) + cos(nLat1) * cos(nLat2) * pow ( sin(nDLon/2), 2 );
	
	double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
	double nD = nRadius * nC;
	
	return nD; // Return our calculated distance
}

- (double)degreesToRadians:(double)degrees {
	return degrees * M_PI / 180;
}

@end
