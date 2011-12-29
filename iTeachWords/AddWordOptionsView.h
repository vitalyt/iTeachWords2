//
//  AddWordWebViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/6/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "AddNewWordViewController.h"

@interface AddWordOptionsView : UIViewController <UIActionSheetDelegate>{
    AddNewWordViewController    *wordsView;
    BOOL    isWordsViewShowing;
}

- (NSString *)getSelectedText;
- (void)addWebView;
- (void)showAddWordView;
- (void)createMenu;
- (void)parceTranslateWord;
- (void)saveData;
- (void)back;
- (void) showParsedWordTable;
@end
