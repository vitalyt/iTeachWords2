 //
//  OSDNHash.m
//  hrmobile.efis
//
//  Created by Vitaly Todorovych on 7/6/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "OSDNHash.h"
#import "OsdnUtilHash.h"

@implementation OSDNHash

#define pathOfHashDB [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HashDB"]

+ (void) addData:(NSData *)_data withURL:(NSString *)_url{
    
    
	if (!_url) {
        return;
    }
	//int number = [[[NSUserDefaults standardUserDefaults] stringForKey:@"days_key"] intValue];
	
	//if (number>0) {
		NSDate *today = [NSDate date];
		NSString *fhash = [OsdnUtilHash md5:[NSString stringWithFormat:@"%@",_url]];
		
		NSString *path = NSHomeDirectory();
		path = [path stringByAppendingPathComponent:@"Documents"];
		path = [path stringByAppendingPathComponent:[NSString stringWithString:fhash]];
//        NSFileManager *fileManager = [NSFileManager defaultManager];
//        if ([fileManager fileExistsAtPath:path] == YES){
//            return;
//        }
        NSMutableDictionary *myDict = [[NSMutableDictionary alloc] init];
		[myDict setObject:[NSString stringWithFormat:@"%@",_url]  forKey:@"url"];
		[myDict setObject:(NSDate *)today  forKey:@"date"];
		[myDict setObject:(NSData *)_data  forKey:@"data"];
		[myDict writeToFile:path atomically:YES];
        [myDict release];

        [OSDNHash registerItem:fhash withURL:_url];
	//}
}

+ (BOOL) validDate:(NSDate *)dateTest{ 
	NSDate *currentDate = [NSDate date]; 
	int number = [[[NSUserDefaults standardUserDefaults] stringForKey:@"days_key"] intValue] * 60;
    if ([dateTest isKindOfClass:[NSString class]]) {
        dateTest = [(NSString*)dateTest dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
	int intervall = (int) [currentDate timeIntervalSinceDate: dateTest] / 1440;
	if (intervall > number) {
		return NO;
	}
	return YES;
}

+ (BOOL) validCurrentDate:(NSString *)_currentDateStr toDate:(NSString*)_dateTestStr{ 
    NSDate *currentDate = [[_currentDateStr dateWithFormat:@"yyyy-MM-dd HH:mm:ss"] retain];
    NSDate *dateTest = [[_dateTestStr dateWithFormat:@"yyyy-MM-dd HH:mm:ss"] retain];
	int intervall = (int) [currentDate timeIntervalSinceDate:dateTest];
    bool returnValue = NO;
	if (intervall > 0) {
		returnValue = YES;
	}
    [currentDate release];
    [dateTest release];
	return returnValue;
}

+ (BOOL) checkValidationUrl:(NSString *)_url toDate:(NSString *)_date{ 
    NSString *fhash = [OsdnUtilHash md5:[NSString stringWithFormat:@"%@",_url]];

    NSMutableDictionary *hashDB;    
    hashDB = [NSMutableDictionary dictionaryWithContentsOfFile:pathOfHashDB];
	if (hashDB && [hashDB objectForKey:fhash]) {
        NSLog(@"%@",[hashDB objectForKey:fhash]);
        
        return [self validCurrentDate:[[hashDB objectForKey:fhash] objectForKey:@"createDate"] toDate:_date];
    }
	return NO;
}

+ (void) removeAllHash{	
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSMutableDictionary *hashDB;
    if (![fileMgr fileExistsAtPath:pathOfHashDB]) {
        return;
    }
    hashDB = [NSMutableDictionary dictionaryWithContentsOfFile:pathOfHashDB];
    if (hashDB) {
        NSArray *keys = [hashDB allKeys];
        for (int i=0;i<[keys count];i++){
            NSString *key = [keys objectAtIndex:i];
            NSString *pathOfFile = NSHomeDirectory();
            pathOfFile = [pathOfFile stringByAppendingPathComponent:@"Documents"];
            pathOfFile = [pathOfFile stringByAppendingPathComponent:key];
            NSError *error = nil;
            [fileMgr removeItemAtPath:pathOfFile error:&error];
        }
    }           
    NSError *error = nil;
    [fileMgr removeItemAtPath:pathOfHashDB error:&error];
}

+ (void) removeHash{	
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:pathOfHashDB]) {
        return;
    }
    NSMutableDictionary *hashDB;
    NSMutableArray *removedFiles = [[NSMutableArray alloc] init];
    hashDB = [NSMutableDictionary dictionaryWithContentsOfFile:pathOfHashDB];
    if (hashDB) {
        NSArray *keys = [hashDB allKeys];
        for (int i=0;i<[keys count];i++){
            NSString *key = [keys objectAtIndex:i];
            NSLog(@"%@",hashDB);
            NSLog(@"%@",[hashDB objectForKey:key]);
            if (![self validDate:[[hashDB objectForKey:key] objectForKey:@"createDate"]]) {
                NSString *pathOfFile = NSHomeDirectory();
                pathOfFile = [pathOfFile stringByAppendingPathComponent:@"Documents"];
                pathOfFile = [pathOfFile stringByAppendingPathComponent:key];
                NSError *error = nil;
                [fileMgr removeItemAtPath:pathOfFile error:&error];
                if (!error) {
                    [removedFiles addObject:key];
                }
            }
        }
    }
    [hashDB removeObjectsForKeys:removedFiles];
    [removedFiles release];
    [hashDB writeToFile:pathOfHashDB atomically:YES];
}

+ (NSData *)loadDataWithURL:(NSString *)_url{
	NSData *data = nil;
	int number = [[[NSUserDefaults standardUserDefaults] stringForKey:@"days_key"] intValue];
	if (number == 0) {
		return data;
	}
	NSString *fhash = [OsdnUtilHash md5:[NSString stringWithFormat:@"%@",_url]];
	NSLog(@"%@",fhash);
	NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:[NSString stringWithString:fhash]];
    
    NSMutableDictionary *hashDB;
    hashDB = [NSMutableDictionary dictionaryWithContentsOfFile:pathOfHashDB];

//	if ([BluetoothRegistrationSystemAppDelegate isNetwork] && hashDB && [hashDB objectForKey:fhash] &&  ![self validDate:[[hashDB objectForKey:fhash] objectForKey:@"createDate"]]) {
//        NSString *pathOfFile = NSHomeDirectory();
//        pathOfFile = [pathOfFile stringByAppendingPathComponent:@"Documents"];
//        pathOfFile = [pathOfFile stringByAppendingPathComponent:fhash];
//        NSError *error = nil;
//        [fileMgr removeItemAtPath:path error:&error];
//        if (!error) {
//            [hashDB removeObjectForKey:fhash];
//        }
//        return data;
//    }
    
	NSDictionary *myDict;
	myDict = [NSDictionary dictionaryWithContentsOfFile:path];
	if (myDict != nil) {
		data = [[[NSData alloc] initWithData:[myDict objectForKey:@"data"]] autorelease];
	}
	return data;
}


+ (void) registerItem:(NSString*)path{
    NSMutableDictionary *hashDB;
    hashDB = [[NSMutableDictionary dictionaryWithContentsOfFile:pathOfHashDB] retain];
    if (!hashDB) {
        hashDB = [[NSMutableDictionary alloc] init];
    }
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    NSDate *today = [NSDate date];
    [content setObject:(NSDate *)today  forKey:@"createDate"];
    [hashDB setObject:content  forKey:path];
    [hashDB writeToFile:pathOfHashDB atomically:YES];
    [hashDB release];
    [content release];
}

+ (void) registerItem:(NSString*)path withURL:(NSString*)url{
    NSMutableDictionary *hashDB;
    hashDB = [[NSMutableDictionary dictionaryWithContentsOfFile:pathOfHashDB] retain];
    if (!hashDB) {
        hashDB = [[NSMutableDictionary alloc] init];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //[dateFormatter setTimeZone:[NSTimeZone  timeZoneForSecondsFromGMT:([AppDelegate timezone] * 3600)]];
    NSString *currentTime = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release]; dateFormatter = nil;
    
    NSMutableDictionary *content = [[NSMutableDictionary alloc] init];
    [content setObject:currentTime  forKey:@"createDate"];
    [content setObject:url  forKey:@"url"];
    [hashDB setObject:content  forKey:path];
    NSLog(@"%@",content);
    [hashDB writeToFile:pathOfHashDB atomically:YES];
    [hashDB release];
    [content release]; 
    
  }
@end
