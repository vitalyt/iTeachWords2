//
//  ThemeDetailView.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 28.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WordTypes,DetailStatisticViewController;
@interface ThemeDetailView : UIViewController{
    
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *createDateLdl;
    IBOutlet UILabel *changeDateLbl;
    IBOutlet UILabel *wordsCountLbl;
    
    DetailStatisticViewController    *statisticViewController;
}

- (void)setTheme:(WordTypes*)_wordTheme;
- (void)generateStatisticView;

@end
