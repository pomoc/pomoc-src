//
//  PMApplicationMessage.h
//  PomocCore
//
//  Created by Bang Hui Lim on 4/12/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <PomocCore/PomocCore.h>

@interface PMApplicationMessage : PMMessage

@property (nonatomic, readonly) PMApplicationMessageCode code;
@property (nonatomic, strong, readonly) NSString *conversationId;
@property (nonatomic, strong, readonly) NSString *referalUserId;

- (id)initWithMessageCode:(PMApplicationMessageCode)code
           conversationId:(NSString *)conversationId;

@end
