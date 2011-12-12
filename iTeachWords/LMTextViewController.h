//
//  LMTextViewController.h
//  MenuItemTesting
//
//  Created by Vitaly Todorovych on 3/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LMAbstractController.h"

@class LMTableViewController;

@interface LMTextViewController : LMAbstractController <UITextViewDelegate, UIAlertViewDelegate> {
    IBOutlet UITextView *myTextView;
    NSRange             range;
    
    bool                flgTableShowing;
    LMTableViewController   *myTableView;
    
    NSString        *textContent;
    NSString        *lessonName;
    NSMutableArray  *sentences;
    NSMutableArray  *wordsInSentence;
    int             sentenceIndex;
}

@property (nonatomic,retain) NSString *lessonName; 
@property (nonatomic,retain, setter = setTextContent:) NSString        *textContent; 

- (void) createMenu;
- (void) firstAction;
- (void) secondAction;

- (IBAction)saveLesson;
- (void) addingNameForLesson;
- (void) createModelFile;

- (IBAction)nextSentence:(id)sender;
- (IBAction)prevSentence:(id)sender;
@end
