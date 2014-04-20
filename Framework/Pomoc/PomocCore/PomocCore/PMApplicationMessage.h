//
//  PMApplicationMessage.h
//  PomocCore
//
//  Created by Bang Hui Lim on 4/12/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <PomocCore/PomocCore.h>
#import "PMMessage.h"

@interface PMApplicationMessage : PMMessage;

@property (nonatomic, readonly) PMApplicationMessageCode code;
@property (nonatomic, strong, readonly) NSString *conversationId;
@property (nonatomic, strong, readonly) NSString *refereeUserId;
@property (nonatomic, strong, readonly) NSDictionary *appData;

- (id)initWithMessageCode:(PMApplicationMessageCode)code
           conversationId:(NSString *)conversationId;
- (id)initWithMessageCode:(PMApplicationMessageCode)code
           conversationId:(NSString *)conversationId
           refereeUserId:(NSString *)userId;

- (id)initWithMessageCode:(PMApplicationMessageCode)code
           conversationId:(NSString *)conversationId
                  appData:(NSDictionary *)appData;

@end
