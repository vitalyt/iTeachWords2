//
//  StatisticLearning.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/6/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StatisticType, WordTypes;

@interface StatisticLearning : NSManagedObject

@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * changeBy;
@property (nonatomic, retain) NSDate * changeDate;
@property (nonatomic, retain) NSNumber * createBy;
@property (nonatomic, retain) NSNumber * statisticTypeID;
@property (nonatomic, retain) NSDate * lastLearningDate;
@property (nonatomic, retain) NSNumber * wordTypeID;
@property (nonatomic, retain) NSNumber * repeatType;
@property (nonatomic, retain) NSNumber * repeatStatus;
@property (nonatomic, retain) StatisticType *statisticType;
@property (nonatomic, retain) WordTypes *wordType;

@end
