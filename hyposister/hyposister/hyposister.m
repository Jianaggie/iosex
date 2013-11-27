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
        layer =[[CALayer alloc]init];
        [layer setBounds:CGRectMake(0, 0, 85, 85)];
        [layer setPosition:CGPointMake(100, 100)];
        UIColor * redish = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
        CGColorRef red = [redish CGColor];
        [layer setBackgroundColor:red];
        // set content
        UIImage * image = [UIImage imageNamed:@"1.jpg"];
        CGImageRef  img =[image CGImage];
        [layer setContents:(__bridge id)img];
        //[layer setContentsRect:CGRectMake(-1, -1, 1.2, 1.2)];
        //[layer setContentsGravity:kCAGravityResizeAspect];
        
        [self.layer addSublayer:layer];
    }
    return  self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch =[touches anyObject];
    CGPoint loc =[touch locationInView:self];
    [layer setPosition:loc];
}
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch =[touches anyObject];
    CGPoint loc =[touch locationInView:self];
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [layer setPosition:loc];
    
    [CATransaction commit];
    
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
    CABasicAnimation * animation= [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setFromValue:[NSValue valueWithCGPoint:CGPointZero]];
    [animation setToValue:[NSValue valueWithCGPoint:CGPointMake(100, 100)]];
    [animation setDuration:2.0];
    [layer addAnimation:animation forKey:@"annimation"];
    
    
}
@end
