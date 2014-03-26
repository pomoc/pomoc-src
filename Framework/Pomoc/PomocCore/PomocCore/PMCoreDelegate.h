//
//  PomocCoreDelegate.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMMessage;

@protocol PMCoreDelegate <NSObject>

- (void)didReceiveMessage:(PMMessage *)pomocMessage channelId:(NSString *)channelId;

@end
