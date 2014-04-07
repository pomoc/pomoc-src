//
//  Pomoc.m
//  PomocSDK
//
//  Created by soedar on 28/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "Pomoc.h"
#import "PomocWindow.h"
#import "PomocViewController.h"
#import "PomocSupport.h"

@interface Pomoc ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) NSString *userId;

@end

@implementation Pomoc

+ (Pomoc *)sharedInstance
{
    static Pomoc *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.window = [[PomocWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        [sharedInstance.window setWindowLevel:UIWindowLevelStatusBar];
        [sharedInstance.window setRootViewController:[[PomocViewController alloc] init]];
    });
    
    return sharedInstance;
}

+ (void)initWithAppId:(NSString *)appId secretKey:(NSString *)secretKey
{
    [Pomoc sharedInstance];
    [PMSupport initWithAppID:appId secretKey:secretKey];
}

+ (void)registerUserWithName:(NSString *)name completion:(void (^)(NSString *userId))completion
{
    Pomoc *pomoc = [Pomoc sharedInstance];
    [PMSupport registerUserWithName:@"Customer" completion:^(NSString *userId) {
        pomoc.userId = userId;
        if (completion) {
            completion(userId);
        }
    }];
}

+ (void)login
{
}

+ (void)toggleChatHead
{
    Pomoc *pomoc = [Pomoc sharedInstance];
    pomoc.window.hidden = !pomoc.window.hidden;
}

@end
