//
//  TableCellController.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/22/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectTableViewCell.h"

@protocol TableCellProtocol <NSObject>

- (void)btnActionClickWithCell:(id)sender;

@end
@class DetailStatisticViewController;
@interface TableCellController : MultiSelectTableViewCell {
	IBOutlet UILabel *lblEng;
	IBOutlet UILabel *lblRus;
	IBOutlet UILabel *lblEngH;
	IBOutlet UILabel *lblRusH;
	IBOutlet UIButton *btn;
    DetailStatisticViewController    *statisticViewController;
    id delegate;
}

@property (nonatomic, retain) IBOutlet UILabel *lblEng,*lblRus,*lblEngH,*lblRusH;
@property (nonatomic, retain) IBOutlet UIButton *btn;
@property (nonatomic, retain) DetailStatisticViewController *statisticViewController;
@property (nonatomic, assign) id delegate;

- (IBAction)btnActionClick:(id)sender;
- (void) generateStatisticView;
- (void) removeStatisticView;

@end
