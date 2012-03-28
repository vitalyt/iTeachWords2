//
//  ThemesTableView.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 27.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "TableViewController.h"
#import "MyPickerViewProtocol.h"

@interface ThemesTableView : TableViewController{
    BOOL    isEditingMode;
    NSMutableArray *content;
    
	id <MyPickerViewProtocol>   delegate;
}

@property (nonatomic, assign) id  delegate;

- (IBAction)back:(id)sender;
- (IBAction)edit:(id)sender;
- (void)showThemeEditingView;
- (void)createNavigationButtons;

@end
