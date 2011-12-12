//
//  WorldTableViewController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/19/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

#import "EditTableViewController.h"
#import "MyPickerViewProtocol.h"
#import "ManagerViewProtocol.h"

typedef enum {
	SHOW_ENG		,
	SHOW_ALL		,
	SHOW_RUS	
} ShowingWordType;

@class MyPickerViewContrller,WordTypes,ToolsViewController,MultiPlayer;
@class HeadViewController;

@interface WorldTableViewController : EditTableViewController <MyPickerViewProtocol,MyPlayerProtocol,ManagerViewProtocol> {
    MyPickerViewContrller   *wordTypePicker;
    WordTypes               *wordType;
    ToolsViewController     *toolsView; 
    MultiPlayer             *multiPlayer;
    int                     currentWordPlayingIndex;
    bool                    isStatisticShowing;
    ShowingWordType         showingType;
    
    NSString                *nativeCountry,*translateCountry;
    HeadViewController      *tableHeadView;
}

@property (nonatomic,retain) WordTypes *wordType;
@property (nonatomic) ShowingWordType   showingType;

- (void) playSoundWithIndex:(NSIndexPath *)indexPath;
- (void) showMyPickerView;
- (void) showToolsView;
- (void) showTableHeadView;

@end
