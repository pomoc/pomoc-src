//
//  PMChatMessage.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMMessage.h"

@interface FakePMChatMessage : PMMessage

- (id)initWithMessage:(NSString *)message conversationId:(NSString *)conversationId;
- (id)initWithJsonData:(NSDictionary *)data;

@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) NSString *userId;

@end
