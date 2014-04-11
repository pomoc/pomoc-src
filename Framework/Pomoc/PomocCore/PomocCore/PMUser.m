//
//  PMUser.m
//  PomocCore
//
//  Created by Bang Hui Lim on 4/11/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMUser.h"

@interface PMUser ()

@property (nonatomic, strong) NSString *appToken;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *userId;

@end

@implementation PMUser

- (id)initWithUserID:(NSString *)userId appToken:(NSString *)appToken type:(NSString *)type
{
    self = [super init];
    if (self) {
        self.userId = userId;
        self.appToken = appToken;
        self.type = type;
        self.name = userId;
    }
    return self;
}

- (id)initWithUserID:(NSString *)userId appToken:(NSString *)appToken type:(NSString *)type name:(NSString *)name
{
    self = [super init];
    if (self) {
        self.userId = userId;
        self.appToken = appToken;
        self.type = type;
        self.name = name;
    }
    return self;
}

- (id)initWithJsonData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        self.userId = data[USER_USERID];
        self.appToken = data[USER_APP_TOKEN];
        self.type = data[USER_TYPE];
        self.name = data[USER_NAME];
    }
    return self;
}

@end