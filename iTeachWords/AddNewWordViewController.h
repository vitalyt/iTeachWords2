//
//  AddNewWordViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/5/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "AddWordModel.h"
#import "RecordModel.h"
#import "BaseHelpViewController.h"

@class MyPickerViewContrller,MyUIViewClass,RecordingWordViewController,AddWordModel,WBEngine;

@interface AddNewWordViewController : BaseHelpViewController <UITextFieldDelegate, RecordingViewProtocol, UIActionSheetDelegate>{
    IBOutlet UITextField    *textFld;
    IBOutlet UITextField    *translateFid;
    IBOutlet UILabel *themeLbl;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *themeButton;
    IBOutlet UIButton       *recordButtonView;
	MyPickerViewContrller	*myPicker;
    RecordingWordViewController *recordView;
    
    AddWordModel            *dataModel;
    bool                    flgSave;
    bool                    isDataChanged;
    bool                    editingWord;
}

@property (nonatomic) bool flgSave,editingWord;
@property (nonatomic, retain)  AddWordModel            *dataModel;
@property (nonatomic, assign)  id            delegate;

- (void)     loadData;
- (IBAction) showMyPickerView:(id)sender;

- (void)     back;
- (IBAction) save:(id)sender;
- (IBAction) recordPressed:(id)sender;
- (void)clear;

- (void)	 setImageFlag;
- (void)     closeAllKeyboard;

- (void)setWord:(Words *)_word;
- (void)setText:(NSString*)text;
- (void)setTranslate:(NSString*)text;
- (void)addRecButtonOnTextField:(UITextField*)textField;
- (void)createMenu;
- (void)textFieldDidChange:(UITextField*)textField;
- (void)removeChanges;

- (void)updateFieldButtons;
- (void)changeFieldButton:(UIButton*)button toState:(int)state;

- (void)showSaveButton;
- (void)hiddeSaveButton;
@end
