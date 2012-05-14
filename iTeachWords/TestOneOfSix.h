//
//  TestOneOfSix.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/2/10.
//  Copyright (c) 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExersiceBasicClass.h"

@class StatisticViewController;

@interface TestOneOfSix : ExersiceBasicClass {
    IBOutlet UITableView *table;
    NSInteger rowCount;
    
    NSMutableArray      *contentArray;
    BOOL                flgChange;
}

@property (nonatomic,retain)IBOutlet UITableView             *table;
@property (nonatomic,retain) NSMutableArray                 *contentArray;

- (NSMutableArray *) mixingArray:(NSArray *)_array count:(int)_count;
- (int)randomFrom:(int)from to:(int)to;
- (void)determineRowCounts;

@end