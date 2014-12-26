//
//  OsdnDataBase.m
//  VEH
//
//  Created by Edwin Zuydendorp on 8/30/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "OsdnDataBase.h"
#import "OsdnUtilHash.h"

@implementation OsdnDataBase

+ (NSData *)loadBaseWithURL:(NSString *)_url{
	
	NSData *data = nil;
	int number = [[[NSUserDefaults standardUserDefaults] stringForKey:@"days_key"] intValue];
	if (number == 0) {
		return data;
	}
	NSString *fhash = [OsdnUtilHash md5:[NSString stringWithFormat:@"%@",_url]];
	
	NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"Documents"];
	
    path = [path stringByAppendingPathComponent:[NSString stringWithString:fhash]];
	
	NSDictionary *myDict;
	myDict = [NSDictionary dictionaryWithContentsOfFile:path];
	if (myDict != nil) {
		data = [[NSData alloc] initWithData:[myDict objectForKey:@"data"]];
	}
	return data;
}

+ (void) addBaseWithURL:(NSString *)_url data:(NSData *)_data{	
	int number = [[[NSUserDefaults standardUserDefaults] stringForKey:@"days_key"] intValue];
	
	if (number>0) {
		NSDate *today = [NSDate date];
		NSString *fhash = [OsdnUtilHash md5:[NSString stringWithFormat:@"%@",_url]];
		
		NSString *path = NSHomeDirectory();
		path = [path stringByAppendingPathComponent:@"Documents"];
		path = [path stringByAppendingPathComponent:[NSString stringWithString:fhash]];
		
		NSMutableDictionary *myDict = [[NSMutableDictionary alloc] init];
		//[myDict setObject:[NSString stringWithFormat:@"%@",_url]  forKey:@"url"];
		[myDict setObject:(NSDate *)today  forKey:@"date"];
		[myDict setObject:(NSData *)_data  forKey:@"data"];
		
		[myDict writeToFile:path atomically:YES];
        
        [OsdnDataBase registerItem:fhash];
	}
}

+ (void)addWebBaseWithURL:(NSString *)_url data:(NSURL *)_data{	
	int number = [[[NSUserDefaults standardUserDefaults] stringForKey:@"days_key"] intValue];
	
	if (number>0) {
		NSString *fhash = [OsdnUtilHash md5:[NSString stringWithFormat:@"%@",_url]];
		NSString *path = NSHomeDirectory();
		path = [path stringByAppendingPathComponent:@"Documents"];
		path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat",fhash]];
		NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path] == NO){
            NSData *_dataString=[[NSData alloc] initWithContentsOfURL:_data];
            [_dataString writeToFile:path atomically:NO];
        }
        
        [OsdnDataBase registerItem:fhash];
	}
}


+ (NSString *)loadWebBaseWithURL:(NSString *)_url{
	
	NSString *data = nil;
	int number = [[[NSUserDefaults standardUserDefaults] stringForKey:@"days_key"] intValue];
	
	if (number == 0) {
		return data;
	}	
	NSString *fhash = [OsdnUtilHash md5:[NSString stringWithFormat:@"%@",_url]];
	
	NSString *path = NSHomeDirectory();
    path = [path stringByAppendingPathComponent:@"Documents"];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.dat",fhash]];
	
	NSFileManager *fm=[NSFileManager defaultManager];
    if(![fm fileExistsAtPath:path]){
		return data;
    }
	data = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	
	//data = [[NSString alloc] initWithContentsOfFile:path];
	return data;
}


@end
