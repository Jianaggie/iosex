//
//  TouchDrawView.h
//  TouchTracker
//
//  Created by lovocas on 13-11-25.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TouchDrawView : UIView
{
    NSMutableArray * completeLines;
    NSMutableDictionary * LinesInProcess;
}
-(void)clearAll;
-(void)saveChanges;
@end
