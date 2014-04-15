//
//  PMSupport.m
//  PomocCore
//
//  Created by soedar on 6/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMSupport.h"
#import "PMCore.h"
#import "AFNetworking.h"
#import "PomocConstants.h"
#import "PMConversation+PMCore.h"
#import "PMConversation_Private.h"

@interface PMSupport () <PMCoreDelegate>

@property (nonatomic, weak) id<PMSupportDelegate> delegate;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *secretKey;
@property (nonatomic) BOOL isAgent;
@property (nonatomic, copy) void (^connectCallback)(BOOL connected);

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
    [PMCore initWithAppID:appId];
    [PMCore setDelegate:[PMSupport sharedInstance]];
    
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"userId": userId, @"password": password};
    
    NSString *url = [NSString stringWithFormat:@"http://%@:%i/agentLogin", POMOC_URL, POMOC_PORT];
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (completion) {
            NSString *userId = responseObject[@"userId"];
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
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *parameters = @{@"name": name};
   
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

+ (void)setDelegate:(id<PMSupportDelegate>)delegate
{
    [PMSupport sharedInstance].delegate = delegate;
}

+ (void)startConversationWithCompletion:(void (^)(PMConversation *))completion
{
    [PMCore startConversationWithCompletion:completion];
}

+ (void)connect
{
    [PMSupport connectWithCompletion:nil];
}

+ (void)connectWithCompletion:(void (^)(BOOL connected))callback
{
    [[PMSupport sharedInstance] setConnectCallback:^(BOOL connected) {
        if (connected) {
            if ([PMSupport sharedInstance].isAgent) {
                [PMCore observeNewConversations];
            }
        }
        
        if (callback) {
            callback(connected);
        }
    }];
    [PMCore connect];
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

@end
