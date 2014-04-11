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
@property (nonatomic, strong) NSString *imageUrl;

@end

@implementation PMImageMessage


- (id)initWithImageUrl:(NSString *)imageUrl conversationId:(NSString *)conversationId
{
    if (self = [super initWithMessage:nil conversationId:conversationId]) {
        self.imageUrl = imageUrl;
        self.image = nil;
    }
    return self;
}

- (void)retrieveImageWithCompletion:(void (^) (UIImage *image))block {
    [[PomocImage sharedInstance] downloadImage:self.imageUrl withCompletion:^(UIImage *image) {
        self.image = image;
        if (block) {
            block(image);
        }
    }];
}

- (NSDictionary *)jsonObject
{
    NSMutableDictionary *jsonData = [[super jsonObject] mutableCopy];
    jsonData[MESSAGE_IMAGE_URL_MESSAGE] = self.imageUrl;
    jsonData[MESSAGE_CONVERSATION_ID] = self.conversationId;
    
    return [NSDictionary dictionaryWithDictionary:jsonData];
}

@end
