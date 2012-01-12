//
//  NewWordsTable.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/2/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditTableViewController.h"
#import "MyPickerViewProtocol.h"
#import "StringTools.h"

@class MyPickerViewContrller,LoadingViewController,ToolsViewController;
@interface NewWordsTable : EditTableViewController <MyPickerViewProtocol,UIAlertViewDelegate,StringToolsViewDelegate> {
    NSDictionary    *contentArray;
    MyPickerViewContrller   *wordTypePicker;
    NSThread        *workingThread;
    LoadingViewController   *loadingView;
    NSMutableArray         *sortedKeys;
    NSMutableArray  *selectedWords;
    ToolsViewController *toolsView;
    IBOutlet UIActivityIndicatorView *loadingViewAnimation;
    
    WordTypes   *wordType;
    StringTools *stringTools;
}

@property (nonatomic,retain) NSDictionary   *contentArray;

- (NSString *) findTranslateOfWord:(NSString *)word;
- (void) showMyPickerView;
- (void) translateWords;
- (void) showToolsView;
- (void) loadDataWithString:(NSString *)string;
-(void) selectAllWords;
-(void) deselectAllWords;
-(void) filteringList;

- (void)loadLocalTranslateWords:(NSArray*)wordsArray;
- (void)loadTranslateWords:(NSArray*)wordsArray;
- (void)addWords:(NSArray*)words withTranslate:(NSArray*)translates toWordType:(WordTypes*)_wordType;

@end
