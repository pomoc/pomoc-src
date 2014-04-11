//
//  PMUser.m
//  PomocCore
//
//  Created by Bang Hui Lim on 4/11/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMUser.h"

@interface PMUser ()

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *appToken;

@end

@implementation PMUser

- (id)initWithUserID:(NSString *)userId appToken:(NSString *)appToken
{
    self = [super init];
    if (self) {
        self.userId = userId;
        self.appToken = appToken;
    }
    return self;
}

@end
