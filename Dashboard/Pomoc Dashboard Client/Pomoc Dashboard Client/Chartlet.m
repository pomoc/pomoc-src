//
//  Chartlet.m
//  Pomoc Dashboard Client
//
//  Created by Soon Chun Mun on 4/20/14.
//  Copyright (c) 2014 nus.cs3217. All rights reserved.
//

#import "Chartlet.h"
@interface Chartlet () {
    UILabel *titleLabel;
    UILabel *numberLabel;
}

@end

@implementation Chartlet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeChartlet];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setNumberText:(NSString *)numberText {
    _numberText = numberText;
    numberLabel.text = numberText;
}

- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    titleLabel.text = titleText;
}

- (void)initializeChartlet {
    titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:self.titleText];
    [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:titleLabel];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:0.5
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:0.25
                                                      constant:0]];
    
    numberLabel = [[UILabel alloc] init];
    numberLabel.textAlignment = NSTextAlignmentCenter;
    [numberLabel setText:self.numberText];
    [numberLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addSubview:numberLabel];
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
        
     [self addConstraint:[NSLayoutConstraint constraintWithItem:numberLabel
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:0.75
                                                      constant:0]];
}

@end
