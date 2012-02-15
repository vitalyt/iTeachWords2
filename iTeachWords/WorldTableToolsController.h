//
//  WorldTableToolsController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/20/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorldTableViewController.h"
#import "ToolsViewProtocol.h"
#import "EditingViewProtocol.h"

#ifdef FREE_VERSION
#import "MKStoreManager.h"
#endif

@class WordTypes;

@interface WorldTableToolsController : WorldTableViewController <ToolsViewProtocol,UIAlertViewDelegate
#ifdef FREE_VERSION
,MKStoreKitDelegate
#endif

> {
    UIView              *loadingView;
}

- (void) mixArray;
- (void) deleteSelectedWords;
- (void) showPlayerView;
- (void) reassignSelectedWordsToTheme:(WordTypes *)wordType;
- (void)generateThemeStatistic;

- (void)showLoadingView;
- (void)hideLoadingView;
@end
