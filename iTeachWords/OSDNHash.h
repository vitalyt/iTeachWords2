//
//  OSDNHash.h
//  hrmobile.efis
//
//  Created by Vitaly Todorovych on 7/6/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OSDNHash : NSObject {
    
}

+ (void)        addData:(NSData *)_data withURL:(NSString *)_url;
+ (NSData *)    loadDataWithURL:(NSString *)_url;
+ (BOOL)        validDate:(NSDate *)dateTest;
+ (BOOL)        validCurrentDate:(NSString *)dateTest toDate:(NSString*)currentDate;
+ (BOOL)        checkValidationUrl:(NSString *)_url toDate:(NSString *)_date;
+ (void)        removeAllHash;
+ (void)        removeHash;
+ (void)        registerItem:(NSString*)path;
+ (void)        registerItem:(NSString*)path withURL:(NSString*)url;
@end
