//
//  StatisticViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/2/10.
//  Copyright (c) 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StatisticViewController : UIViewController {
    IBOutlet UIProgressView *progressTotal;
    IBOutlet UIProgressView *progress;
    IBOutlet UILabel        *progressTotalLabel;
    IBOutlet UILabel        *progressLabel;
    
    int                     total;
    int                     index;
    int                     right;
    int                     totalQuestions;
}

@property (nonatomic) int total;
@property (nonatomic) int index;
@property (nonatomic) int right;
@property (nonatomic) int totalQuestions;

- (void) checking:(BOOL)_valid;
- (void) reloadStatisticView;

@end
