//
//  ThemeDetailView.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 28.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@class WordTypes,DetailStatisticViewController;
@interface ThemeDetailView : UIViewController{
    
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *createDateLdl;
    IBOutlet UILabel *changeDateLbl;
    IBOutlet UILabel *wordsCountLbl;
     NSString *name;
     NSString *createDate;
     NSString *changeDate;
     NSString *wordsCount;
    
    DetailStatisticViewController    *statisticViewController;
}

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *createDate;
@property (nonatomic,copy) NSString *changeDate;
@property (nonatomic,copy) NSString *wordsCount;

- (void)setTheme:(WordTypes*)_wordTheme;
- (void)generateStatisticView;
- (void)fillData;
- (void)setUpRightAlignedRateViewWith:(WordTypes*)_wordTheme;

@end
