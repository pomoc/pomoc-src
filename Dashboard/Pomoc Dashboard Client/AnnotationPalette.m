//
//  AnnotationPalette.m
//  Annotation
//
//  Created by Soon Chun Mun on 28/3/14.
//  Copyright (c) 2014 Soon Chun Mun. All rights reserved.
//

#import "AnnotationPalette.h"

@implementation AnnotationPalette {
    NSMutableArray *colors;
    NSMutableArray *buttons;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initColors];
        [self initButtons];
    }
    return self;
}

- (void)initColors {
    colors = [NSMutableArray array];
    [colors addObject:[UIColor blackColor]];
    [colors addObject:[UIColor whiteColor]];
    
    float INCREMENT = 0.05;
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
    for (int i=0; i<NUM_COLORS; i++) {
        int offset = i * BUTTON_SIDE_OFFSET;
        int top = BUTTON_SIDE_OFFSET;
        if (i == 0) offset = 0;
        
        CGRect btnFrame = CGRectMake(BUTTON_SIDE_OFFSET, i * BUTTON_SIZE+offset+top, BUTTON_SIZE, BUTTON_SIZE);
        UIButton *b = [[UIButton alloc] initWithFrame:btnFrame];
        [b.layer setBorderColor: [[UIColor grayColor] CGColor]];
        [b.layer setBorderWidth: 4.0];
        [b.layer setMasksToBounds:YES];
        //[b.layer setCornerRadius:BUTTON_SIZE/2.0];
        [b setAlpha:0.5];
        
        [b setBackgroundColor:colors[i%[colors count]]];
        [b addTarget:self action:@selector(colorTap:) forControlEvents:UIControlEventTouchUpInside];
        b.tag = i;
        [buttons addObject:b];
        [self addSubview:b];
    }
    [self colorTap:buttons[0]];
}

- (void)colorTap:(UIButton *)b {
    [self.delegate tap:b];
    
    for (int i=0; i<[buttons count]; i++){
        [((UIButton *)buttons[i]).layer setBorderColor: [[UIColor grayColor] CGColor]];
        [((UIButton *)buttons[i]).layer setBorderWidth: 4.0];
        [(UIButton *)buttons[i] setAlpha:0.5];
    }
    
    [b.layer setBorderColor: [[UIColor blackColor] CGColor]];
    [b.layer setBorderWidth: 4.0];
    [b setAlpha:1.0];
}

- (void)undo {
    
}

@end
