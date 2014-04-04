//
//  ViewController.m
//  Annotator
//
//  Created by Soon Chun Mun on 28/3/14.
//  Copyright (c) 2014 Soon Chun Mun. All rights reserved.
//

#import "AnnotateViewController.h"
#import "AnnotationView.h"
#import "AnnotationPalette.h"

@interface AnnotateViewController () <PaletteTouchDelegate>

@end

@implementation AnnotateViewController {
    UIImage *image;
    UIImageView *bgView;
    AnnotationView *drawArea;
    AnnotationPalette *palette;
    CGPoint last;
    CGFloat zoom;
}

- (id)initWithImage:(UIImage *)loadImage {
    if (self = [super init]) {
        image = loadImage;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    pan.minimumNumberOfTouches = 2;
    [self.view addGestureRecognizer:pan];
     
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.view addGestureRecognizer:pinch];
        
    [self.view setBackgroundColor:[UIColor grayColor]];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(editedImage:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
}


- (void)viewDidAppear:(BOOL)animated {
    // Initialize image
    if (image) {
        CGFloat startx = (self.view.bounds.size.width-image.size.width)/2;
        CGFloat starty = (self.view.bounds.size.height-image.size.height)/2;
        CGRect aframe = CGRectMake(startx,starty,image.size.width,image.size.height);
        drawArea = [[AnnotationView alloc] initWithFrame:aframe];
        bgView = [[UIImageView alloc] initWithImage:image];
        bgView.frame = aframe;
        [self.view addSubview:bgView];
    } else {
        drawArea = [[AnnotationView alloc] initWithFrame:self.view.bounds];
    }
    
    [self.view addSubview:drawArea];
     
    //int s = BUTTON_SIDE_OFFSET * 2 + BUTTON_SIZE;
    //int height = s * NUM_COLORS - ((NUM_COLORS-1) * BUTTON_SIDE_OFFSET);
    //CGRect pFrame = CGRectMake(0,(self.view.bounds.size.height-height)/2, s, height);
    
    CGRect pFrame = CGRectMake(0, self.view.frame.size.height - 50, self.view.frame.size.width, 50);
    palette = [[AnnotationPalette alloc] initWithFrame:pFrame];
    palette.delegate = self;
    [self.view addSubview:palette];
    
}

- (void)pan:(UIPanGestureRecognizer *)p {
    if (p.state == UIGestureRecognizerStateBegan) {
        last = drawArea.center;
    }
    
    CGPoint pos = [p translationInView:self.view];
    CGFloat dx = last.x + pos.x;
    CGFloat dy = last.y + pos.y;
    drawArea.center = CGPointMake(dx, dy);
    bgView.center = drawArea.center;

    if (p.state == UIGestureRecognizerStateEnded) {
        last = drawArea.center;
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)p {
    if (!zoom) zoom = 1.0;
    CGFloat trans = zoom * p.scale;
    
    if (p.state == UIGestureRecognizerStateEnded) {
        zoom *= p.scale;
        trans = zoom;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeScale(trans, trans);
    drawArea.transform = transform;
    bgView.transform = transform;
}

- (void)tap:(UIButton *)b{
    [drawArea setColor:[b backgroundColor]];
}


- (IBAction) editedImage:(id)sender
{
    UIImage *editedImage = [self saveImage];
    [_delegate userCompleteAnnotation:editedImage];
}

- (UIImage *)saveImage {
    UIGraphicsBeginImageContext(drawArea.frame.size);
    [[drawArea layer] renderInContext:UIGraphicsGetCurrentContext()];
    [[bgView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *savedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return savedImage;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
