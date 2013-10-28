//
//  hyposister.m
//  hyposister
//
//  Created by lovocas on 13-7-23.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "hyposister.h"

@implementation hyposister
@synthesize circlecolor =_circlecolor ;
-(id)initWithFrame:(CGRect)frame
{
    self= [super initWithFrame:frame];
    if(self){
        [self setBackgroundColor:[UIColor clearColor]];
        [self setCirclecolor:[UIColor blackColor]];
    }
    return  self;
}
-(BOOL) canBecomeFirstResponder
{
    return YES;
}
-(void)setCirclecolor:(UIColor *)circlecolor
{
    _circlecolor = circlecolor;
    [self setNeedsDisplay];
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
     if(motion == UIEventSubtypeMotionShake)
     {
         [self setCirclecolor:[UIColor redColor]];
     }
}
-(void) drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect bounds = [self bounds];
    CGPoint  center ;
    center.x = bounds.origin.x + bounds.size.width/2;
    center.y = bounds.origin.y + bounds.size.height/2;
    float maxredius = MIN(bounds.size.width, bounds.size.height)/2;
    //hypot(<#double#>, <#double#>)
    CGContextSetLineWidth(ctx, 10);
    CGContextSetRGBStrokeColor(ctx, 0.6, 0.6, 0.6, 1);
    CGContextAddArc(ctx, center.x, center.y, maxredius, 0.0, M_2_PI,YES);
    CGContextStrokePath(ctx);
    NSString * text = @"you are getting sleepy";
    UIFont * font = [UIFont boldSystemFontOfSize:14];
    CGRect textRect;
    textRect.size =[text sizeWithFont:font];
    textRect.origin.x = center.x -textRect.size.width/2;
    textRect.origin.y = center.y-textRect.size.height/2;
    [[self circlecolor]setFill];
    CGSize offset = CGSizeMake(4, 3);
    CGColorRef color =[[UIColor blueColor ]CGColor];
    CGContextSetShadowWithColor(ctx, offset, 2, color);
    [text drawInRect:textRect withFont:font];
    
}
@end
