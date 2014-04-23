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
#import "PomocResources.h"

@implementation PomocChatView (Login)

- (void)setupLoginView
{
    self.loginView = [[UIView alloc] initWithFrame:CGRectMake(0, CHAT_VIEW_HEADER_HEIGHT, self.bounds.size.width, self.bounds.size.height-CHAT_VIEW_HEADER_HEIGHT)];
    [self.loginView setBackgroundColor:[UIColor whiteColor]];
    
    UIImage *chatImage = [PomocResources imageNamed:@"logo-blue" type:@"png"];
    UIImageView *chatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 128, 128)];
    [chatImageView setImage:chatImage];
    chatImageView.center = CGPointMake(self.bounds.size.width/2.0, chatImageView.center.x);
    
    [self.loginView addSubview:chatImageView];
    
    
    UIImage *welcomeImage = [PomocResources imageNamed:@"welcome-word" type:@"png"];
    UIImageView *welcomeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 170, 100)];
    [welcomeImageView setContentMode:UIViewContentModeScaleAspectFit];
    [welcomeImageView setImage:welcomeImage];
    welcomeImageView.center = CGPointMake(self.bounds.size.width/2.0, welcomeImageView.center.y);
    [self.loginView addSubview:welcomeImageView];
    
    
    self.loginTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 190, self.bounds.size.width, 40)];
    [self.loginTextField setPlaceholder:@"Enter your name here."];
    [self.loginTextField setTextAlignment:NSTextAlignmentCenter];
    [self.loginView addSubview:self.loginTextField];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [loginButton setTitle:@"Help me!" forState:UIControlStateNormal];
    
    [[loginButton titleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22]];
    
    [loginButton setBackgroundColor:[UIColor colorWithRed:24/255.0 green:181/255.0 blue:240/255.0 alpha:1.0]];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [[loginButton titleLabel] setTextColor:[UIColor blackColor]];
    [loginButton setFrame:CGRectMake(0, 240, 150, 40)];
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
                
                [self.conversation sendStatusMessage:PMStatusMessageJoin];
                
                [self.loginView removeFromSuperview];
            }];
        }];
    }
}

@end
