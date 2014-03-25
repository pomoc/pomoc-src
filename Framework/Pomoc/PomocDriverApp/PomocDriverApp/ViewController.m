//
//  ViewController.m
//  PomocDriverApp
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ViewController.h"
#import "PomocCore.h"
#import "PomocCoreDelegate.h"
#import "PomocMessage.h"

@interface ViewController () <PomocCoreDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [PomocCore initWithAppID:@"hello" delegate:self];
    
    [PomocCore startConversationWithUserId:@"zz" completion:^(NSString *conversationId) {
        if (conversationId) {
            NSLog(@"%@", conversationId);
            [PomocCore sendMessage:@"Hello!" userId:@"zz" channel:conversationId];
        }
        else {
            NSLog(@"Failed");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didReceiveMessage:(PomocMessage *)pomocMessage channel:(NSString *)channel
{
    NSLog(@"Received: %@", pomocMessage.message);
}

@end
