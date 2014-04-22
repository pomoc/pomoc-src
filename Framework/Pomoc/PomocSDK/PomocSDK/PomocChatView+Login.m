//
//  PomocChatView+Login.m
//  PomocSDK
//
//  Created by soedar on 22/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PomocChatView+Login.h"
#import "Pomoc_Private.h"
#import "PomocChatView_Private.h"
#import "PMSupport.h"
#import "PMConversation.h"

@implementation PomocChatView (Login)

- (void)setupLoginView
{
    self.loginView = [[UIView alloc] initWithFrame:CGRectMake(0, CHAT_VIEW_HEADER_HEIGHT, self.bounds.size.width, self.bounds.size.height-CHAT_VIEW_HEADER_HEIGHT)];
    [self.loginView setBackgroundColor:[UIColor whiteColor]];
    
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.bounds.size.width, 40)];
    [loginLabel setText:@"Hi"];
    [loginLabel setTextAlignment:NSTextAlignmentCenter];
    [self.loginView addSubview:loginLabel];
    
    self.loginTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 60, self.bounds.size.width, 40)];
    [self.loginTextField setPlaceholder:@"What is your name?"];
    [self.loginTextField setTextAlignment:NSTextAlignmentCenter];
    [self.loginView addSubview:self.loginTextField];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"Go" forState:UIControlStateNormal];
    [loginButton setFrame:CGRectMake(0, 100, 60, 60)];
    [loginButton setCenter:CGPointMake(self.bounds.size.width/2, loginButton.center.y)];
    [loginButton addTarget:self action:@selector(loginPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginView addSubview:loginButton];
    
    [self addSubview:self.loginView];
}

- (void)loginPressed:(UIButton *)loginButton
{
    if (![self.loginTextField.text isEqualToString:@""]) {
        [Pomoc registerUserWithName:self.loginTextField.text completion:^(NSString *userId) {
            [PMSupport startConversationWithCompletion:^(PMConversation *conversation) {
                self.conversation = conversation;
                self.conversation.delegate = self;
                
                [self.loginView removeFromSuperview];
            }];
        }];
    }
}

@end
