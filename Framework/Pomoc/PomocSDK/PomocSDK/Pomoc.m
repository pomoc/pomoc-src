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

@property (nonatomic, strong) ChatViewController *chatViewController;

@end

@implementation Pomoc

+ (Pomoc *)sharedInstance
{
    static Pomoc *sharedInstance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

+ (void)showChatViewControllerOnViewController:(UIViewController *)viewController;
{
    Pomoc *pomoc = [Pomoc sharedInstance];
    pomoc.chatViewController = [[ChatViewController alloc] init];
    [viewController presentViewController:pomoc.chatViewController animated:YES completion:nil];
}

@end
