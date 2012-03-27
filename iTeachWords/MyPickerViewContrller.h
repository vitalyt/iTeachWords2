//
//  MyPickerViewContrller.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/30/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuartzCore/QuartzCore.h"

@protocol UIPickerViewDataSource, UIPickerViewDelegate,MyPickerViewProtocol;

@class AddWord,WordTypes;
@interface MyPickerViewContrller : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	IBOutlet UIPickerView	*pickerView;
	IBOutlet UITextField	*myTextField;
	IBOutlet UIBarButtonItem    *rightButton;
	IBOutlet UIBarButtonItem    *leftButton;
    IBOutlet UIButton		*addButton;
	NSArray                 *data;
	id <MyPickerViewProtocol>   delegate;
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
- (IBAction) cansel;
- (IBAction) done;
- (IBAction) remove;
- (IBAction) showAddView;
- (IBAction) closeAddView;
- (IBAction)showThemesTableView:(id)sender;
- (void)closeView;
- (void)	 saveNewTheme;
- (IBAction) deleteType;
- (NSString *) getTextPicker;
@end
