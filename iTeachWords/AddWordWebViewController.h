//
//  AddWordWebViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/6/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "WebViewController.h"
#import "AddNewWordViewController.h"

@interface AddWordWebViewController : WebViewController<UIActionSheetDelegate>{
    AddNewWordViewController    *wordsView;
    BOOL    isWordsViewShowing;
}

- (void)addWebView;
- (void)showAddWordView;
- (void)createMenu;
- (void)parceTranslateWord;
- (void)saveData;
- (void)back;
@end
