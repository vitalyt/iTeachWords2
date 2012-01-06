//
//  StatisticType.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/6/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Statistic;

@interface StatisticType : NSManagedObject

@property (nonatomic, retain) NSNumber * statisticTypeID;
@property (nonatomic, retain) NSString * descriptionStr;
@property (nonatomic, retain) NSSet *statistics;
@property (nonatomic, retain) NSSet *statisticsLearning;
@end

@interface StatisticType (CoreDataGeneratedAccessors)

- (void)addStatisticsObject:(Statistic *)value;
- (void)removeStatisticsObject:(Statistic *)value;
- (void)addStatistics:(NSSet *)values;
- (void)removeStatistics:(NSSet *)values;
- (void)addStatisticsLearningObject:(NSManagedObject *)value;
- (void)removeStatisticsLearningObject:(NSManagedObject *)value;
- (void)addStatisticsLearning:(NSSet *)values;
- (void)removeStatisticsLearning:(NSSet *)values;
@end
