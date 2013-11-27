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

@synthesize selectedLine;
-(int) numberOfLines
{
    int count=0;
    if(LinesInProcess&& completeLines)
    {
        count = [LinesInProcess count]+[completeLines count];
    }
    return  count;
}

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
        UITapGestureRecognizer * ges=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:ges];
       UILongPressGestureRecognizer *press =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        /*UISwipeGestureRecognizer * swipe=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeMove:)];
        [swipe setNumberOfTouchesRequired:3];
        [swipe setDirection:UISwipeGestureRecognizerDirectionUp];
        [self addGestureRecognizer:swipe];*/
        pan =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(moveline:)];
        [pan setDelegate:self];
        [pan setCancelsTouchesInView:NO];
        [self addGestureRecognizer:pan];
        [self addGestureRecognizer:press];
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setMultipleTouchEnabled:YES];
        flag=NO;
        col =[UIColor blackColor];
        
    }
    return self;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if(gestureRecognizer==pan)
        return YES;
    else
        return NO;
}
-(void)moveline:(UIPanGestureRecognizer*)panG
{
    //
    
    if(![self selectedLine])
    {
       NSLog(@"drawing a line x,%f,%f",[panG velocityInView:self].x,[panG velocityInView:self].y );
        return;
    }
    if(flag ==NO)
        return;
    if(panG.state ==UIGestureRecognizerStateChanged)
    {
        //get the transition and move the line to the new position
        CGPoint transiton =[pan translationInView:self];
        CGPoint begin =[self selectedLine].begin;
        CGPoint end =[self selectedLine].end;
        begin.x+=transiton.x;
        begin.y+=transiton.y;
        end.x+=transiton.x;
        end.y+=transiton.y;
        self.selectedLine.begin =begin;
        self.selectedLine.end=end;
        
    }
    [pan setTranslation:CGPointZero inView:self];
    [self setNeedsDisplay];
}
-(void)longPress:(UIGestureRecognizer *) gr
{
  // NSLog(<#NSString *format, ...#>)
    if (gr.state ==UIGestureRecognizerStateBegan) {
        NSLog(@"press state is begin ");
        CGPoint loc=[gr locationInView:self];
        [self setSelectedLine:[self lineAtPoint:loc]];
        [LinesInProcess removeAllObjects];
        flag=YES;
    } else if(gr.state ==UIGestureRecognizerStateEnded){
        [self setSelectedLine:nil];
        NSLog(@"press state is end ");
    }
    [self setNeedsDisplay];
}
-(Line*)lineAtPoint:(CGPoint)point
{
    for(Line * line in completeLines)
    {
        CGPoint start = line.begin;
        CGPoint end = line.end;
        for(float t =0.0;t<1.0;t+=0.05)
        {
            float x= start.x +t*(end.x-start.x);
            float y =start.y+t*(end.y-start.y);
            if(hypot(point.x-x,point.y-y)<20.0)
                return line;
            
        }
    }
    return nil;
    
}
-(void)swipeMove:(UISwipeGestureRecognizer *)swipe
{
    if(swipe.state == UISwipeGestureRecognizerDirectionUp)
    {
        [self becomeFirstResponder];
        CGPoint loc=[swipe locationInView:self];
        UIMenuController * menu =[UIMenuController sharedMenuController];
        UIMenuItem * item =[[UIMenuItem alloc]initWithTitle:@"Red" action:@selector(setColor:)];
        [menu setMenuItems:[NSArray arrayWithObject:item]];
        
        [menu setTargetRect:CGRectMake(loc.x, loc.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
}

-(void)setColor:(UIColor *)color
{
    col=[UIColor redColor];
    [self setNeedsDisplay];
}
-(void)tap:(UIGestureRecognizer *) ges
{
    NSLog(@"you tap!");
    CGPoint loc=[ges locationInView:self];
    self.selectedLine=[self lineAtPoint:loc];
    //
   
    if(self.selectedLine)
    {
        [self becomeFirstResponder];
         UIMenuController * menu =[UIMenuController sharedMenuController];
        UIMenuItem * item =[[UIMenuItem alloc]initWithTitle:@"delete" action:@selector(delete)];
        [menu setMenuItems:[NSArray arrayWithObject:item]];
        
        [menu setTargetRect:CGRectMake(loc.x, loc.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
    }
    else{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
        
    }
    [LinesInProcess removeAllObjects];
    [self setNeedsDisplay];
}
-(BOOL)canBecomeFirstResponder
{
    return YES;
}
-(void)delete
{
    [completeLines removeObject:[self selectedLine]];
    [self setNeedsDisplay];
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
   // [[UIColor blackColor]set];
    [col set];
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
    if(selectedLine)
    {
        [[UIColor greenColor]set];
        CGContextMoveToPoint(context, selectedLine.begin.x, selectedLine.begin.y);
        CGContextAddLineToPoint(context, selectedLine.end.x, selectedLine.end.y);
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
        if(line ==nil)
            NSLog(@"line is nil");
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
            [line setContainingArray:completeLines];
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
    //completeLines =[[NSMutableArray alloc]init];
    [LinesInProcess removeAllObjects];
    [self setNeedsDisplay];
}

@end
