//
//  WorldTableViewController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/19/11.
//  Copyright 2011 OSDN. All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
//#import <CoreAudio/CoreAudioTypes.h>
#import "MyPlayer.h"

#import "EditTableViewController.h"
#import "MyPickerViewProtocol.h"
#import "ManagerViewProtocol.h"
#import "AlertTableView.h"

#import "RecordingWordViewController.h"
#import "TableCellController.h"
typedef enum {
	SHOW_ENG		,
	SHOW_ALL		,
	SHOW_RUS	
} ShowingWordType;

@class MyPickerViewContrller,WordTypes,ToolsViewController,MultiPlayer;
@class HeadViewController,AlertTableViewDelegate;

@interface WorldTableViewController : EditTableViewController <MyPickerViewProtocol,MyPlayerProtocol,AlertTableViewDelegate,AlertTableViewDelegate,RecordingViewProtocol,TableCellProtocol> {
    MyPickerViewContrller   *wordTypePicker;
    WordTypes               *wordType;
    ToolsViewController     *toolsView; 
    MultiPlayer             *multiPlayer;
    NSIndexPath             *currentSelectedWordPathIndex;
    bool                    isStatisticShowing;
    ShowingWordType         showingType;
    
    NSString                *nativeCountry,*translateCountry;
    HeadViewController      *tableHeadView;
    RecordingWordViewController *recordView;
    
    UIImage                 *playImg,*LoadRecordImg;
}

@property (nonatomic,retain) WordTypes *wordType;
@property (nonatomic) ShowingWordType   showingType;

- (void) playSoundWithIndex:(NSIndexPath *)indexPath;
- (void) showMyPickerView;
- (void) showToolsView;
- (void) showTableHeadView;

- (void)checkDelayedThemes;
- (void)showTableAlertViewWithElements:(NSArray *)elements;

- (void) showRecordViewWithIndexPath:(NSIndexPath*)indexPath;
- (void)btnActionClickWithCell:(id)_cell;
@end
