//
//  PMNote.h
//  PomocCore
//
//  Created by soedar on 20/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMNote : NSObject

- (id)initWithNote:(NSString *)note;
- (id)initWithJsonData:(NSDictionary *)jsonData;

@property (nonatomic, strong, readonly) NSString *note;
@property (nonatomic, strong, readonly) NSDate *timestamp;

@end
