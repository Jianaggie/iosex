//
//  happinessViewController.m
//  happiness

//
//  Created by lovocas on 13-5-19.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "happinessViewController.h"
#import "faceView.h"
#import "DreamTableViewController.h"

@interface happinessViewController ()<viewDataSource,showFaceDelegate>
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;


@end

@implementation happinessViewController 
@synthesize happiness = _happiness;
@synthesize faceview = _faceview;
@synthesize spiltBarButtonItem =_spiltBarButtonItem;
@synthesize toolbar =_toolbar;
#define DREAM_LIST @"happinessViewController.dreamlist"
-(void)setSpiltBarButtonItem:(UIBarButtonItem *)spiltBarButtonItem
{
    if(_spiltBarButtonItem!=spiltBarButtonItem){
        NSMutableArray * toolbarButtonItem = [_toolbar.items mutableCopy] ;
        if(_spiltBarButtonItem)[toolbarButtonItem removeObject:_spiltBarButtonItem];
        if(spiltBarButtonItem)[toolbarButtonItem insertObject:spiltBarButtonItem atIndex:0];
        _toolbar.items = toolbarButtonItem;
        _spiltBarButtonItem = spiltBarButtonItem;
    }
}
- (void) setHappiness: (int) happiness {
     _happiness = happiness;
     [self.faceview  setNeedsDisplay];
    
}

- (void)setFaceview:(faceView *)faceview{
    _faceview = faceview;
    self.faceview.dataSourceDele = self;
    [self.faceview  addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.faceview action:@selector(pinch:)]];
    
    [self.faceview  addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(handlerPanGesture:)]];
}
-(float) setSmileness:(faceView *)sender{
    return (self.happiness -50)/50;
}
- (void)handlerPanGesture:(UIPanGestureRecognizer *)recognizer
{
    if((recognizer.state == UIGestureRecognizerStateChanged)||(recognizer.state == UIGestureRecognizerStateEnded) )
    {
        CGPoint transformation = [recognizer  translationInView:self.faceview];
        self.happiness -= transformation.y/2;
        [recognizer setTranslation:CGPointZero inView:self.faceview];
    }
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier  isEqualToString:@"showingDreamlist"]){
        //prepare the Model of tableview
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        NSArray * tempArray = [defaults objectForKey:DREAM_LIST];
        [[segue destinationViewController]setDreamlist:tempArray] ;
        //set the delegate
        [[segue destinationViewController]setDreamdelegate:self];
    }
}
-(void)showHappiness:(int)happiness Face:(DreamTableViewController *)sender{
    self.happiness = happiness;
}

- (IBAction)addToMyDream:(id)sender {
    //add the new item in the NSDefaultUser
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray * dreamlist = [[defaults objectForKey:DREAM_LIST]mutableCopy];
    if(!dreamlist) dreamlist = [NSMutableArray array];
    [dreamlist addObject:[NSNumber numberWithInt:self.happiness]];
    [defaults setObject:dreamlist forKey:DREAM_LIST];
    [defaults synchronize];
}

- (BOOL)shouldAutorotate{
    return true;
}
  
@end
