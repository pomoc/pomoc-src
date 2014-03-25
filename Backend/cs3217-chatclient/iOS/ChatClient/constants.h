//
//  constants.h
//  ChatClient
//
//  Created by Bang Hui Lim on 3/17/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#define PORT                3217

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
