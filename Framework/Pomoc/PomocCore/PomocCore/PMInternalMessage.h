//
//  PMInternalMessage.h
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMMessage.h"


@interface PMInternalMessage : PMMessage;

- (id)initWithMessageCode:(PMInternalMessageCode)code;

@property (nonatomic, readonly) PMInternalMessageCode code;

@end
