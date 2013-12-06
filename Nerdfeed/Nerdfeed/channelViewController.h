//
//  channelViewController.h
//  Nerdfeed
//
//  Created by lovocas on 13-11-29.
//  Copyright (c) 2013年 maggie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "listViewController.h"
#import "RSChannel.h"

@interface channelViewController : UITableViewController <listViewControllerDelegator,UISplitViewControllerDelegate>
{
    RSChannel * channel;
}
@end
