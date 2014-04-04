//
//  ViewController.h
//  Annotator
//
//  Created by Soon Chun Mun on 28/3/14.
//  Copyright (c) 2014 Soon Chun Mun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnnotateViewControllerDelegate
@required
- (void)userCompleteAnnotation:(UIImage *)image;
@end


@interface AnnotateViewController : UIViewController
@property (nonatomic, assign) id delegate;
- (id)initWithImage:(UIImage *)loadImage;
@end
