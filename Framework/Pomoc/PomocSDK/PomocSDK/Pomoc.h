//
//  Pomoc.h
//  PomocSDK
//
//  Created by soedar on 28/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Pomoc : NSObject

+ (void)initWithAppId:(NSString *)appId secretKey:(NSString *)secretKey;
+ (void)registerUserWithName:(NSString *)name completion:(void (^)(NSString *userId))completion;
+ (void)toggleChatHead;

@end
