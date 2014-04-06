//
//  PomocImageUpload.h
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 6/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PomocImageUpload : NSObject
+ (PomocImageUpload *)sharedInstance;
- (NSString *)contentTypeForImageData:(UIImage*)image;
- (void)uploadImage:(UIImage *)image withCompletion:(void(^)(NSString *))block;
- (void)downloadImage:(NSString *)filename withCompletion:(void(^)(UIImage *))block;
@end
