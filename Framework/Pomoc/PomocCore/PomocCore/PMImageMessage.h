//
//  PMImageMessage.h
//  PomocCore
//
//  Created by Soon Chun Mun on 11/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMChatMessage.h"
#import <UIKit/UIKit.h>

@interface PMImageMessage : PMChatMessage

- (id)initWithImageUrl:(NSString *)imageUrl conversationId:(NSString *)conversationId;
- (void)retrieveImageWithCompletion:(void (^) (UIImage *image))block;

@property (nonatomic, strong, readonly) UIImage *image;


@end
