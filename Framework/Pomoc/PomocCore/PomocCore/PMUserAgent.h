//
//  PMUserAgent.h
//  PomocCore
//
//  Created by Bang Hui Lim on 4/11/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMUser.h"

@interface PMUserAgent : PMUser

- (id)initWithUserID:(NSString *)userId appToken:(NSString *)appToken;
- (id)initWithUserID:(NSString *)userId appToken:(NSString *)appToken name:(NSString *)name;
- (id)initWithJsonData:(NSDictionary *)data;

@end
