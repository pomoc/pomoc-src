//
//  PomocChatView+Image.m
//  PomocSDK
//
//  Created by soedar on 22/4/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PomocChatView+Image.h"
#import "PomocChatView_Private.h"
#import "PomocResources.h"

@implementation PomocChatView (Image)

- (void)showImage:(UIImage *)image
{
    self.imageView = [[UIView alloc] initWithFrame:CGRectMake(0, CHAT_VIEW_HEADER_HEIGHT, self.frame.size.width, self.frame.size.height-CHAT_VIEW_HEADER_HEIGHT)];
    [self.imageView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
    
    CGRect frame = self.imageView.bounds;
    frame.size.width *= 0.9;
    frame.size.height *= 0.9;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    [imageView setImage:image];
    [imageView setCenter:CGPointMake(self.imageView.frame.size.width/2.0, self.imageView.frame.size.height / 2.0)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView addSubview:imageView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeImage:)];
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
    UIImageView *closeImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.imageView.frame.size.width-32, 0, 32, 32)];
    
    [closeImage setImage:[PomocResources imageNamed:@"close-icon" type:@"png"]];
    
    [self.imageView addSubview:closeImage];
    
    [self addSubview:self.imageView];
}

- (void)removeImage:(UITapGestureRecognizer *)tapRecognizer
{
    [self.imageView removeFromSuperview];
}

@end
