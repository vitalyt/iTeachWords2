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

- (NSMutableArray *) mixingArray:(NSArray *)_array count:(NSInteger)_count;
- (NSInteger)randomFrom:(NSInteger)from to:(NSInteger)to;
- (void)determineRowCounts;
- (NSArray*)getRandomWordsWithCount:(NSInteger)_count;

@end