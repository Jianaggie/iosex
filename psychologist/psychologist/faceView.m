//
//  faceView.m
//  happiness
//
//  Created by lovocas on 13-5-19.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "faceView.h"

@implementation faceView
@synthesize scale = _scale;
@synthesize dataSourceDele = _dataSourceDele;
#define DEFAULT_SCALE 0.90

- (CGFloat)scale{
    if(!_scale)
        return  DEFAULT_SCALE;
    else
       return _scale;
    
}

-(void) setScale:(CGFloat)scale
{
    if(_scale != scale)
    {
        _scale = scale;
        [self setNeedsDisplay];
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)recognizer
{
    if((recognizer.state == UIGestureRecognizerStateChanged )||( recognizer.state == UIGestureRecognizerStateEnded))
    {
        self.scale*= recognizer.scale;
        recognizer.scale = 1;
    }
    
}
-(void)setUp
{
    [self setContentMode:UIViewContentModeRedraw];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUp];
    }
    return self;
}
- (void)awakeFromNib{
    [self setUp];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void) drawCircleAtPoint:(CGPoint) p withRadius:(CGFloat)radius inContext :(CGContextRef)context
{
    UIGraphicsPushContext(context);
    CGContextBeginPath(context);
    CGContextAddArc(context, p.x,p.y, radius, 0, 2*M_PI, YES);
    CGContextStrokePath(context);
    UIGraphicsPopContext();
}

-(void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
 //draw a face
    CGPoint middle ;
    middle.x = self.bounds.origin.x + self.bounds.size.width/2;
    middle.y = self.bounds.origin.y + self.bounds.size.height/2;
    CGFloat size =self.bounds.size.width/2;
    if(self.bounds.size.height<self.bounds.size.width)
        size = self.bounds.size.height/2;
    size *=[self scale];
    CGContextSetLineWidth(context, 5.0);
    [[UIColor blueColor ] setStroke];
    [self drawCircleAtPoint:middle withRadius:size inContext:context];
    
 // draw eyes
    #define EYE_H 0.35
    #define EYE_V 0.35
    #define EYE_RADIUS 0.10


    CGPoint eyePoint;
    eyePoint.x = middle.x-size*EYE_H;
    eyePoint.y = middle.y- size*EYE_V;
    [self drawCircleAtPoint:eyePoint withRadius:size*EYE_RADIUS inContext:context];
    eyePoint.x = middle.x+ size*EYE_H*2;
    [self drawCircleAtPoint:eyePoint withRadius:size*EYE_RADIUS inContext:context];

    
// draw the mouth
    #define MOUTH_H 0.45
    #define  MOUTH_V 0.40
    #define  MOUTH_SMILE 0.25
    CGPoint mouthStart;
    mouthStart.x=middle.x-MOUTH_H*size;
    mouthStart.y=middle.y+MOUTH_V*size;
    CGPoint mouthEnd = mouthStart;
    mouthEnd.x +=MOUTH_H*size*2;
    CGPoint mouthCP1 = mouthStart;
    mouthCP1.x +=MOUTH_H*size*2/3;
    CGPoint mouthCP2 = mouthEnd;
    mouthCP2.x -=MOUTH_H*size*2/3;
    float smile =[_dataSourceDele setSmileness:self];
    if(smile <-1) smile =-1;
    if(smile >1) smile = 1;
    CGFloat smileOffset =MOUTH_SMILE*size*smile;
    mouthCP1.y +=smileOffset;
    mouthCP2.y+=smileOffset;
    CGContextBeginPath(context);
    //CGContextAddArc(context, p.x,p.y, radius, 0, 2*M_PI, YES);
    CGContextMoveToPoint(context, mouthStart.x, mouthStart.y);
   
    CGContextAddCurveToPoint(context, mouthCP1.x, mouthCP1.y, mouthCP2.x, mouthCP2.y, mouthEnd.x, mouthEnd.y);
     CGContextStrokePath(context);
    
}

@end
