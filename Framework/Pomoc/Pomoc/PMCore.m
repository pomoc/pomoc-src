//
//  PM_Core.m
//  Pomoc
//
//  Created by Soon Chun Mun on 21/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMCore.h"
#import "SRWebSocket.h"

@interface PMCore () <SRWebSocketDelegate>

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) SRWebSocket *socket;

@end

@implementation PMCore

+ (PMCore *)sharedInstance
{
    static PMCore *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (void)initWithAppID:(NSString *)appId {
    PMCore *core = [PMCore sharedInstance];
    if (!core.appId) {
        core.appId = appId;
        core.url = [NSURL URLWithString:@"ws://localhost:3217"];
        core.socket = [[SRWebSocket alloc] initWithURL:core.url];
        core.socket.delegate = core;
        
        [core connect];
    }
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
        NSString *msg = [NSString stringWithFormat:@"Unclean Socket Close\nError Code: %d\nReason: %@",code, reason];
        NSLog(@"%@", msg);
    }
}


@end
