//
//  PomocChatView_Private.h
//  PomocSDK
//
//  Created by soedar on 22/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PomocChatView.h"

#define CHAT_VIEW_HEADER_HEIGHT     30
#define CHAT_VIEW_FOOTER_HEIGHT     30

#define CHAT_TEXT_CELL_HEIGHT       50
#define CHAT_IMAGE_CELL_HEIGHT      250

@class PMConversation;

@interface PomocChatView ()

@property (nonatomic, strong) PMConversation *conversation;

@property (nonatomic, strong) UITextField *loginTextField;
@property (nonatomic, strong) UIView *loginView;

@end
