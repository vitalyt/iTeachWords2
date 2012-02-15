//
//  SettingsViewController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 10/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputTableController.h"
#import "ARFontPickerViewController.h"

#ifdef FREE_VERSION
#import "MKStoreManager.h"
#endif

@class TextFieldLanguagesCell;
@interface SettingsViewController : InputTableController 
<ARFontPickerViewControllerDelegate
#ifdef FREE_VERSION
,MKStoreKitDelegate
#endif
>{
@private
    
    IBOutlet UIToolbar *barItem;
    bool isKeyboardShowing;
    UIView              *loadingView;
}

- (void)done;
- (void)showDatePickerView:(TextFieldCell *)cell;
- (void) setImageFlagInCell:(TextFieldLanguagesCell *)cell;
- (void)showFontPicker:(id)sender;
- (void)showToolbar;

- (void)showNotificationTableView;
- (void)showLoadingView;
- (void)hideLoadingView;
@end
