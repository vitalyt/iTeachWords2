//
//  TranslateViewController.h
//  TranslatingViewTestProject
//
//  Created by Vitalii Todorovych on 18.04.13.
//  Copyright (c) 2013 Vitalii Todorovych. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AddWordModel.h"
#import "RecordModel.h"
#import "BaseHelpViewController.h"

@class AddWord;
@class MyPickerViewContrller,MyUIViewClass,RecordingWordViewController,AddWordModel,WBEngine;
@interface TranslateViewController : BaseHelpViewController <UITextViewDelegate,RecordingViewProtocol, UIActionSheetDelegate>{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIView *engContainerView;
    IBOutlet UIView *rusContainerView;
    IBOutlet UIImageView *engFlagImageView;
    IBOutlet UIImageView *rusFlagImageView;
    IBOutlet UIButton *engRecordBtn;
    IBOutlet UIButton *rusRecordBtn;
    IBOutlet UIButton *engSearchBtn;
    IBOutlet UIButton *rusSearchBtn;
    IBOutlet UILabel *themeLbl;
    IBOutlet UIButton *saveButton;
    IBOutlet UIButton *themeButton;
    
    bool isDataChanged;
    BOOL isReplasmentViewsMode;
    float interfaceOffset;
    
    AddWord *translateViewController;
	MyPickerViewContrller	*myPicker;
    RecordingWordViewController *recordView;
}

@property (retain, nonatomic) IBOutlet UITextView *engTextView;
@property (retain, nonatomic) IBOutlet UITextView *rusTextView;

@property (nonatomic, assign)  id delegate;
@property (nonatomic) bool flgSave,editingWord;
@property (nonatomic, retain)  AddWordModel *dataModel;

- (IBAction)makeReplacementTextViews:(id)sender;
- (IBAction)searchClicked:(id)sender;
- (IBAction)recordClicked:(id)sender;


- (void)     loadData;
- (IBAction) showMyPickerView:(id)sender;
- (void)     back;
- (IBAction) save:(id)sender;
- (IBAction) recordPressed:(id)sender;
- (void)     clear;
- (void)setWord:(Words *)_word;
- (void)setText:(NSString*)text;
- (void)setTranslate:(NSString*)text;
- (void)addRecButtonOnTextField:(UITextField*)textField;
- (void)createMenu;
- (void)removeChanges;

- (void)updateFieldButtons;
- (void)changeFieldButton:(UIButton*)button toState:(int)state;

- (void)showSaveButton;
- (void)hiddeSaveButton;

@end
