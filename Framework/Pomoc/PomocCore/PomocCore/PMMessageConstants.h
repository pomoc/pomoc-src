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
    PMInternalMessageCodeJoinConversation,
    PMInternalMessageCodeGetAppConversationList,
    PMInternalMessageCodePingApp,
    PMInternalMessageCodePingConversation
} PMInternalMessageCode;

typedef enum {
    PMApplicationMessageCodeHandle,
    PMApplicationMessageCodeUnhandle,
    PMApplicationMessageCodeReferHandler,
    PMApplicationMessageCodeGetHandlers,
    
    PMApplicationMessageCodeAddNote
} PMApplicationMessageCode;


typedef enum {
    PMStatusMessageNone,
    PMStatusMessageJoin,
    PMStatusMessageLeave
} PMStatusMessageCode;

#define MESSAGE_TIMESTAMP           @"timestamp"
#define MESSAGE_CLASS               @"class"
#define MESSAGE_MESSAGE             @"message"
#define MESSAGE_CONVERSATION_ID     @"conversationId"
#define MESSAGE_REFEREE_USERID      @"refereeUserId"
#define MESSAGE_TYPE                @"type"
#define MESSAGE_USER_ID             @"userId"
#define MESSAGE_CREATE_DATE         @"createDate"
#define MESSAGE_CREATOR_USERID      @"creatorUserId"
#define MESSAGE_APP_DATA            @"appData"

#endif
