#import "SpdyRequest.h"
#import "SpdyRequest+Private.h"
#import "SpdyHTTPResponse.h"
#import "SpdyRequestCallback.h"
#import "SPDY.h"

@implementation SpdyRequest {
  SpdyRequestCallback * delegate;
  NSURLRequest *  ns_url_request;
  NSString * urlString;
}

-(NSString*)urlString {
  if(ns_url_request == nil) {
    return urlString;
  } else {
    return ns_url_request.URL.absoluteString;
  }
}

-(SpdyNetworkStatus)networkStatus {
  if(ns_url_request == nil) {
    return [[SPDY sharedSPDY] networkStatusForUrlString:urlString];
  } else {
    return [[SPDY sharedSPDY] networkStatusForRequest:ns_url_request];
  }
}

-(SpdyConnectState)connectState {
  if(ns_url_request == nil) {
    return [[SPDY sharedSPDY] connectStateForUrlString:urlString];
  } else {
    return [[SPDY sharedSPDY] connectStateForRequest:ns_url_request];
  }
}

- (void)sendPing {
  //SPDY_LOG(@"pinging");
  if(ns_url_request == nil) {
    [[SPDY sharedSPDY] pingUrlString:urlString callback:self.pingCallback];
  } else {
    [[SPDY sharedSPDY] pingRequest:ns_url_request callback:self.pingCallback];
  }
}

-(void)send {
  if(ns_url_request == nil) {
    [[SPDY sharedSPDY] fetch:urlString delegate:delegate voip:_voip];
  } else {
    [[SPDY sharedSPDY] fetchFromRequest:ns_url_request delegate:delegate voip:_voip];
  }
}

- (void)teardown {
  if(ns_url_request == nil) {
    [[SPDY sharedSPDY] teardown:urlString];
  } else {
    [[SPDY sharedSPDY] teardownForRequest:ns_url_request];
  }
}

- (id)initWithGETString:(NSString *)_urlString {
  self = [super init];
  if(self) {
    delegate = [[SpdyRequestCallback alloc] init:self];
    urlString = _urlString;
    self.URL = [[NSURL alloc] initWithString:urlString];
  }
  return self;
}

- (id)initWithRequest:(NSURLRequest *)request {
  self = [super init];
  if(self) {
    delegate = [[SpdyRequestCallback alloc] init:self];
    ns_url_request = request;
  }
  return self;
}

@end

