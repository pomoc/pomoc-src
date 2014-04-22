//
//  Pomoc_Private.h
//  PomocSDK
//
//  Created by soedar on 22/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <PomocSDK/PomocSDK.h>

@interface Pomoc ()

+ (void)registerUserWithName:(NSString *)name completion:(void (^)(NSString *userId))completion;

@end
