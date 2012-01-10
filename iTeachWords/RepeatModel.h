//
//  RepeatModel.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/6/12.
//  Copyright 2012 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WordTypes,StatisticLearning;
@interface RepeatModel : NSObject {
@private
    NSArray     *statisticsLearningArray;
//    NSDate      *lastThemeLearningDate;
    WordTypes   *wordType;
}

- (id)initWithWordType:(WordTypes*)_wordType;
- (void)setWordType:(WordTypes*)_wordType;

- (void)registerRepeat;
- (StatisticLearning *) createStatisticLearningWithRepeatStatus:(int)_repeatStatus;
- (void)setNewRepeatStatusToStatisticLearning:(StatisticLearning*)statisticLearning;
- (void)saveChanges;
- (int)getRepeatStatusByIntervalSeconds:(int)intervalSeconds;

- (NSArray*)getDelayedTheme;
- (NSDate *)getLastThemeLearningDateWithStatisticsArray:(NSArray*)_statisticsLearningArray;
- (int)getTimeIntervalToNexLearning:(NSArray *)_statisticsLearningArray;

- (NSArray*)loadAllThemes;
- (NSArray*)loadAllStatisticsLearningWithWordType:(WordTypes*)_wordType;

@end