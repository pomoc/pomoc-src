//
//  PMUser.h
//  PomocCore
//
//  Created by Bang Hui Lim on 4/11/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMUserConstants.h"

@interface PMUser : NSObject

- (id)initWithUserID:(NSString *)userId type:(NSString *)type;
- (id)initWithUserID:(NSString *)userId type:(NSString *)type name:(NSString *)name;
- (id)initWithJsonData:(NSDictionary *)data;

@property (nonatomic, strong, readonly) NSString *userId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong, readonly) NSString *type;

@end