//
//  DashBoardSingleton.h
//  Pomoc Dashboard Client
//
//  Dashboard APP level singleton
//
//  Created by Steve Ng on 23/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DashBoardSingleton : NSObject

@property (nonatomic, strong) NSString *appId;

+ (id)sharedModel;


@end
