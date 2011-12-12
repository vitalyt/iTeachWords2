//
//  Statistic.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 7/28/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Words;

@interface Statistic : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * wordID;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * changeBy;
@property (nonatomic, retain) NSDate * changeDate;
@property (nonatomic, retain) NSNumber * successfulCount;
@property (nonatomic, retain) NSNumber * statisticID;
@property (nonatomic, retain) NSNumber * statisticTypeID;
@property (nonatomic, retain) NSNumber * requestCount;
@property (nonatomic, retain) NSNumber * createBy;
@property (nonatomic, retain) Words * word;
@property (nonatomic, retain) NSManagedObject * type;

@end
