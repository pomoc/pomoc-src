//
//  PMUserManager.h
//  PomocCore
//
//  Created by Bang Hui Lim on 4/12/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMUser;

@interface PMUserManager : NSObject

+ (PMUser *)getUserObjectFromUserId:(NSString *)userId;
+ (void)getUserObjectFromUserId:(NSString *)userId completionBlock:(void (^)(PMUser *))completionBlock;

@end
