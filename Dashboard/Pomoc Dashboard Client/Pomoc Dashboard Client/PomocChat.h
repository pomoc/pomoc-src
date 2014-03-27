//
//  PomocChat.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PomocChat : NSObject

//identifier for the channel
@property (nonatomic, strong) NSString *conversationId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSDate *startedDate;
@property (nonatomic, strong) NSMutableArray *chatMessages;


- (id)initWithConversation: (NSString *)conversationId;


//Future expansion
@property (nonatomic, strong) NSString *visitorName;
@property (nonatomic, assign) NSInteger noOfAgent;





@end
