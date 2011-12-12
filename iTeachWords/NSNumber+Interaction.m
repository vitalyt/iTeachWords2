//
//  NSNumber+Interaction.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/20/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "NSNumber+Interaction.h"


@implementation NSNumber (Interaction)

+ (int) randomFrom:(int)from to:(int)to{
	srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF));    
    int randomValue = 0;
    if ((to - from) != 0) {
        randomValue = from+ (random() % (to - from));
    }
	return randomValue;
}

@end
