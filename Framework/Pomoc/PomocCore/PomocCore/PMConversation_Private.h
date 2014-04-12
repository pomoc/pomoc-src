//
//  PMConversation_Private.h
//  PomocCore
//
//  Created by soedar on 4/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMConversation.h"

@interface PMConversation ()

@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) NSMutableArray *allMessages;

- (void)joinConversationWithCompletion:(void(^)(BOOL success))completion;

@end
