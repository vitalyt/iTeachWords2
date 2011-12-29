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

@interface TextViewController : AddWordOptionsView <UITextViewDelegate, UIAlertViewDelegate>{
    IBOutlet UITextView *myTextView;
    
    NSRange             range;
    
	NSArray				*array;
	NSDictionary		*arrayCount;
}

@property (nonatomic, retain) NSArray *array;
@property (nonatomic, retain) NSDictionary *arrayCount;

- (IBAction) showTable;
- (NSString *) loadText;
- (void) saveText;
- (void) createMenu;
- (void) translateText;
- (void)setText:(NSString*)text;

@end
