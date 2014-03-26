//
//  PomocCore.m
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMCore.h"

#import "SocketIO.h"
#import "SocketIOPacket.h"

#import "PMMessage.h"

@interface PMCore () <SocketIODelegate>

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) SocketIO *socket;
@property (nonatomic, weak) id<PMCoreDelegate> delegate;

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

+ (void)initWithAppID:(NSString *)appId delegate:(id<PMCoreDelegate>)delegate {
    PMCore *core = [PMCore sharedInstance];
    if (!core.appId) {
        core.appId = appId;
        core.socket = [[SocketIO alloc] initWithDelegate:core];
        core.delegate = delegate;
        
        [core connect];
    }
}

+ (void)startConversationWithUserId:(NSString *)userId completion:(void (^)(NSString *channelId))completion
{
    PMCore *core = [PMCore sharedInstance];

    PMMessage * message = [[PMMessage alloc] initWithUsername:userId
                                                        withChannel:core.appId
                                                           withType:MSG_TYPE_INIT
                                                        withMessage:@""];
    
    [core.socket sendEvent:@"init" withData:[message getJSONObject] andAcknowledge:^(id argsData) {
        PMMessage * response = [[PMMessage alloc] initWithJSONString: (NSString *)argsData];
        NSLog(@"init callback: %@", [response getJSONObject]);
        // TODO: set initialized channel id for user
        // STUB
        if (completion) {
            completion(response.channel);
        }
    }];
}

+ (void)sendMessage:(NSString *)message userId:(NSString *)userId channelId:(NSString *)channelId
{
    PMCore *core = [PMCore sharedInstance];
    PMMessage *pomocMessage = [[PMMessage alloc] initWithUsername:userId
                                                        withChannel:channelId
                                                           withType:MSG_TYPE_CHAT
                                                        withMessage:message];
    
    [core.socket sendJSON:[pomocMessage getJSONObject]];
}

- (void)connect
{
    [self.socket connectToHost:@"localhost" onPort:3217];
}

#pragma mark - SocketIO Delegate methods

- (void)socketIO:(SocketIO *)socket didReceiveMessage:(SocketIOPacket *)packet
{
    NSLog(@"didReceiveMessage >>> data: %@", packet.data);
    PMMessage *message = [[PMMessage alloc] initWithJSONString:packet.data];
    
    // Normal chat message
    if ([message.type isEqualToString:MSG_TYPE_CHAT]) {
        // TODO: display chat message
        // STUB
        if ([self.delegate respondsToSelector:@selector(didReceiveMessage:channelId:)]) {
            [self.delegate didReceiveMessage:message channelId:message.channel];
        }
    }
}


@end
