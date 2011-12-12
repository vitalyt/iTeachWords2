//
//  TableCellController.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/22/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectTableViewCell.h"

@class DetailStatisticViewController;
@interface TableCellController : MultiSelectTableViewCell {
	IBOutlet UILabel *lblEng;
	IBOutlet UILabel *lblRus;
	IBOutlet UILabel *lblEngH;
	IBOutlet UILabel *lblRusH;
	IBOutlet UIButton *btn;
    DetailStatisticViewController    *statisticViewController;
}

@property (nonatomic, retain) IBOutlet UILabel *lblEng,*lblRus,*lblEngH,*lblRusH;
@property (nonatomic, retain) IBOutlet UIButton *btn;
@property (nonatomic, retain) DetailStatisticViewController *statisticViewController;

- (void) generateStatisticView;
- (void) removeStatisticView;

@end
