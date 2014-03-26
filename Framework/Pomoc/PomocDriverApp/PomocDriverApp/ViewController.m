//
//  ViewController.m
//  PomocDriverApp
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "ViewController.h"
#import "PomocCore.h"

@interface ViewController () <PMCoreDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [PMCore initWithAppID:@"anc" delegate:self];
    
    [PMCore startConversationWithUserId:@"zz" completion:^(NSString *conversationId) {
        if (conversationId) {
            NSLog(@"%@", conversationId);
            [PMCore sendMessage:@"Hello!" userId:@"zz" channelId:conversationId];
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

- (void)didReceiveMessage:(PMMessage *)pomocMessage channelId:(NSString *)channel
{
    NSLog(@"Received: %@", pomocMessage.message);
}

- (void)newChannelCreated:(NSString *)channedId
{
    NSLog(@"New Channel created %@", channedId);
}

@end
