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
#import <iAd/iAd.h>
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

@interface WorldTableViewController : EditTableViewController <ADBannerViewDelegate,MyPickerViewProtocol,MyPlayerProtocol,AlertTableViewDelegate,AlertTableViewDelegate,RecordingViewProtocol,TableCellProtocol> {
    ToolsViewController     *toolsView;
    bool                    isStatisticShowing;
    
    NSString                *nativeCountry,*translateCountry;
    HeadViewController      *tableHeadView;
    RecordingWordViewController *recordView;

    int                     selectedWordsCount;
}

@property (nonatomic,strong) MyPickerViewContrller *wordTypePicker;
@property (nonatomic,strong) NSIndexPath *currentSelectedWordPathIndex;
@property (nonatomic,strong) MultiPlayer *multiPlayer;
@property (nonatomic,strong) UIImage *playImg,*LoadRecordImg;
@property (nonatomic,strong) WordTypes *wordType;
@property (nonatomic) ShowingWordType   showingType;

- (void)playSoundWithIndex:(NSIndexPath *)indexPath;
- (void)showMyPickerView:(id)sender;
- (void)showToolsView;
- (void)showTableHeadView;
- (void)showEditingViewForWord:(Words*)_word;

- (void)checkDelayedThemes;
- (void)showTableAlertViewWithElements:(NSArray *)elements;

- (void) showRecordViewWithIndexPath:(NSIndexPath*)indexPath;
- (void)btnActionClickWithCell:(id)_cell;
- (void)scrollTableToIndexPath:(NSIndexPath*)indexPath;
- (void)updateSelectedLabel;
@end
