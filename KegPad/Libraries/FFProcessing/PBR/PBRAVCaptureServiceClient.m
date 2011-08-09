//
//  PBRAVCaptureServiceClient.m
//  KegPad
//
//  Created by Gabriel Handford on 8/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PBRAVCaptureServiceClient.h"
#import "PBRDefines.h"

@interface PBRAVCaptureServiceClient ()
@property (retain, nonatomic) NSNetService *service;
- (void)_closeConnection;
@end


@implementation PBRAVCaptureServiceClient

@synthesize service=_service;

- (id)initWithService:(NSNetService *)service {
  if ((self = [super init])) {
    _service = [service retain];
  }
  return self;
}

- (void)dealloc {
  [self _closeConnection];
  [_service release];
  [super dealloc];
}

- (void)_closeConnection {
  _connection.delegate = nil;
  [_connection close];
  [_connection release];
  _connection = nil;
}

- (void)close {
  [self _closeConnection];
}

- (BOOL)connect {
  [self _closeConnection];  
  if (_service) {
    _connection = [[PBRConnection alloc] init];
    _connection.delegate = self;
    return [_connection openWithService:_service];
  }
  return NO;
}

- (void)connectionDidClose:(PBRConnection *)connection {
  [[self gh_proxyAfterDelay:4.0] reconnect];
}

- (void)connection:(PBRConnection *)connection didReadBytes:(uint8_t *)bytes length:(NSUInteger)length {
  [self readBytes:bytes length:length];
}

@end
