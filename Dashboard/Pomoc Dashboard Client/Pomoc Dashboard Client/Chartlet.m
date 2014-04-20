//
//  Chartlet.m
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 4/20/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "Chartlet.h"
@interface Chartlet () {
    
    
}

@end

@implementation Chartlet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeChartlet];
    }
    return self;
}

- (void)setNumberText:(NSString *)numberText {
    self.numberText = numberText;
    [self setNeedsDisplay];
}

- (void)setTitleText:(NSString *)titleText {
    self.titleText = titleText;
    [self setNeedsDisplay];
}

- (void)initializeChartlet {
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setText:self.titleText];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.5
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.5
                                                      constant:0]];
    
    
    UILabel *numberLabel = [[UILabel alloc] init];
    [numberLabel setText:self.numberText];
    [numberLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:numberLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.5
                                                      constant:0]];
    
     [self addConstraint:[NSLayoutConstraint constraintWithItem:numberLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
