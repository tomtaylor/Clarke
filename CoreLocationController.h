//
//  CoreLocationController.h
//  firehook
//
//  Created by Tom Taylor on 10/09/2009.
//  Copyright 2009 Really Interesting Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "BaseLocationController.h"
#import <CoreLocation/CoreLocation.h>

@interface CoreLocationController : BaseLocationController <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
}

@end
