//
//  MyMenu.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 11/4/10.
//  Copyright (c) 2010 OSDN. All rights reserved.
//

#import "TableViewController.h"

@interface MyMenu : TableViewController {
    NSArray                 *contentImageArray;
}

@property (nonatomic, retain) NSArray    *contentImageArray;

- (void)showLastItem;
- (void)addInfoButton;
- (void)showInfoView;
- (void)showWebView;

@end