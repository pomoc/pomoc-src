//
//  PM_Core.m
//  Pomoc
//
//  Created by Soon Chun Mun on 21/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PM_Core.h"

@implementation PM_Core

- (id)initWithAppID:(NSString *)AppID {
    self = [super init];
    if (self) {
        self.AppID = AppID;
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%s:%d", WS_SERVER_URL, PORT]];
        self.url = [NSURL URLWithString:@"ws://localhost:3217"];
        self.socket = [[SRWebSocket alloc] initWithURL:self.url];
        self.socket.delegate = self;
        [self connect];
    }
    return self;
}

#pragma mark - Initialization with Server
- (void)connect {
    // Check socket ready state
    [self.socket open];
}

- (BOOL)authenticate:(NSDictionary *)creds {
    return NO;
}

#pragma mark - SRWebSocketDelegate methods
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"Received Message");
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"Socket opened");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    if (!wasClean) {
        NSString *msg = [NSString stringWithFormat:@"Unclean Socket Close\nError Code: %ld\nReason: %@",code, reason];
        NSLog(msg);
    }
}


@end
