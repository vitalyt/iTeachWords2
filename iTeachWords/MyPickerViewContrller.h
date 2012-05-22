//
//  MyPickerViewContrller.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/30/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"
#import "BaseHelpViewController.h"

@protocol UIPickerViewDataSource, UIPickerViewDelegate,MyPickerViewProtocol;

@class AddWord,WordTypes,ThemeDetailView;
@interface MyPickerViewContrller : BaseHelpViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate,UIScrollViewDelegate> {
	IBOutlet UIPickerView	*pickerView;
    IBOutlet UITextField    *themeEditingFlt;
	IBOutlet UIBarButtonItem    *rightButton;
	IBOutlet UIBarButtonItem    *leftButton;
    IBOutlet UIButton		*addButton;
	NSArray                 *data;
	id <MyPickerViewProtocol>   delegate;
    
    ThemeDetailView         *themeDetailView;
    NSMutableArray          *rows;
    BOOL                    isAdding;
}

@property (nonatomic, retain) IBOutlet UIPickerView	*pickerView;
@property (nonatomic, assign) id                    delegate;
@property (nonatomic, retain) NSArray               *data;

- (WordTypes *) getType;
+ (NSArray*)loadAllThemeWithPredicate:(NSPredicate*)_predicate;
+ (NSArray*)loadAllTheme;
- (void) loadData;
- (void) initArray;
- (void) openViewWithAnimation:(UIView *) superView;
- (IBAction)cansel;
- (IBAction)done;
- (IBAction)remove:(id)sender;
- (IBAction)showAddView:(id)sender;
- (IBAction)editThemeName:(id)sender;
- (IBAction)showThemesTableView:(id)sender;
- (void)closeView;
- (IBAction) deleteType;
- (NSString *) getTextPicker;
- (void)showThemeDetail:(WordTypes*)_wordType;
- (void)closeEditingField;
- (void)saveEditingField;
- (bool)isThemeAvailability:(NSString*)themeName;

- (CATransition*)cretePushAnimation;
- (CATransition*)cretePopAnimation;

@end
