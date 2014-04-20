//
//  PMNote.m
//  PomocCore
//
//  Created by soedar on 20/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMNote.h"

@interface PMNote ()
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSDate *timestamp;
@end

@implementation PMNote

- (id)initWithNote:(NSString *)note
{
    self = [super init];
    if (self) {
        self.note = note;
        self.timestamp = [NSDate date];
    }
    return self;
}

- (id)initWithJsonData:(NSDictionary *)jsonData
{
    self = [super init];
    if (self) {
        NSTimeInterval intervalSince1970 = [jsonData[@"timestamp"] floatValue] / 1000;
        self.timestamp = [NSDate dateWithTimeIntervalSince1970:intervalSince1970];
        self.note = jsonData[@"note"];
    }
    return self;
}

@end
