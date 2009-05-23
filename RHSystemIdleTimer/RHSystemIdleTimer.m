/*
 RHSystemIdleTimer.m
 Created by Ryan Homer on 2007-06-04.
 Copyright (C) 2007 Ryan Homer.
 http://www.ryanhomer.com

 This library is free software; you can redistribute it and/or
 modify it under the terms of the GNU Lesser General Public
 License as published by the Free Software Foundation; either
 version 2.1 of the License, or (at your option) any later version.
 
 This library is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 Lesser General Public License for more details.
 
 You should have received a copy of the GNU Lesser General Public
 License along with this library; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 http://www.gnu.org/licenses/lgpl.html
*/

#import "RHSystemIdleTimer.h"

@interface RHSystemIdleTimer(Private)
- (void)checkIdleStatus;
- (void)checkIfStillIdle;
@end

@implementation RHSystemIdleTimer

#pragma mark Initilization/Dealloc

- (id)initSystemIdleTimerWithTimeInterval:(NSTimeInterval)ti
{
	self = [super init];
	if(self) {
		
		IOMasterPort(MACH_PORT_NULL, &masterPort);
		
		/* Get IOHIDSystem */
		IOServiceGetMatchingServices(masterPort, IOServiceMatching("IOHIDSystem"), &iter);
		if (iter == 0) {
			NSLog(@"Error accessing IOHIDSystem\n");
		}
		else {
			curObj = IOIteratorNext(iter);
			
			if (curObj == 0) {
				NSLog(@"Iterator's empty!\n");
			}
		}
		
		timeInterval = ti;				
		idleTimer = [NSTimer scheduledTimerWithTimeInterval:ti
													 target:self
												   selector:@selector(checkIdleStatus)
												   userInfo:nil
													repeats:NO];
	}
	return self;
}

- (void) dealloc {
	IOObjectRelease(curObj);
	IOObjectRelease(iter);
	[super dealloc];
}

#pragma mark Accessors

- (id)delegate
{
	return delegate;
}

- (void)setDelegate:(id)receiver
{
	delegate = receiver;
}

#pragma mark Private Methods

- (void)checkIdleStatus
{
	double idleTime = [self systemIdleTime];
    double timeLeft = timeInterval - idleTime;
    if(timeLeft <= 0) {
		
		if([delegate respondsToSelector:@selector(timerBeginsIdling:)]) {
			[delegate timerBeginsIdling:self];			
		}
		
		[NSTimer scheduledTimerWithTimeInterval:1.0
										 target:self
									   selector:@selector(checkIfStillIdle)
									   userInfo:nil
										repeats:NO];
		
		if([delegate respondsToSelector:@selector(timerContinuesIdling:)]) {
			continuingIdleTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
																   target:delegate
																 selector:@selector(timerContinuesIdling:)
																 userInfo:nil
																  repeats:YES];
		}		
	}
    else {
		idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeLeft
													 target:self
												   selector:@selector(checkIdleStatus)
												   userInfo:nil
													repeats:NO];
	}
}

- (void)checkIfStillIdle
{
	double idleTime = [self systemIdleTime];
    if(idleTime <= 1.0) {
		[continuingIdleTimer invalidate];
		
		if([delegate respondsToSelector:@selector(timerFinishedIdling:)]) {
			[delegate timerFinishedIdling:self];			
		}

		// reset; start checking for system idle time again
		idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval
										 target:self
									   selector:@selector(checkIdleStatus)
									   userInfo:nil
										repeats:NO];
	}
	else {
		[NSTimer scheduledTimerWithTimeInterval:1.0
										 target:self
									   selector:@selector(checkIfStillIdle)
									   userInfo:nil
										repeats:NO];
	}
}

#pragma mark Public Methods

- (void)invalidate
{
	[idleTimer invalidate];	
}

- (int)systemIdleTime
{		
	CFMutableDictionaryRef properties = 0;
	CFTypeRef obj;
	
	if (IORegistryEntryCreateCFProperties(curObj, &properties, kCFAllocatorDefault, 0) == KERN_SUCCESS && properties != NULL) {
		obj = CFDictionaryGetValue(properties, CFSTR("HIDIdleTime"));
		CFRetain(obj);
	} else {
		NSLog(@"Couldn't grab properties of system\n");
		obj = NULL;
	}
	
	uint64_t tHandle = 0;
	if (obj) {
		CFTypeID type = CFGetTypeID(obj);
		
		if (type == CFDataGetTypeID()) {
			CFDataGetBytes((CFDataRef) obj, CFRangeMake(0, sizeof(tHandle)), (UInt8*) &tHandle);
		}
		else if (type == CFNumberGetTypeID()) {
			CFNumberGetValue((CFNumberRef)obj, kCFNumberSInt64Type, &tHandle);
		}
		else {
			NSLog(@"%d: unsupported type\n", (int)type);
		}
		
		CFRelease(obj);
		
		tHandle >>= 30; // essentially divides by 10^9 (nanoseconds)
	}
	else {
		NSLog(@"Can't find idle time\n");
	}
	
	CFRelease((CFTypeRef)properties);		
	return tHandle;
}

@end
