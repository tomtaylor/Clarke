#import <Cocoa/Cocoa.h>
#import <Security/Security.h>
#import <OAuthConsumer/OAuthConsumer.h>
#import <OAuthConsumer/OAToken_KeychainExtensions.h>
#import "Location.h"

@interface FireEagleController : NSObject {
  NSMutableArray *delegates;
  OAConsumer *consumer;
  OAToken *accessToken;
  OAToken *requestToken;
  
  NSDate *lastUpdateAt;
}

@property (retain) OAConsumer *consumer;
@property (readonly) NSDate *lastUpdateAt;

+ (FireEagleController *)sharedInstance;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

- (void)getRequestToken;
- (NSURL *)getAuthorizeURL;
- (void)getAccessTokenWithVerifier:(NSString *)oauthVerifier;
- (void)updateLocation:(Location *)location;

- (BOOL)hasRequestToken;
- (BOOL)hasAccessToken;
- (void)logout;

@end

@protocol FireEagleControllerDelegate

@optional

- (void)accessTokenDidFinish;
- (void)accessTokenDidFailWithError:(NSError *)error;
- (void)requestTokenDidFinish;
- (void)requestTokenDidFailWithError:(NSError *)error;

- (void)fireEagleUpdateDidStart;
- (void)fireEagleUpdateDidFinish;
- (void)fireEagleUpdateDidFailWithError:(NSError *)error;

@end

