//
//  PMSupportConstant.h
//  PomocCore
//
//  Created by soedar on 25/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMCoreConstants.h"

#ifndef PomocCore_PMSupportConstant_h
#define PomocCore_PMSupportConstant_h

#define USER_ID_KEY     @"userId"
#define PASSWORD_KEY    @"password"

#define NAME_KEY        @"name"

#define HTTP_AGENT_URL      [NSString stringWithFormat:@"http://%@:%i/agentLogin", POMOC_URL, POMOC_PORT]
#define HTTP_CUSTOMER_URL   [NSString stringWithFormat:@"http://%@:%i/user/", POMOC_URL, POMOC_PORT]

#define AGENT_CHAT_ROOM_PREFIX     @"agent_chat:"

#endif
