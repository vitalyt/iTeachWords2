//
//  HeadViewController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 10/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailStatisticViewController;
@interface HeadViewController : UIViewController {
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *subTitleLabel;
    DetailStatisticViewController    *statisticViewController;
}

@property (nonatomic,retain) IBOutlet UILabel *titleLabel;
@property (nonatomic,retain) IBOutlet UILabel *subTitleLabel;
@property (nonatomic,retain) DetailStatisticViewController    *statisticViewController;

- (void)generateStatisticViewWithWords:(NSSet*)words;
- (void)removeStatisticView;
@end
