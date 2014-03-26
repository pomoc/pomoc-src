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
    
    [PMCore initWithAppID:@"anc" userId:@"soedar" delegate:self];
    
    [PMCore startConversationWithCompletion:^(NSString *conversationId) {
        if (conversationId) {
            [PMCore sendMessage:@"Hello" conversationId:conversationId];
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

- (void)didReceiveMessage:(PMMessage *)pomocMessage conversationId:(NSString *)conversation
{
    NSLog(@"Received: %@", pomocMessage);
}

- (void)newConversationCreated:(NSString *)conversationId
{
    NSLog(@"New Channel created %@", conversationId);
}

@end
