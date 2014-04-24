//
//  PomocWindow.m
//  PomocSDK
//
//  Created by soedar on 28/3/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "PomocWindow.h"
#import "YSChatHead.h"
#import "PomocChatView.h"
#import "PomocResources.h"

@interface PomocWindow () <YSChatHeadDelegate>

@property (nonatomic, strong) YSChatHead *chatHead;
@property (nonatomic, strong) PomocChatView *chatView;

@end

@implementation PomocWindow

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupChatHead];
    }
    return self;
}

- (void)setupChatHead
{
    UIImage *image = [PomocResources imageNamed:@"pomoc_logo" type:@"png"];
    self.chatHead = [[YSChatHead alloc] initWithFrame:CGRectMake(80, 80, 80, 80) image:image];
    self.chatHead.delegate = self;
    [self addSubview:self.chatHead];
}

- (void)setupChatView
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat width = bounds.size.width;
    CGFloat height = bounds.size.height;
    self.chatView = [[PomocChatView alloc] initWithFrame:CGRectMake(0, 30, width*0.75, height*0.75)];
    self.chatView.center = CGPointMake(width/2, self.chatView.center.y);
    
    [self insertSubview:self.chatView belowSubview:self.chatHead];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    NSMutableArray *views = [NSMutableArray arrayWithObject:self.chatHead];
    if (self.chatView) {
        [views addObject:self.chatView];
    }
    
    for (UIView *view in views) {
        if (!view.hidden && CGRectContainsPoint(view.frame, point)) {
            CGPoint adjustedPoint = [view convertPoint:point fromView:self];
            return [view hitTest:adjustedPoint withEvent:event];
        }
    }
    
    return [[[UIApplication sharedApplication] windows][0] hitTest:point withEvent:event];
}

#pragma mark - ChatHead Delegate
- (void)chatHeadPressed:(YSChatHead *)chatHead
{
    if (!self.chatView) {
        [self setupChatView];
        return;
    }
    
    self.chatView.hidden = !self.chatView.hidden;
    [self.chatView dismissKeyboard];
}

@end
