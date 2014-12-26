//
//  NSNumber+Interaction.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/20/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "NSNumber+Interaction.h"


@implementation NSNumber (Interaction)

+ (NSInteger) randomFrom:(NSInteger)min to:(NSInteger)max{
	return rand() % (max - min) + min;
}

@end
