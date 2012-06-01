//
//  DetailStatisticViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/28/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Words;
@interface DetailStatisticViewController : UIViewController {
@private
    IBOutlet UIProgressView *progress;
    IBOutlet UILabel        *progressLabel;
    IBOutlet UILabel        *successLbl;
    IBOutlet UILabel        *totalLbl;
    IBOutlet UILabel *progressLbl;
    Words                   *word;
}

- (void) reloadStatisticView;
- (void) setWord:(Words *)_word;
- (void) generateStatisticByWords:(NSSet*)words;

@end
