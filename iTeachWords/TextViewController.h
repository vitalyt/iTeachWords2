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

#ifdef FREE_VERSION
#import "MKStoreManager.h"
#endif

@class PagesScrollView;
@interface TextViewController : AddWordOptionsView <
UITextViewDelegate, 
UIAlertViewDelegate, 
RecordingViewProtocol,
ButtonViewProtocol,
MyVocalizerDelegate,

#ifdef FREE_VERSION
MKStoreKitDelegate
#endif

>{
    IBOutlet UITextView *myTextView;
    
    PagesScrollView *pagesScrollView;
    
    NSRange             range;
    
	NSArray				*array;
	NSDictionary		*arrayCount;
    NSString            *currentTextLanguage;
    UIView              *loadingView;
}

@property (nonatomic, retain) NSArray *array;
@property (nonatomic, retain) NSDictionary *arrayCount;

- (IBAction) showTable;
- (IBAction) showVoiceRecordView;
- (IBAction) showVocalizerView;
- (IBAction)selectAll:(id)sender;
- (IBAction)clearAll:(id)sender;
- (NSString *) loadText;
- (void) saveText;
- (void)setText:(NSString*)text;
- (NSString*)detectCurrentTextLanguage;
- (void)setCurrentTextLanguage:(NSString*)_textLanguage;
- (NSString*)currentTextLanguage;
- (void)showLoadingView;
- (void)hideLoadingView;

@end
