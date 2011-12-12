//
//  TestControllerProtocol.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/21/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatisticViewController.h"
#import "DetailStatisticModel.h"

@class MyPlayer,StatisticViewController,DetailStatisticModel;
@interface TestControllerProtocol : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *textBox;
	IBOutlet UILabel	*lblWordEng;
	IBOutlet UILabel	*lblWordRus;
    StatisticViewController *statisticView;
	NSMutableArray		*words;
	NSDictionary		*word;
	int					index;
    
	IBOutlet UIProgressView	*progress,*progressTotal;

	NSString			*lessonName;
	int					exerciseIndex;
	MyPlayer			*myPlayer;
}

@property (nonatomic, retain) NSMutableArray *words;
@property (nonatomic, retain) NSString *lessonName;
@property (nonatomic, retain) IBOutlet UITextField *textBox;
@property (nonatomic, retain) IBOutlet UILabel	*lblWordEng,*lblWordRus;
@property (nonatomic, retain) IBOutlet UIProgressView	*progress,*progressTotal;
@property (nonatomic) int	exerciseIndex;
@property (nonatomic, retain) StatisticViewController *statisticView;

- (IBAction)	back;
- (IBAction)	help;
- (void)		saveProgress;
- (IBAction)	nextWord;
- (void)		createWord;
- (BOOL)		test;
//- (void)		playWord:(NSString *)_name;
- (void)		soundDidPlaying;
- (void)		closePlayer;

@end
