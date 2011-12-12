//
//  WordTypes.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/12/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Words;

@interface WordTypes : NSManagedObject

@property (nonatomic, retain) NSNumber * typeID;
@property (nonatomic, retain) NSNumber * sorted;
@property (nonatomic, retain) NSNumber * createBy;
@property (nonatomic, retain) NSNumber * changeBy;
@property (nonatomic, retain) NSNumber * delete;
@property (nonatomic, retain) NSDate * changeDate;
@property (nonatomic, retain) NSString * descriptionStr;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * nativeCountryCode;
@property (nonatomic, retain) NSString * translateCountryCode;
@property (nonatomic, retain) NSSet *words;
@end

@interface WordTypes (CoreDataGeneratedAccessors)

- (void)addWordsObject:(NSManagedObject *)value;
- (void)removeWordsObject:(NSManagedObject *)value;
- (void)addWords:(NSSet *)values;
- (void)removeWords:(NSSet *)values;
@end
