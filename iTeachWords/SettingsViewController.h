//
//  SettingsViewController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 10/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "InputTableController.h"
#import "ARFontPickerViewController.h"

@class TextFieldLanguagesCell;
@interface SettingsViewController : InputTableController 
<ARFontPickerViewControllerDelegate>{
@private
    
    IBOutlet UIToolbar *barItem;
    bool isKeyboardShowing;
}

- (void)done;
- (void)showDatePickerView:(TextFieldCell *)cell;
- (void)setImageFlagInCell:(TextFieldLanguagesCell *)cell;
- (void)showFontPicker:(id)sender;
- (void)showToolbar;

- (void)showNotificationTableView;

#ifdef FREE_VERSION
- (void)showPurchaseInfoView;
#endif
    
@end
