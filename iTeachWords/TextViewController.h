//
//  TextViewController.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/25/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "LMTextViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TextViewController : LMTextViewController <UITextViewDelegate, UIAlertViewDelegate>{
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
