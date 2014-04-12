//
//  PMChatMessage.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMMessage.h"

@class PMUser;

@interface PMChatMessage : PMMessage

- (id)initWithMessage:(NSString *)message conversationId:(NSString *)conversationId;
- (id)initWithJsonData:(NSDictionary *)data;

@property (nonatomic, strong, readonly) NSString *message;
@property (nonatomic, strong, readonly) NSString *conversationId;
@property (nonatomic, strong, readonly) PMUser *user;

@end
