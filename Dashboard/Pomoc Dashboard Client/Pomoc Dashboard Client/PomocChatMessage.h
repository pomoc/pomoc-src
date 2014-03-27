//
//  PomocChatMessage.h
//  Pomoc Dashboard Client
//
//  Created by Steve Ng on 25/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PomocChatMessage : NSObject

@property (nonatomic, strong) NSString *messageText;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSString *userId;


@property (nonatomic, strong) NSString *messageType;
@property (nonatomic, strong) NSString *messageClass;

//future expansion
@property (nonatomic, strong) UIImage *messageImage;

@end
