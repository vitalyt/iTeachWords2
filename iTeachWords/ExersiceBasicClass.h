//
//  ExersiceBasicClass.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/23/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#import "Words.h"
#import "MyPlayerProtocol.h"
#import "MultiPlayer.h"

@class StatisticViewController,MultiPlayer,WordTypes;

@interface ExersiceBasicClass : UIViewController <UITextFieldDelegate,MyPlayerProtocol,ADBannerViewDelegate> {
	IBOutlet UITextField *textBox;
	IBOutlet UILabel	*lblWordEng;
	IBOutlet UILabel	*lblWordRus;
	IBOutlet UIButton	*doneButton;
    
    NSMutableArray      *data;
    WordTypes           *wordType;
    StatisticViewController *statisticView;
    MultiPlayer             *multiPlayer;
    
    ADBannerView *adView;
    BOOL bannerIsVisible;
}

@property (nonatomic, retain) IBOutlet UITextField  *textBox;
@property (nonatomic, retain) IBOutlet UIButton   *doneButton;
@property (nonatomic, retain) IBOutlet UILabel    *lblWordEng,*lblWordRus;
@property (nonatomic, retain) WordTypes           *wordType;
@property (nonatomic, retain) NSMutableArray      *data;
@property (nonatomic,assign) BOOL bannerIsVisible;

- (void) createStatisticsView;
- (void) back;
- (void) nextWord;
- (void) showTestMessageResultat:(bool)rightFlg;
- (void) playSoundWithIndex:(int)index;
- (void) checkingWord:(Words *)word success:(BOOL)success;
- (NSArray *)getStatisticIndexesArrayWithWords:(NSArray*)wordsArray;
- (void)createBunnerView;
- (void)moveViewObjects;
- (void)registerRepeat;

-(void)performTransition;
@end
