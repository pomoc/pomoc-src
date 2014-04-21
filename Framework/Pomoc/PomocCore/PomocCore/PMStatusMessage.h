//
//  PMStatusMessage.h
//  PomocCore
//
//  Created by soedar on 21/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <PomocCore/PomocCore.h>
#import "PMChatMessage.h"
#import "PMMessageConstants.h"

@interface PMStatusMessage : PMChatMessage

- (id)initWithMessageCode:(PMStatusMessageCode)code conversationId:(NSString *)conversationId;
- (PMStatusMessageCode)code;

@end