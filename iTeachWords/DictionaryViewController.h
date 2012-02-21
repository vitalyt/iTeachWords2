//
//  DictionaryViewController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/2/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewController.h"

@interface DictionaryViewController : SearchTableViewController <UIScrollViewDelegate> {
    NSMutableArray *searchedData;
    NSString *searchedText;
    
    NSThread *searchingThread;
    IBOutlet UISearchBar *searchBar;
}
@property (nonatomic,retain) NSMutableArray *searchedData;
@property (nonatomic,retain) NSString *searchedText;

- (void)inputModeDidChange:(NSNotification*)notification;
- (void) loadLocalData;
- (void)inputModeDidChange:(NSNotification*)notification;
- (NSString *)currentTextLanguage;
- (bool)isNativeKeyboardLanguage;
@end
