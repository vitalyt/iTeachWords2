//
//  StatisticType.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 7/28/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Statistic;

@interface StatisticType : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * descriptionStr;
@property (nonatomic, retain) NSNumber * statisticTypeID;
@property (nonatomic, retain) NSSet* statistics;

@end
