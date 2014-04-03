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
        sharedInstance.window = [[PomocWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
        [sharedInstance.window setWindowLevel:UIWindowLevelStatusBar];
        [sharedInstance.window setRootViewController:[[PomocViewController alloc] init]];
        [sharedInstance.window setHidden:NO];
    });
    
    return sharedInstance;
}

+ (void)showChatViewController
{
    Pomoc *pomoc = [Pomoc sharedInstance];
    
    /*
    ChatViewController *viewController = [[ChatViewController alloc] init];
    [viewController.view setBackgroundColor:[UIColor greenColor]];
    
    [pomoc.pomocController presentViewController:viewController animated:NO completion:nil];
    viewController.view.frame = CGRectMake(0, 0, viewController.view.frame.size.width, 300);
     */
}

@end
