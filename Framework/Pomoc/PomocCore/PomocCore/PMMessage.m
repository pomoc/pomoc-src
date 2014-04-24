//
//  PomocMessage.m
//  PomocCore
//
//  Created by soedar on 26/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMMessage.h"


@interface PMMessage ()

@property (nonatomic, strong) NSDate *timestamp;

@end

@implementation PMMessage

- (id)init
{
    self = [super init];
    if (self) {
        self.timestamp = [NSDate date];
    }
    return self;
}

- (id)initWithJsonData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        NSTimeInterval intervalSince1970 = [data[MESSAGE_TIMESTAMP] floatValue] / 1000;
        self.timestamp = [NSDate dateWithTimeIntervalSince1970:intervalSince1970];
    }
    return self;
}

- (NSDictionary *)jsonObject
{
    return @{MESSAGE_TIMESTAMP: @((long long)([self.timestamp timeIntervalSince1970]*1000)),
                 MESSAGE_CLASS: [[self class] description]};
}

@end
