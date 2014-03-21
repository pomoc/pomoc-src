//
//  PM_Core.h
//  Pomoc
//
//  Created by Soon Chun Mun on 21/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"

@interface PM_Core : NSObject <SRWebSocketDelegate>
@property NSString *AppID;
@property NSURL *url;
@property SRWebSocket *socket;

- (id)initWithAppID:(NSString *)AppID;
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;

@end
