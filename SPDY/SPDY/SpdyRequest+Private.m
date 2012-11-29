#import "SpdyRequest+Private.h"
#import "SpdyHTTPResponse.h"

@implementation SpdyRequest (Private)

-(void)doStreamCloseCallback {
  if(self.streamCloseCallback != nil) {
    self.streamCloseCallback();
  }
}

// XXX refactor the common parts of these two methods
-(void)doSpdyPushCallbackWithMessage:(CFHTTPMessageRef)message andStreamId:(int32_t)streamId {
  CFDataRef b = CFHTTPMessageCopyBody(message);
  NSData * body = (__bridge NSData *)b;
  CFRelease(b);
  SpdyHTTPResponse * spdy_message = [SpdyHTTPResponse responseWithURL:self.URL
						      andMessage:message];

  spdy_message.streamId = streamId;
  if(self.pushSuccessCallback != nil) {
    self.pushSuccessCallback(spdy_message, body);
  } else {
    SPDY_LOG(@"dropping response w/ nil callback");
  }
}

-(void)doSuccessCallbackWithMessage:(CFHTTPMessageRef)message {
  CFDataRef b = CFHTTPMessageCopyBody(message);
  NSData * body = (__bridge NSData *)b;
  CFRelease(b);
  SpdyHTTPResponse * spdy_message = [SpdyHTTPResponse responseWithURL:self.URL
						      andMessage:message];
  if(self.successCallback != nil) {
    self.successCallback(spdy_message, body);
  } else {
    SPDY_LOG(@"dropping response w/ nil callback");
  }
}

@end

