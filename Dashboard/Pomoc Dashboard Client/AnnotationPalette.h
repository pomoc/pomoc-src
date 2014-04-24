//
//  AnnotationPalette.h
//  Annotation
//
//  Created by Soon Chun Mun on 28/3/14.
//  Copyright (c) 2014 Soon Chun Mun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PaletteTouchDelegate <NSObject>

@required

- (void)tap:(UIButton *)b;

@end

@interface AnnotationPalette : UIView

@property (nonatomic, weak) id<PaletteTouchDelegate> delegate;

@end
