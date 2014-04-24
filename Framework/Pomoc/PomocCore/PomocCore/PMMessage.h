//
//  PomocMessage.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMMessageConstants.h"

@interface PMMessage : NSObject

- (id)init;
- (id)initWithJsonData:(NSDictionary *)data;

- (NSDictionary *)jsonObject;


@property (nonatomic, readonly) NSDate *timestamp;

@end
