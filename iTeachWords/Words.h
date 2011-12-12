//
//  Words.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/23/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Sounds, WordTypes;

@interface Words : NSManagedObject {
@private
}
@property (nonatomic, copy) NSString * translate;
@property (nonatomic, retain) NSNumber * wordID;
@property (nonatomic, retain) NSString * descriptionStr;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * changeBy;
@property (nonatomic, retain) NSDate * changeDate;
@property (nonatomic, copy) NSString * text;
@property (nonatomic, retain) NSNumber * isSelected;
@property (nonatomic, retain) NSNumber * typeID;
@property (nonatomic, retain) NSNumber * createBy;
@property (nonatomic, retain) NSSet* statistics;
@property (nonatomic, retain) WordTypes * type;
@property (nonatomic, retain) NSSet* sounds;

- (void)addStatisticsObject:(NSManagedObject *)value;
- (void)removeStatisticsObject:(NSManagedObject *)value;
- (void)addStatistics:(NSSet *)value;
- (void)removeStatistics:(NSSet *)value ;

- (void)addSoundsObject:(Sounds *)value ;
- (void)removeSoundsObject:(Sounds *)value;
- (void)addSounds:(NSSet *)value;
- (void)removeSounds:(NSSet *)value;

@end
