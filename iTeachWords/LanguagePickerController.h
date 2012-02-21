//
//  LanguagePickerController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 3/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LanguageFlagImageView;
@interface LanguagePickerController : UIViewController  <UIPickerViewDataSource, UIPickerViewDelegate, UISearchBarDelegate> {
    IBOutlet UIPickerView	*pickerView;
    IBOutlet UISearchBar    *searchBarLeft;
    IBOutlet UISearchBar    *searchBarRight;
    NSMutableArray          *content;
    
    bool                    isSearching;
}

@property (nonatomic,retain) NSMutableArray *content;

- (void)createFlagsView;
- (void)loadData;
- (void)setFlagIconsCountry:(NSString*)code inComponent:(int)component;
- (void)done;
- (void)closeSearchBar;

@end
