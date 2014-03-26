//
//  PomocMessage.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

// Message types
#define MSG_TYPE_SUB        @"subscribe"
#define MSG_TYPE_UNSUB      @"unsubscribe"
#define MSG_TYPE_CHAT       @"chat"
#define MSG_TYPE_NOTIFY     @"notification"
#define MSG_TYPE_INIT       @"init"
#define MESSAGE_TYPES       @[MSG_TYPE_SUB, MSG_TYPE_UNSUB, MSG_TYPE_CHAT, MSG_TYPE_NOTIFY, MSG_TYPE_INIT]

// Pomoc message field types
#define MSG_TYPE            @"type"
#define MSG_CHANNEL         @"channel"
#define MSG_USERNAME        @"username"
#define MSG_MESSAGE         @"message"


@interface PMMessage : NSObject

- (id)initWithUsername:(NSString *)username
           withChannel:(NSString *)channel
              withType:(NSString *)type
           withMessage:(NSString *)message;
- (id)initWithJSONString:(NSString *)jsonString;
- (NSDictionary *)getJSONObject;

@property (readonly) NSString *username;
@property (readonly) NSString *channel;
@property (readonly) NSString *type;
@property (readonly) NSString *message;

@end
