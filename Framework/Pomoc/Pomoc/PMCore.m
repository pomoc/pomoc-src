//
//  PM_Core.m
//  Pomoc
//
//  Created by Soon Chun Mun on 21/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMCore.h"
#import "SocketIO.h"
#import "SocketIOPacket.h"

@interface PMCore () <SocketIODelegate>

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) SocketIO *socket;
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
        core.socket = [[SocketIO alloc] initWithDelegate:core];
        
        [core connect];
    }
}

#pragma mark - Initialization with Server

- (void)connect {
    // Check socket ready state
    [self.socket connectToHost:WS_SERVER_URL onPort:PORT];
}

- (BOOL)authenticate:(NSDictionary *)creds {
    return NO;
}

#pragma mark - SocketIODelegate methods

- (void) socketIODidConnect:(SocketIO *)socket {
    NSLog(@"Connected");
}

- (void) socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error {
    NSLog(@"Disconnected");
}

- (void) socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet {
    NSLog(@"Received Message:\npid: %@\ntype: %@\nname: %@\ndata: %@", packet.pId, packet.type, packet.name, packet.data);
}

- (void) socketIO:(SocketIO *)socket didReceiveJSON:(SocketIOPacket *)packet {
    NSLog(@"Received Json:\npid: %@\ntype: %@\nname: %@\ndata: %@", packet.pId, packet.type, packet.name, packet.data);
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet {
    NSLog(@"Received Event:\npid: %@\ntype: %@\nname: %@\ndata: %@", packet.pId, packet.type, packet.name, packet.data);
}

- (void) socketIO:(SocketIO *)socket didSendMessage:(SocketIOPacket *)packet {
    NSLog(@"Sent Message:\npid: %@\ntype: %@\nname: %@\ndata: %@", packet.pId, packet.type, packet.name, packet.data);
}

- (void) socketIO:(SocketIO *)socket onError:(NSError *)error {
    NSLog(@"%@", error);
}



@end
