//
//  PomocMessage.h
//  ChatClient
//
//  Created by Bang Hui Lim on 3/25/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PomocMessage:NSObject
@property (readonly) NSString * username;
@property (readonly) NSString * channel;
@property (readonly) NSString * type;
@property (readonly) NSString * message;
- (id) initWithProperties:(NSString *)username :(NSString *)channel :(NSString *)type :(NSString *)message;
- (id) initWithJSONString:(NSString *)jsonString;
@end