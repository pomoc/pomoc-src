//
//  Pomoc.m
//  PomocSDK
//
//  Created by soedar on 28/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "Pomoc.h"
#import "ChatViewController.h"

@interface Pomoc ()

@property (nonatomic, strong) UIWindow *window;

@end

@implementation Pomoc

+ (Pomoc *)sharedInstance
{
    static Pomoc *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    });
    
    return sharedInstance;
}

+ (void)showChatViewController
{
    Pomoc *pomoc = [Pomoc sharedInstance];
    
    if (pomoc.window.hidden == YES) {
        [pomoc.window setWindowLevel:UIWindowLevelStatusBar];
        [pomoc.window setHidden:NO];
    }
    
    ChatViewController *viewController = [[ChatViewController alloc] init];
    [pomoc.window setRootViewController:viewController];
}

@end
