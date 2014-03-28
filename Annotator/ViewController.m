//
//  ViewController.m
//  Annotator
//
//  Created by Soon Chun Mun on 28/3/14.
//  Copyright (c) 2014 Soon Chun Mun. All rights reserved.
//

#import "ViewController.h"
#import "AnnotationView.h"
#import "AnnotationPalette.h"

@interface ViewController () <PaletteTouchDelegate>

@end

@implementation ViewController {
    AnnotationView *drawArea;
    AnnotationPalette *palette;
    CGPoint last;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    drawArea = [[AnnotationView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:drawArea];
    int s = BUTTON_SIDE_OFFSET * 2 + BUTTON_SIZE;
    int height = s * NUM_COLORS - ((NUM_COLORS-1) * BUTTON_SIDE_OFFSET);
    CGRect pFrame = CGRectMake(0,(self.view.bounds.size.height-height)/2, s, height);
    palette = [[AnnotationPalette alloc] initWithFrame:pFrame];
    palette.delegate = self;
    [self.view addSubview:palette];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.minimumNumberOfTouches = 2;
    [self.view addGestureRecognizer:pan];
    
    [self.view setBackgroundColor:[UIColor grayColor]];
}

- (void)pan:(UIPanGestureRecognizer *)p {
    if (p.state == UIGestureRecognizerStateBegan) {
        last = drawArea.center;
    }
    
    CGPoint pos = [p translationInView:self.view];
    CGFloat dx = last.x + pos.x;
    CGFloat dy = last.y + pos.y;
    drawArea.center = CGPointMake(dx, dy);

    if (p.state == UIGestureRecognizerStateEnded) {
        last = drawArea.center;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tap:(UIButton *)b{
    [drawArea setColor:[b backgroundColor]];
}

@end
