//
//  PMMessageConstants.h
//  PomocCore
//
//  Created by soedar on 27/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#ifndef PomocCore_PMMessageConstants_h
#define PomocCore_PMMessageConstants_h

typedef enum {
    PMInternalMessageCodeNone,
    PMInternalMessageCodeNewConversation,
    PMInternalMessageCodeObserveConversationList,
    PMInternalMessageCodeJoinConversation
} PMInternalMessageCode;

typedef enum {
    PMApplicationMessageCodeHandle,
    PMApplicationMessageCodeUnhandle,
    PMApplicationMessageCodeReferHandler
} PMApplicationMessageCode;

#define MESSAGE_TIMESTAMP           @"timestamp"
#define MESSAGE_CLASS               @"class"
#define MESSAGE_MESSAGE             @"message"
#define MESSAGE_CONVERSATION_ID     @"conversationId"
#define MESSAGE_TYPE                @"type"
#define MESSAGE_USER_ID             @"userId"

#endif
