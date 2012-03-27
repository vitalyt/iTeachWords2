//
//  ThemesTableView.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 27.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "TableViewController.h"

@interface ThemesTableView : TableViewController{
    BOOL    isEditingMode;
}

- (IBAction)back:(id)sender;
- (IBAction)edit:(id)sender;

@end
