/*
 RHSystemIdleTimer.h
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
 
 References:
 http://www.cocoadev.com/index.pl?GettingSystemIdleTime
 http://www.cocoabuilder.com/archive/message/cocoa/2004/10/27/120354
 http://www.zathras.de/angelweb/sourcecode.htm (UKIdleTimer)
 */

#import <Cocoa/Cocoa.h>

@interface RHSystemIdleTimer : NSObject {
	NSTimer *idleTimer, *continuingIdleTimer;
	id delegate;
	NSTimeInterval timeInterval;
@private
	mach_port_t masterPort;
	io_iterator_t iter;
	io_registry_entry_t curObj;	
}
- (id)initSystemIdleTimerWithTimeInterval:(NSTimeInterval)ti;
- (int)systemIdleTime;
- (id)delegate;
- (void)setDelegate:(id)receiver;
- (void)invalidate;
@end

@interface RHSystemIdleTimer(Delegates)
-(void)timerBeginsIdling:(id)sender;
-(void)timerContinuesIdling:(id)sender;
-(void)timerFinishedIdling:(id)sender;
@end
