//
//  MyMenu.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 11/4/10.
//  Copyright (c) 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"

@interface MyMenu : TableViewController {
    NSArray                 *contentImageArray;
    
}

@property (nonatomic, retain) NSArray    *contentImageArray;

- (void)showTeachView;
- (void)showAddingWordView;
- (void)showTextParserView;
- (void)showDictionaryView;
- (void)showSettingsView;
- (void)showLastItem;
- (void)addInfoButton;
- (void)showInfoView;
- (void)showWebView;
- (void)showVocalizerView;
- (void)showRecognizerView;

@end