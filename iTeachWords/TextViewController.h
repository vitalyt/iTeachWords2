//
//  TextViewController.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/25/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AddWordOptionsView.h"
#import "MyRecognizerViewController.h"
#import "MyVocalizerViewController.h"
#import "ButtonView.h"

#import "SVSegmentedControl.h"

@class PagesScrollView;
@interface TextViewController : AddWordOptionsView <
UITextViewDelegate, 
UIAlertViewDelegate, 
RecordingViewProtocol,
ButtonViewProtocol,
MyVocalizerDelegate
>{
    IBOutlet UITextView *myTextView;
    SVSegmentedControl *navSC;
    PagesScrollView *pagesScrollView;
    
    NSRange             range;
    
	NSArray				*array;
	NSDictionary		*arrayCount;
    NSString            *currentTextLanguage;
    UIView              *loadingView;
}

@property (nonatomic, retain) NSArray *array;
@property (nonatomic, retain) NSDictionary *arrayCount;

- (IBAction)showTable;
- (IBAction)showVoiceRecordView;
- (IBAction)showVocalizerView;
- (IBAction)selectAll:(id)sender;
- (IBAction)clearAll:(id)sender;
- (NSString *) loadText;
- (void) saveText;
- (void)setText:(NSString*)text;
- (NSString*)detectCurrentTextLanguage;
- (void)setCurrentTextLanguage:(NSString*)_textLanguage;
- (NSString*)currentTextLanguage;
- (void)showLanguageSegment;


#ifdef FREE_VERSION
- (void)showPurchaseInfoView;
#endif

@end
