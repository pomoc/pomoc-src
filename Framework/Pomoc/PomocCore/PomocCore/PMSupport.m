//
//  PMSupport.m
//  PomocCore
//
//  Created by soedar on 6/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMSupport.h"
#import "PMCore.h"
#import "PMCore_Private.h"
#import "AFNetworking.h"
#import "PomocConstants.h"
#import "PMConversation+PMCore.h"
#import "PMConversation_Private.h"

@interface PMSupport () <PMCoreDelegate>

@property (nonatomic, weak) id<PMSupportDelegate> delegate;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *appToken;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic) BOOL isAgent;
@property (nonatomic, copy) void (^connectCallback)(BOOL connected);
@property (nonatomic, strong) PMConversation *agentConversation;

@end

@implementation PMSupport

+ (PMSupport *)sharedInstance
{
    static PMSupport *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

+ (void)initWithAppID:(NSString *)appId secretKey:(NSString *)secretKey
{
    [PMSupport sharedInstance].appToken = appId;
    [PMSupport sharedInstance].secretKey = secretKey;
}

+ (void)loginAgentWithUserId:(NSString *)userId
                    password:(NSString *)password
                  completion:(void (^)(NSString *))completion
{
    if ([PMSupport sharedInstance].userId) {
        NSLog(@"Can't login twice");
        if (completion) {
            completion(nil);
            return;
        }
    }
    
    [PMCore setDelegate:[PMSupport sharedInstance]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"userId": userId, @"password": password};
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%i/agentLogin", POMOC_URL, POMOC_PORT];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (completion) {
            NSString *userId = responseObject[@"userId"];
            [PMCore initWithAppID:responseObject[@"appToken"]];
            [PMSupport sharedInstance].appToken = responseObject[@"appToken"];
            [PMCore setUserId:userId];
            [PMSupport sharedInstance].userId = userId;
            [PMSupport sharedInstance].isAgent = YES;
            
            completion(userId);

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil);
        }
    }];
}

+ (void)registerUserWithName:(NSString *)name completion:(void (^)(NSString *))completion
{
    if ([PMSupport sharedInstance].userId) {
        NSLog(@"Can't login twice");
        if (completion) {
            completion(nil);
            return;
        }
    }
    
    
    [PMCore setDelegate:[PMSupport sharedInstance]];
    [PMCore initWithAppID:[PMSupport sharedInstance].appToken];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"name": name, @"appToken": [PMSupport sharedInstance].appToken};
   
    NSString *userId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *postUrl = [NSString stringWithFormat:@"http://%@:%i/user/%@", POMOC_URL, POMOC_PORT, userId];
    
    [manager POST:postUrl parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (completion) {
            NSString *userId = responseObject[@"userId"];
            [PMCore setUserId:userId];
            [PMSupport sharedInstance].userId = userId;
            [PMSupport sharedInstance].isAgent = NO;
            completion(userId);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil);
        }
    }];
}
+ (void)getAllConversations:(void(^)(NSArray *conversations))completion
{
    [PMCore getAllConversations:completion];
}

+ (void)startConversationWithCompletion:(void (^)(PMConversation *))completion
{
    [PMCore startConversationWithCompletion:completion];
}

+ (void)connect
{
    [PMSupport connectWithCompletion:nil];
}

+ (void)disconnect
{
    [PMCore disconnect];
    [PMSupport sharedInstance].userId = nil;
    [PMSupport sharedInstance].connectCallback = nil;
}

+ (void)connectWithCompletion:(void (^)(BOOL connected))callback
{
    [[PMSupport sharedInstance] setConnectCallback:^(BOOL connected) {
        if (connected) {
            if ([PMSupport sharedInstance].isAgent) {
                [PMCore observeNewConversations];
                NSString *agentConversationId = [NSString stringWithFormat:@"agent_chat:%@", [PMSupport sharedInstance].appToken];
                [PMSupport sharedInstance].agentConversation = [[PMConversation alloc] initWithConversationId:agentConversationId creatorUserId:@"" createDate:[NSDate date]];
                [[PMSupport sharedInstance].agentConversation joinConversationWithCompletion:^(BOOL success) {
                    [PMCore addConversation:[PMSupport sharedInstance].agentConversation];
                    if (callback) {
                        callback(connected);
                    }
                }];
            } else {
                callback(connected);
            }
        } else {
            callback(connected);
        }
    }];
    [PMCore connect];
}

+ (void)handleConversation:(NSString *)conversationId
{
    [PMCore handleConversation:conversationId];
}

+ (void)unhandleConversation:(NSString *)conversationId
{
    [PMCore unhandleConversation:conversationId];
}

+ (void)referHandlerConversation:(NSString *)conversationId refereeUserId:(NSString *)refereeUserId
{
    [PMCore referHandlerConversation:conversationId refereeUserId:refereeUserId];
}

+ (void)getHandlersForConversation:(NSString *)conversationId completion:(void (^)(NSArray *handlers))completion
{
    [PMCore getHandlersForConversation:conversationId completion:completion];
}

+ (void)pingApp
{
    [PMCore pingApp];
}

+ (void)pingConversation:(NSString *)conversationId
{

    [PMCore pingConversation:conversationId];
}

+ (void)setDelegate:(id<PMSupportDelegate>)delegate
{
    [PMSupport sharedInstance].delegate = delegate;
}

+ (PMConversation *)agentConversation
{
    return [PMSupport sharedInstance].agentConversation;
}

#pragma mark - PMCore delegate

- (void)newConversationCreated:(PMConversation *)conversation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(newConversationCreated:)]) {
        [self.delegate newConversationCreated:conversation];
    }
}

- (void)hasConnected
{
    if (self.connectCallback) {
        self.connectCallback(YES);
        self.connectCallback = nil;
    }
}

- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateHandlers:conversationId:)]) {
        [self.delegate updateHandlers:handlers conversationId:conversationId];
    }
}

- (void)updateHandlers:(NSArray *)handlers conversationId:(NSString *)conversationId referrer:(PMUser *)referrer referee:(PMUser *)referee
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateHandlers:conversationId:referrer:referee:)])
    {
        [self.delegate updateHandlers:handlers conversationId:conversationId
                             referrer:referrer referee:referee];
    }
}

- (void)updateOnlineUsers:(NSArray *)users conversationId:(NSString *)conversationId
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateOnlineUsers:conversationId:)]) {
        [self.delegate updateOnlineUsers:users conversationId:conversationId];
    }
}

- (void)updateOnlineUsers:(NSArray *)users
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateOnlineUsers:)]) {
        [self.delegate updateOnlineUsers:users];
    }
}

@end
