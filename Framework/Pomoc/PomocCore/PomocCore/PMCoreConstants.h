//
//  PomocConstants.h
//  PomocCore
//
//  Created by soedar on 12/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#ifndef PomocCore_PomocConstants_h
#define PomocCore_PomocConstants_h

//#define LOCAL_SERVER

#ifdef LOCAL_SERVER
#define POMOC_URL   @"172.28.177.128"
#define POMOC_PORT  80

#else
#define POMOC_URL   @"pomoc.im"
#define POMOC_PORT  3217
#endif

#define APP_TOKEN_KEY   @"appToken"
#define SUCCESS_KEY     @"success"
#define CLASS_KEY       @"class"

#define MESSAGES_KEY    @"messages"
#define CONVERSATION_IDS_KEY @"conversationIds"
#define NOTES_KEY       @"notes"
#define HANDLERS_KEY    @"handlers"
#define ARGS_KEY        @"args"
#define TYPE_KEY        @"type"
#define USERS_KEY       @"users"

#define APPLICATION_MESSAGE_EVENT @"applicationMessage"
#define INTERNAL_MESSAGE_EVENT    @"internalMessage"
#define CHAT_MESSAGE_EVENT        @"chatMessage"
#define NEW_CONVERSATION_EVENT      @"newConversation"
#define NEW_NOTE_EVENT              @"newNote"

#endif
