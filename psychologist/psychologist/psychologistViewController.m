//
//  psychologistViewController.m
//  psychologist
//
//  Created by lovocas on 13-5-21.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import "psychologistViewController.h"
#import "happinessViewController.h"

@interface psychologistViewController ()

@end

@implementation psychologistViewController
@synthesize  diagnose = _diagnose;

-(happinessViewController *)spiltViewDetailedControl{
    id hvc = [[[self splitViewController] viewControllers] lastObject];
    if(![hvc isKindOfClass:[happinessViewController class]])
        hvc = nil;
    return hvc;
}
- (IBAction)eating {
    
    self.diagnose = 50;
     //[self performSegueWithIdentifier:@"diagnoseSegue" sender:self];
    if([self spiltViewDetailedControl])
        [[self spiltViewDetailedControl]setHappiness:[self diagnose]];
}

- (IBAction)picking {
    
    self.diagnose = 100;
    if([self spiltViewDetailedControl])
        [[self spiltViewDetailedControl]setHappiness:[self diagnose]];
}
- (IBAction)chasingDragon {
    
    self.diagnose = 0;
    if([self spiltViewDetailedControl])
        [[self spiltViewDetailedControl]setHappiness:[self diagnose]];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"diagnoseSegue"])
    [segue.destinationViewController setHappiness:self.diagnose];
    else if([segue.identifier isEqualToString:@"celebritySegue"])
    {
        [segue.destinationViewController setHappiness:100];
    }
    else if([segue.identifier isEqualToString:@"normalSegue"]){
        [segue.destinationViewController setHappiness:0];
    }
    else if([segue.identifier isEqualToString:@"annoyingSegue"]){
   
        [segue.destinationViewController setHappiness:50];
         
    }
   }
-(BOOL)shouldAutorotate{
    return true;
}

@end
