//
//  AddWordWebViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/6/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "AddNewWordViewController.h"
#import "ExpandingBarViewController.h"

@interface AddWordOptionsView : ExpandingBarViewController <UIActionSheetDelegate>{
    AddNewWordViewController    *wordsView;
    BOOL    isWordsViewShowing;
}

- (NSString *)getSelectedText;
- (void)addWebView;
- (void)showAddWordView:(id)sender;
- (void)createMenu;

- (void)translateText:(id)sender;
- (void)parseText:(id)sender;
- (void)playText:(id)sender;
- (void)parceTranslateWord;

- (IBAction) showVocalizerView;

- (void)saveData;
- (void)back;
- (void) showParsedWordTable;
@end
