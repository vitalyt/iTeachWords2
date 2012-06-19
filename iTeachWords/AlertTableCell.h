//
//  AlertTableCell.h
//  iTeachWords
//
//  Created by admin on 31.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@class WordTypes;
@interface AlertTableCell : UITableViewCell{
    
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *subTitleLbl;
    DYRateView *rateView ;
}

@property (nonatomic,retain)IBOutlet UILabel *titleLbl;

- (void)setTheme:(WordTypes*)_wordTheme;
- (void)setUpRightAlignedRateViewWith:(WordTypes*)_wordTheme ;

@end
