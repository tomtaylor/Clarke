#import "FireEagleController.h"

#define FIRE_EAGLE_CONSUMER_KEY @"LNyiFbx5GbE8"
#define FIRE_EAGLE_CONSUMER_SECRET @"Igx5yjtDkmxgsY3CEMLY60AIpmMLTFEX"
#define FIRE_EAGLE_KEYCHAIN_APP_NAME @"Clarke"
#define FIRE_EAGLE_KEYCHAIN_SERVICE_PROVIDER @"Fire Eagle"

@interface FireEagleController(Private)

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error;

@end


@implementation FireEagleController

@synthesize consumer;
@synthesize lastUpdateAt;

- (id)init {
  self = [super init];
  if (self != nil) {
    delegates = [[NSMutableArray alloc] init];
    
    NSAppleEventManager *appleEventManager = [NSAppleEventManager sharedAppleEventManager];// 1
    [appleEventManager setEventHandler:self andSelector:@selector(handleGetURLEvent:withReplyEvent:) forEventClass:kInternetEventClass andEventID:kAEGetURL];
    
    self.consumer = [[OAConsumer alloc] initWithKey:FIRE_EAGLE_CONSUMER_KEY secret:FIRE_EAGLE_CONSUMER_SECRET];
    accessToken = [[OAToken alloc] initWithKeychainUsingAppName:FIRE_EAGLE_KEYCHAIN_APP_NAME
                                             serviceProviderName:FIRE_EAGLE_KEYCHAIN_SERVICE_PROVIDER];
    
    if (accessToken != nil) {
      NSLog(@"Did load access token from keychain");
    }
    
  }
  return self;
}

- (void)getRequestToken {
  NSURL *url = [NSURL URLWithString:@"https://fireeagle.yahooapis.com/oauth/request_token"];
  
  OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                 consumer:self.consumer
                                                                    token:nil   // we don't have a Token yet
                                                                    realm:nil   // our service provider doesn't specify a realm
                                                        signatureProvider:nil]; // use the default method, HMAC-SHA1
  
  [request setHTTPMethod:@"POST"];
  
  OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:request
                                                                                        delegate:self
                                                                               didFinishSelector:@selector(requestTokenTicket:didFinishWithData:)
                                                                                 didFailSelector:@selector(requestTokenTicket:didFailWithError:)];
  
  [request release];
  [fetcher start];
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
  if (ticket.didSucceed) {
    NSLog(@"Request token ticket did succeed.");
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    requestToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    [responseBody release];
    
    for (id delegate in delegates) {
      if ([delegate respondsToSelector:@selector(requestTokenDidFinish)]) {
        [delegate performSelectorOnMainThread:@selector(requestTokenDidFinish) withObject:nil waitUntilDone:YES];
      }
    }
  }
}

- (void)requestTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
  NSLog(@"Request token ticket did fail: %@", error);
  
  for (id delegate in delegates) {
    if ([delegate respondsToSelector:@selector(requestTokenDidFailWithError:)]) {
      [delegate performSelectorOnMainThread:@selector(requestTokenDidFailWithError:) withObject:error waitUntilDone:YES];
    }
  }
}

- (NSURL *)getAuthorizeURL {
  NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://fireeagle.yahoo.net/oauth/authorize?oauth_token=%@", requestToken.key]];
  return url;
}

- (BOOL)hasRequestToken {
  return requestToken != nil;
}

- (BOOL)hasAccessToken {
  return accessToken != nil;
}

- (void)getAccessToken {
  NSURL *url = [NSURL URLWithString:@"https://fireeagle.yahooapis.com/oauth/access_token"];
  
  OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                 consumer:self.consumer
                                                                    token:requestToken
                                                                    realm:nil   // our service provider doesn't specify a realm
                                                        signatureProvider:nil]; // use the default method, HMAC-SHA1
  
  [request setHTTPMethod:@"POST"];
  
  OAAsynchronousDataFetcher *fetcher = [OAAsynchronousDataFetcher asynchronousFetcherWithRequest:request
                                 delegate:self
                        didFinishSelector:@selector(accessTokenTicket:didFinishWithData:)
                          didFailSelector:@selector(accessTokenTicket:didFailWithError:)];
  
  [request release];
  [fetcher start];
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data {
  if (ticket.didSucceed) {
    
    NSString *responseBody = [[NSString alloc] initWithData:data
                                                   encoding:NSUTF8StringEncoding];
    accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
    [responseBody release];
    
    [accessToken storeInDefaultKeychainWithAppName:FIRE_EAGLE_KEYCHAIN_APP_NAME
                               serviceProviderName:FIRE_EAGLE_KEYCHAIN_SERVICE_PROVIDER];
    
    for (id delegate in delegates) {
      if ([delegate respondsToSelector:@selector(accessTokenDidFinish)]) {
        [delegate performSelectorOnMainThread:@selector(accessTokenDidFinish) withObject:nil waitUntilDone:YES];
      }
    }
    
    NSLog(@"Access token did finish");
  } else {
    NSLog(@"Access token did not succeed.");
    NSError *error = [[[NSError alloc] initWithDomain:@"Access token failed" code:0 userInfo:nil] autorelease];
    [self accessTokenTicket:ticket didFailWithError:error];
  }
}

- (void)accessTokenTicket:(OAServiceTicket *)ticket didFailWithError:(NSError *)error {
  [requestToken release];
  requestToken = nil;
  
  for (id delegate in delegates) {
    if ([delegate respondsToSelector:@selector(accessTokenDidFailWithError:)]) {
      [delegate performSelectorOnMainThread:@selector(accessTokenDidFailWithError:) withObject:error waitUntilDone:YES];
    }
  }
      
  //[delegate accessTokenDidFailWithError:error];
  NSLog(@"Access token ticket did fail: %@", error);
}

- (void)updateLocation:(Location *)location {
  
  for (id delegate in delegates) {
    if ([delegate respondsToSelector:@selector(fireEagleUpdateDidStart)]) {
      [delegate performSelectorOnMainThread:@selector(fireEagleUpdateDidStart) withObject:nil waitUntilDone:YES];
    }
  }
  
  [self performSelectorInBackground:@selector(updateLocationInBackground:) withObject:location];
}

- (void)updateLocationInBackground:(Location *)location {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  
  NSLog(@"Updating Fire Eagle location");
  
  NSURL *url = [NSURL URLWithString:@"https://fireeagle.yahooapis.com/api/0.1/update"];
  
  OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url
                                                                 consumer:self.consumer
                                                                    token:accessToken
                                                                    realm:nil   // our service provider doesn't specify a realm
                                                        signatureProvider:nil]; // use the default method, HMAC-SHA1
  
  OARequestParameter *latitudeParam = [[OARequestParameter alloc] initWithName:@"lat" 
                                                                         value:[NSString stringWithFormat:@"%f", location.coordinate.latitude]];
  OARequestParameter *longitudeParam = [[OARequestParameter alloc] initWithName:@"lon" value:[NSString stringWithFormat:@"%f", location.coordinate.longitude]];
  
  [request setHTTPMethod:@"POST"]; // always change HTTP method before setting params
  [request setParameters:[NSArray arrayWithObjects:latitudeParam, longitudeParam, nil]];
  [latitudeParam release];
  [longitudeParam release];
  
  OADataFetcher *fetcher = [[[OADataFetcher alloc] init] autorelease];
  [fetcher fetchDataWithRequest:request                 
                       delegate:self 
              didFinishSelector:@selector(serviceTicket:didUpdateLocationWithData:) 
                didFailSelector:@selector(serviceTicket:didFailToUpdateLocationWithError:)];

  [request release];
  [pool release];
}

- (void)serviceTicket:(OAServiceTicket *)ticket didUpdateLocationWithData:(NSData *)data {
  //fireEagleUpdateInProgress = NO;
  NSLog(@"Fire Eagle location updated successfully");
  
  for (id delegate in delegates) {
    if ([delegate respondsToSelector:@selector(fireEagleUpdateDidFinish)]) {
      [delegate performSelectorOnMainThread:@selector(fireEagleUpdateDidFinish) withObject:nil waitUntilDone:YES];
    }
  }
  
  [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastFireEagleUpdateAt"];
}

- (void)serviceTicket:(OAServiceTicket *)ticket didFailToUpdateLocationWithError:(NSError *)error {
  NSLog(@"Fire Eagle location failed to update with error: %@", error);
  
  for (id delegate in delegates) {
    if ([delegate respondsToSelector:@selector(fireEagleUpdateDidFailWithError:)]) {
      [delegate performSelectorOnMainThread:@selector(fireEagleUpdateDidFailWithError:) withObject:error waitUntilDone:YES];
    }
  }
}

- (void)logout {
  NSString *service = [NSString stringWithFormat:@"%@::OAuth::%@", FIRE_EAGLE_KEYCHAIN_APP_NAME, FIRE_EAGLE_KEYCHAIN_SERVICE_PROVIDER];
  NSString *account = accessToken.key;
  UInt32 existingPasswordLength;
  char* existingPasswordData;
  SecKeychainItemRef existingItem;
  
  SecKeychainRef keychain;
  SecKeychainCopyDefault(&keychain);
  
  // ...get the existing password and a reference to the existing keychain item, then...
  int error = SecKeychainFindGenericPassword(keychain, strlen([service UTF8String]), [service UTF8String], strlen([account UTF8String]), [account UTF8String], &existingPasswordLength, (void **)&existingPasswordData, &existingItem);
  
  if (error == 0 && existingItem) {
    error = SecKeychainItemDelete(existingItem);
  }
  
  // ...free the memory allocated in call to SecKeychainFindGenericPassword() above
  SecKeychainItemFreeContent(NULL, existingPasswordData);
  
  if (existingItem) {
    CFRelease(existingItem);
  }
}

- (void)addDelegate:(id)delegate {
  @synchronized(delegates) {
    [delegates addObject:delegate];
  }
}

- (void)removeDelegate:(id)delegate {
  @synchronized(delegates) {
    [delegates removeObject:delegate];
  }
}

- (NSDate *)lastUpdateAt {
  return [[NSUserDefaults standardUserDefaults] objectForKey:@"lastFireEagleUpdateAt"];
}

static FireEagleController *sharedFireEagleController = nil;

+ (FireEagleController *)sharedInstance
{
  @synchronized(self) {
    if (sharedFireEagleController == nil) {
      sharedFireEagleController = [[FireEagleController alloc] init]; // assignment not done here
    }
  }
  return sharedFireEagleController;
}


@end
