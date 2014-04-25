//
//  AnnotationPalette.m
//  Annotation
//
//  Created by Soon Chun Mun on 28/3/14.
//  Copyright (c) 2014 Soon Chun Mun. All rights reserved.
//

#import "AnnotationPalette.h"

#define INCREMENT 0.05

@implementation AnnotationPalette {
    NSMutableArray *colors;
    NSMutableArray *buttons;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initColors];
        [self initButtons];
    }
    
    self.backgroundColor = [[UIColor alloc] initWithWhite:1 alpha:1];
    
    return self;
}

- (void)initColors {
    colors = [NSMutableArray array];
    [colors addObject:[UIColor blackColor]];
    [colors addObject:[UIColor whiteColor]];

    for (float hue = 0.0; hue < 1.0; hue += INCREMENT) {
        UIColor *color = [UIColor colorWithHue:hue
                                    saturation:1.0
                                    brightness:1.0
                                         alpha:1.0];
        [colors addObject:color];
    }
}

- (void)initButtons {
    buttons = [NSMutableArray array];
    for (int i = 0; i < NUM_COLORS; i++) {
        
        CGRect btnFrame = CGRectMake(i * BUTTON_SIZE, 0, BUTTON_SIZE, BUTTON_SIZE);
        UIButton *button = [[UIButton alloc] initWithFrame:btnFrame];
    
        button.layer.borderWidth = 0.0;
        [button.layer setMasksToBounds:YES];
        button.alpha = PALETTE_ALPHA;
        button.backgroundColor = colors[i%[colors count]];
        [button addTarget:self
                   action:@selector(colorTap:)
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [buttons addObject:button];
        [self addSubview:button];
    }
    [self colorTap:buttons[0]];
}

- (void)colorTap:(UIButton *)tappedButton {
    [self.delegate tap:tappedButton];

    BOOL found = 0;
    CGRect btnFrame;
    
    for (int i = 0; i < [buttons count]; i++) {
        
        UIButton *button = (UIButton *)buttons[i];
        button.alpha = PALETTE_ALPHA;
        button.layer.borderColor = [UIColor whiteColor].CGColor;
        button.layer.borderWidth = PALETTE_BORDER_WIDTH;
        
        if (tappedButton == button) {
            found = true;
        }
        
        if (!found) {
            btnFrame = CGRectMake(i * BUTTON_SIZE,
                                  button.frame.origin.y,
                                  BUTTON_SIZE,
                                  BUTTON_SIZE);
            [button setFrame:btnFrame];
        } else {
            if (tappedButton == button) {
                btnFrame = CGRectMake(i * BUTTON_SIZE,
                                      button.frame.origin.y,
                                      BUTTON_SIZE * 2,
                                      BUTTON_SIZE);
                button.layer.borderColor = [UIColor blackColor].CGColor;
                button.layer.borderWidth = PALETTE_BORDER_WIDTH_TAPPED;
            } else {
                btnFrame = CGRectMake(i * BUTTON_SIZE + BUTTON_SIZE,
                                      button.frame.origin.y,
                                      BUTTON_SIZE,
                                      BUTTON_SIZE);
            }
        }
        
        [button setFrame:btnFrame];
    }
    
    tappedButton.alpha = PALETTE_TAPPED_ALPHA;
}

@end
