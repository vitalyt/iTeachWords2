//
//  MyPickerViewProtocol.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 10/7/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WordTypes;
@protocol MyPickerViewProtocol
@optional
- (void) setTextFromPicker:(NSString *)_str;
- (void) pickerDidChooseType:(WordTypes *)wordType;
- (void) pickerDone:(WordTypes *)wordType;
- (void) pickerWillCansel;
@end
