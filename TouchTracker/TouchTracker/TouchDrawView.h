//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by lovocas on 13-11-25.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Line;
@interface TouchDrawView : UIView<UIGestureRecognizerDelegate>
{
    NSMutableArray * completeLines;
    NSMutableDictionary * LinesInProcess;
    UIPanGestureRecognizer * pan;
   // UILongPressGestureRecognizer * press;
    BOOL flag ;
    UIColor * col;
}

@property (nonatomic,weak) Line * selectedLine;
-(Line *)lineAtPoint:(CGPoint ) point;
-(void)clearAll;
-(void)saveChanges;
-(void)tap:(UIGestureRecognizer *) ges;
-(void)longPress:(UIGestureRecognizer *) gr;
-(void)moveline:(UIPanGestureRecognizer*)panG;
-(void)setColor:(UIColor *)color;
-(void)swipeMove:(UISwipeGestureRecognizer *)swipe;
-(void)delete;
@end
