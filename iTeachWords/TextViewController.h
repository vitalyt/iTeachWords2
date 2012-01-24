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

@interface TextViewController : AddWordOptionsView <UITextViewDelegate, UIAlertViewDelegate, RecordingViewProtocol>{
    IBOutlet UITextView *myTextView;
    
    NSRange             range;
    
	NSArray				*array;
	NSDictionary		*arrayCount;
    NSString            *currentTextLanguage;
}

@property (nonatomic, retain) NSArray *array;
@property (nonatomic, retain) NSDictionary *arrayCount;

- (IBAction) showTable;
- (IBAction) showVoiceRecordView;
- (IBAction)selectAll:(id)sender;
- (IBAction)clearAll:(id)sender;
- (NSString *) loadText;
- (void) saveText;
- (void)setText:(NSString*)text;
- (NSString*)detectCurrentTextLanguage;
- (void)setCurrentTextLanguage:(NSString*)_textLanguage;

@end
