//
//  PMImageMessage.m
//  PomocCore
//
//  Created by Soon Chun Mun on 11/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PMImageMessage.h"
#import "PomocImage.h"

@interface PMImageMessage ()

@property (nonatomic, strong) UIImage *image;

@end

@implementation PMImageMessage


- (id)initWithImageUrl:(NSString *)imageId conversationId:(NSString *)conversationId
{
    if (self = [super initWithMessage:imageId conversationId:conversationId]) {
        self.image = nil;
    }
    return self;
}

- (void)retrieveImageWithCompletion:(void (^) (UIImage *image))block {
    [[PomocImage sharedInstance] downloadImage:self.message withCompletion:^(UIImage *image) {
        self.image = image;
        if (block) {
            block(image);
        }
    }];
}

- (NSDictionary *)jsonObject
{
    NSMutableDictionary *jsonData = [[super jsonObject] mutableCopy];
    jsonData[MESSAGE_MESSAGE] = self.message;
    jsonData[MESSAGE_CONVERSATION_ID] = self.conversationId;
    
    return [NSDictionary dictionaryWithDictionary:jsonData];
}

@end
