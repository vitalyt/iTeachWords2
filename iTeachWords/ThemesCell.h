//
//  ThemesCell.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 27.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailStatisticViewController.h"

@interface ThemesCell : UITableViewCell{
    IBOutlet UILabel *nameLbl;
    IBOutlet UILabel *subtitleLbl;
    DetailStatisticViewController    *statisticViewController;
}

@property (nonatomic, retain) DetailStatisticViewController *statisticViewController;
@property (nonatomic, retain) IBOutlet UILabel *nameLbl;
@property (nonatomic, retain) IBOutlet UILabel *subtitleLbl;


- (void) generateStatisticView;
- (void) removeStatisticView;

@end
