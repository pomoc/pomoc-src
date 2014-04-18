//
//  LoginViewController.m
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "LoginViewController.h"
#import "DashBoardSingleton.h"
#import "PomocSupport.h"

@interface LoginViewController () <PMSupportDelegate, PMConversationDelegate>

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)loginPressed:(id)sender {
    
    [self showActivityProgress];
    
    DashBoardSingleton *singleton = [DashBoardSingleton singleton];
    [singleton loginAgentWithUserId:@"steveng.1988@gmail.com" password:@"hehe" completion:^(BOOL success) {
        [self performSegueWithIdentifier:@"login" sender:sender];
    }];

    
}
//
//- (void) test {
//    
//    [PMSupport initWithAppID:@"anc15" secretKey:@"mySecret"];
//    [PMSupport setDelegate:self];
//    
//    [PMSupport loginAgentWithUserId:@"steveng.1988@gmail.com" password:@"hehe" completion:^(NSString *returnedUserId) {
//        //NSLog(@"------- USER ID IS %@", userId);
//        [PMSupport connectWithCompletion:^(BOOL connected) {
//            NSLog(@"connected");
//            [PMSupport getAllConversations:^(NSArray *conversations) {
//                for (PMConversation *convo in conversations) {
//                    NSLog(@"convo going through ..");
//                    convo.delegate = self;
//                }
//                NSLog(@"all conversation.length == %lu",[conversations count]);
//            }];
//        }];
//    }];
//}
//
//#pragma mark - PMCORE Delegate
//
//- (void)newConversationCreated:(PMConversation *)conversation
//{
//    NSLog(@"New Channel created %@", conversation);
//    conversation.delegate = self;
//}
//
//#pragma mark - PMConversation Delegate
//- (void)conversation:(PMConversation *)conversation didReceiveChatMessage:(PMChatMessage *)chatMessage
//{
//    NSLog(@"did rec msg");
//}
//
//- (void)conversation:(PMConversation *)conversation didReceiveImageMessage:(PMImageMessage *)imageMessage
//{
//    // CHeck if the image message is right
//    NSLog(@"Received image");
//}

- (void) showActivityProgress {
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center=self.view.center;
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
}
@end
