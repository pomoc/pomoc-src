//
//  PomocChatView.h
//  PomocSDK
//
//  Created by soedar on 3/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMConversation.h"

@interface PomocChatView : UIView <PMConversationDelegate>

- (void)dismissKeyboard;

@end
