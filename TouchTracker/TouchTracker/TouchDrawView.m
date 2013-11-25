//
//  TouchDrawView.m
//  TouchTracker
//
//  Created by lovocas on 13-11-25.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "TouchDrawView.h"
#import "Line.h"

@implementation TouchDrawView

-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if(self)
    {
       // init the collections;
        //
    
        completeLines = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getPaths]];
        if(!completeLines){
        completeLines =[[NSMutableArray alloc]init];
        }
        LinesInProcess =[[NSMutableDictionary alloc]init];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setMultipleTouchEnabled:YES];
        
    }
    return self;
}
-(NSString * )getPaths
{
    NSArray * directories= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * domaindirector=[directories objectAtIndex:0];
    //return [domaindirector stringByAppendingPathComponent:@"items.archive"];
    return [domaindirector stringByAppendingPathComponent:@"store.data"];}

-(void)saveChanges
{
    //NSKeyedArchiver * arc=[NSKeyedArchiver alloc]ini
    [NSKeyedArchiver  archiveRootObject:completeLines toFile:[self getPaths]];
}
-(void)drawRect:(CGRect)rect
{
    //set the context
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 10.0);
    CGContextSetLineCap(context,kCGLineCapRound);
   //draw complete lines in black
    [[UIColor blackColor]set];
    for (Line * line in completeLines)
    {
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
        CGContextStrokePath(context);
    }
    [[UIColor redColor]set];
    for(NSValue * value in LinesInProcess)
    {
        Line * line =[LinesInProcess objectForKey:value];
        CGContextMoveToPoint(context, line.begin.x, line.begin.y);
        CGContextAddLineToPoint(context, line.end.x, line.end.y);
        CGContextStrokePath(context);
    }
    
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
        if([touch tapCount]>1)
        {
            [self clearAll];
            return;
        }
        //deal with the touch
        NSValue * key =[NSValue valueWithNonretainedObject:touch];
        Line * line =[[Line alloc]init];
        line.begin =[touch locationInView:self];
        line.end =line.begin;
        [LinesInProcess setObject:line forKey:key];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for(UITouch * touch in touches)
    {
                //deal with the touch
        NSValue * key =[NSValue valueWithNonretainedObject:touch];
        Line  * line =[LinesInProcess objectForKey:key];
        line.end = [touch locationInView:self];
        

    }
    [self setNeedsDisplay];
}

-(void)endTouch:(NSSet *)touches
{
    //end the touch
    for(UITouch * touch in touches)
    {
        //deal with the touch
        NSValue * key =[NSValue valueWithNonretainedObject:touch];
        Line  * line =[LinesInProcess objectForKey:key];
        if(line){
            line.end = [touch locationInView:self];
            [completeLines addObject:line];
            [LinesInProcess removeObjectForKey:key];
        }
        
        
    }
     [self setNeedsDisplay];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouch:touches];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endTouch:touches];
}

-(void)clearAll
{
    [completeLines removeAllObjects];
    [LinesInProcess removeAllObjects];
    [self setNeedsDisplay];
}

@end
