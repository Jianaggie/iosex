//
//  AppCatalogController.h
//  MCDM
//
//  Created by Fred on 13-1-1.
//  Copyright (c) 2013年 Fred. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppCatalogController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSString *_mainKey;
    
    UITableView *_tableView;
    
    NSDictionary *_appDict;
    NSArray *_catalogs;
}

- (id)initWithMainKey:(NSString *)key;

@end
