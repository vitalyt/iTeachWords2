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

@class MyPickerViewContrller,LoadingViewController,ToolsViewController;
@interface NewWordsTable : EditTableViewController <MyPickerViewProtocol,UIAlertViewDelegate> {
    NSDictionary    *contentArray;
    MyPickerViewContrller   *wordTypePicker;
    NSThread        *workingThread;
    LoadingViewController   *loadingView;
    NSMutableArray         *sortedKeys;
    NSMutableArray  *selectedWords;
    ToolsViewController *toolsView;
    IBOutlet UIActivityIndicatorView *loadingViewAnimation;
}

@property (nonatomic,retain) NSDictionary   *contentArray;

- (NSString *) findTranslateOfWord:(NSString *)word;
- (void) showMyPickerView;
- (void) parseWordsToTheme:(WordTypes *)wordType;
- (void) showToolsView;
- (void) loadDataWithString:(NSString *)string;
-(void) selectAllWords;
-(void) deselectAllWords;
-(void) filteringList;

@end
