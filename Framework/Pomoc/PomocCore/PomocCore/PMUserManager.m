//
//  PMUserManager.m
//  PomocCore
//
//  Created by Bang Hui Lim on 4/12/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMUserManager.h"
#import "PMUser.h"
#import "PMCoreConstants.h"

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
    // For some reason, making the sendSynchronousRequest calls too aggressively
    // actually causes the threads to fail. As such, we take the easy way out and
    // simply ensure that only one thread can make the synchronous call at any time
    @synchronized([PMUserManager sharedInstance]) {
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
            [PMUserManager sharedInstance].userCache[userId] = user;
        }
        return user;
    }
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
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *responseCode, NSData *responseData, NSError *error){
        PMUser *user = nil;
        if (!error) {
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
            user = [[PMUser alloc] initWithJsonData:jsonObject];
            @synchronized([PMUserManager sharedInstance].userCache) {
                [PMUserManager sharedInstance].userCache[userId] = user;
            }
        }
        completionBlock(user);
    }];
}

// Synchronous method to get list of PMUser objects
+ (NSArray *)getUserObjectsFromUserIds:(NSArray *)userIds
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_queue_t joinQueue = dispatch_queue_create("userQueue", NULL);
    dispatch_group_t group = dispatch_group_create();
    
    NSMutableArray *users = [NSMutableArray array];
    
    for (NSString * userId in userIds) {
        dispatch_group_async(group, queue, ^(void) {
            PMUser *user = [PMUserManager getUserObjectFromUserId:userId];
            if (user) {
                dispatch_sync(joinQueue, ^(void) {
                    [users addObject:user];
                });
            }
        });
    }
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    return [users copy];
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