//
//  PMUser.h
//  PomocCore
//
//  Created by Bang Hui Lim on 4/11/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMUser : NSObject

- (id)initWithUserID:(NSString *)userId appToken:(NSString *)appToken;

@property (nonatomic, strong, readonly) NSString *userId;
@property (nonatomic, strong, readonly) NSString *appToken;

@end