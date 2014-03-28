//
//  AnnotationView.m
//  Annotation
//
//  Created by Soon Chun Mun on 28/3/14.
//  Copyright (c) 2014 Soon Chun Mun. All rights reserved.
//

#import "AnnotationView.h"

#define CAPACITY 100
#define FF .2
#define LOWER 0.01
#define UPPER 1.0

typedef struct {
    CGPoint firstPoint;
    CGPoint secondPoint;
} LineSegment;

@implementation AnnotationView {
    UIImage *incrementalImage;
    CGPoint pts[5];
    uint ctr;
    CGPoint pointsBuffer[CAPACITY];
    uint bufIdx;
    dispatch_queue_t drawingQueue;
    BOOL isFirstTouchPoint;
    LineSegment lastSegmentOfPrev;
    
    CGFloat zoom;
    CGPoint offset;
    
    UIColor *selectedColor;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setMultipleTouchEnabled:NO];
        [self setBackgroundColor:[UIColor whiteColor]];
        drawingQueue = dispatch_queue_create("drawingQueue", NULL);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addDot:)];
        [self addGestureRecognizer:tap];
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
        [self addGestureRecognizer:pinch];
        
        
        selectedColor = [UIColor blackColor];
        offset = CGPointZero;
    }
    return self;
}

- (void)setColor:(UIColor *)c {
    selectedColor = c;
}

- (void)addDot:(UITapGestureRecognizer *)t {
    
}

- (void)pinch:(UIPinchGestureRecognizer *)p {
    if (!zoom) zoom = 1.0;
    CGFloat trans = zoom * p.scale;
    
    if (p.state == UIGestureRecognizerStateEnded) {
        zoom *= p.scale;
        trans = zoom;
    }
    
    CGAffineTransform transform = CGAffineTransformMakeScale(trans, trans);
    self.transform = transform;
}

- (void)eraseDrawing {
    incrementalImage = nil;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    ctr = 0;
    bufIdx = 0;
    pts[0] = [[touches anyObject] locationInView:self];
    isFirstTouchPoint = YES;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint p = [[touches anyObject] locationInView:self];
    ctr++;
    pts[ctr] = p;
    if (ctr == 4) {
        pts[3] = CGPointMake((pts[2].x+pts[4].x)/2.0, (pts[2].y+pts[4].y)/2.0);
        
        for (int i=0; i<4; i++) {
            pointsBuffer[bufIdx+i] = pts[i];
        }
        bufIdx += 4;
        
        CGRect bounds = self.bounds;
        
        dispatch_async(drawingQueue, ^{
            UIBezierPath *offsetPath = [UIBezierPath bezierPath];
            if (bufIdx == 0) return;
            
            LineSegment ls[4];
            for (int i=0; i<bufIdx; i+=4) {
                if (isFirstTouchPoint) {
                    ls[0] = (LineSegment){pointsBuffer[0], pointsBuffer[0]};
                    [offsetPath moveToPoint:ls[0].firstPoint];
                    isFirstTouchPoint = NO;
                } else {
                    ls[0] = lastSegmentOfPrev;
                }
                
                float upper = UPPER;
                float lower = LOWER;
                if (selectedColor == [UIColor whiteColor]) {
                    lower /= 10;
                    upper /= 10;
                }
                
                float frac1 = FF/clamp(len_sq(pointsBuffer[i], pointsBuffer[i+1]), lower, upper);
                float frac2 = FF/clamp(len_sq(pointsBuffer[i+1], pointsBuffer[i+2]), lower, upper);
                float frac3 = FF/clamp(len_sq(pointsBuffer[i+2], pointsBuffer[i+3]), lower, upper);
                ls[1] = [self lineSegmentPerpendicularTo:(LineSegment){pointsBuffer[i],pointsBuffer[i+1]} ofRelativeLength:frac1];
                ls[2] = [self lineSegmentPerpendicularTo:(LineSegment){pointsBuffer[i+1],pointsBuffer[i+2]} ofRelativeLength:frac2];
                ls[3] = [self lineSegmentPerpendicularTo:(LineSegment){pointsBuffer[i+2],pointsBuffer[i+3]} ofRelativeLength:frac3];
                
                [offsetPath moveToPoint:ls[0].firstPoint];
                [offsetPath addCurveToPoint:ls[3].firstPoint controlPoint1:ls[1].firstPoint controlPoint2:ls[2].firstPoint];
                [offsetPath addLineToPoint:ls[3].secondPoint];
                [offsetPath addCurveToPoint:ls[0].secondPoint controlPoint1:ls[2].secondPoint controlPoint2:ls[1].secondPoint];
                [offsetPath closePath];
                
                lastSegmentOfPrev = ls[3];
            }
            
            UIGraphicsBeginImageContextWithOptions(bounds.size, YES, 0.0);
            
            if (!incrementalImage) {
                UIBezierPath *rectPath = [UIBezierPath bezierPathWithRect:bounds];
                [[UIColor whiteColor] setFill];
                [rectPath fill];
            }
            
            [incrementalImage drawAtPoint:offset];
            [selectedColor setStroke];
            [selectedColor setFill];
            [offsetPath stroke];
            [offsetPath fill];
            incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            [offsetPath removeAllPoints];
            dispatch_async(dispatch_get_main_queue(), ^{
                bufIdx = 0;
                [self setNeedsDisplay];
            });
        });
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect {
    [incrementalImage drawInRect:rect];
    [self setNeedsDisplay];
}

- (LineSegment)lineSegmentPerpendicularTo:(LineSegment)pp ofRelativeLength:(float)fraction {
    CGFloat x0 = pp.firstPoint.x;
    CGFloat y0 = pp.firstPoint.y;
    CGFloat x1 = pp.secondPoint.x;
    CGFloat y1 = pp.secondPoint.y;
    
    CGFloat dx, dy;
    dx = x1 - x0;
    dy = y1 - y0;
    
    CGFloat xa, xb, ya, yb;
    xa = x1 + fraction/2 * dy;
    ya = y1 - fraction/2 * dx;
    xb = x1 - fraction/2 * dy;
    yb = y1 + fraction/2 * dx;
    
    return (LineSegment){ (CGPoint){xa,ya}, (CGPoint){xb,yb} };
}

float len_sq(CGPoint p1, CGPoint p2) {
    float dx = p2.x - p1.x;
    float dy = p2.y - p1.y;
    return dx * dx + dy * dy;
}

float clamp(float value, float lower, float higher) {
    if (value < lower) return lower;
    if (value > higher) return higher;
    return value;
}

@end
