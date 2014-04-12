//
//  PMChatMessage_Private.h
//  PomocCore
//
//  Created by soedar on 12/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <PomocCore/PomocCore.h>

@class PMUser;

@interface PMChatMessage ()

- (void)resolveUserWithCompletion:(void(^)(PMUser *user))completion;

@end
