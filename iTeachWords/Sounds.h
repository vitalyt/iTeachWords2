//
//  Sounds.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/23/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Words;

@interface Sounds : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * wordID;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSNumber * createBy;
@property (nonatomic, retain) NSNumber * changeBy;
@property (nonatomic, retain) NSString * extention;
@property (nonatomic, retain) NSData * data;
@property (nonatomic, retain) NSDate * changeDate;
@property (nonatomic, retain) NSString * descriptionStr;
@property (nonatomic, retain) NSDate * createDate;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) Words * word;

@end
