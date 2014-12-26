//
//  NSDate+Interaction.m
//  hrmobile.efis
//
//  Created by Vitaly Todorovych on 6/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "NSDate+Interaction.h"


@implementation NSDate (NSDate_Interaction)

- (NSString *)stringWithFormat: (NSString *)format
{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
   // NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:([BluetoothRegistrationSystemAppDelegate timezone] * 3600)];
    //[df setTimeZone:timeZone];
    [df setDateFormat:format];
	NSString *dob = [df stringFromDate:self];
    NSLog(@"%@",dob);
	return dob;
}

@end
