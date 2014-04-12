//
//  PMUserManager.m
//  PomocCore
//
//  Created by Bang Hui Lim on 4/12/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMUserManager.h"
#import "PMUser.h"
#import "PomocConstants.h"

@interface PMUserManager ()

@property (nonatomic, strong) NSMutableDictionary *userCache;

@end

@implementation PMUserManager

// No cache right now, because users can change their name and there isn't a
// trivial way of checking for that right now.

// Required for caching (not used atm)
+ (PMUserManager *)sharedInstance
{
    static PMUserManager *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.userCache = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (PMUser *)getUserObjectFromUserId:(NSString *)userId
{
    if ([PMUserManager sharedInstance].userCache[userId]) {
        return [PMUserManager sharedInstance].userCache[userId];
    }
    
    NSMutableURLRequest *request = [PMUserManager getRequestObject:userId];
    NSHTTPURLResponse *responseCode = nil;
    NSError *error = nil;
    PMUser *user = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    if (!error) {
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
        user = [[PMUser alloc] initWithJsonData:jsonObject];
    }
    return user;
}

+ (void)getUserObjectFromUserId:(NSString *)userId completionBlock:(void (^)(PMUser *user))completionBlock
{
    if ([PMUserManager sharedInstance].userCache[userId]) {
        if (completionBlock) {
            completionBlock([PMUserManager sharedInstance].userCache[userId]);
        }
        return;
    }
    
    NSMutableURLRequest *request = [PMUserManager getRequestObject:userId];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *responseCode, NSData *responseData, NSError *error){
        PMUser *user = nil;
        if (!error) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            user = [[PMUser alloc] initWithJsonData:jsonObject];
        }
        completionBlock(user);
    }];
}

+ (NSMutableURLRequest *)getRequestObject:(NSString *)userId
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"GET"];
    NSString *requestUrl = [NSString stringWithFormat:@"http://%@:%i/user/%@", POMOC_URL, POMOC_PORT, userId];
    [request setURL:[NSURL URLWithString:requestUrl]];
    return request;
}

@end
