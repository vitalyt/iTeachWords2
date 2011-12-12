//
//  NSArray+Interaction.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/20/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "NSArray+Interaction.h"
#import "NSNumber+Interaction.h"

@implementation NSArray (NSArray_Interaction)

- (void) mixArray{
	NSMutableArray *newArray = [[NSMutableArray alloc] init];
	NSMutableArray *oldArray = [[NSMutableArray alloc] initWithArray:self];
    int count = [oldArray count];
	for (int i=0; i< count/2; i++) {
		int randomIndex = [NSNumber randomFrom:0 to:[oldArray count]];
		[newArray addObject:[oldArray objectAtIndex:randomIndex]];
		[oldArray removeObjectAtIndex:randomIndex];
	}
    self = [NSArray arrayWithArray:newArray];
    [newArray release];
    [oldArray release];

}

+ (NSArray *) mixArray:(NSArray *)array{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
	NSMutableArray *oldArray = [[NSMutableArray alloc] initWithArray:array];
    //[array release];
    int count = [oldArray count];
	for (int i=0; i<count; i++) {
		int randomIndex = [NSNumber randomFrom:0 to:[oldArray count]];
		[newArray addObject:[oldArray objectAtIndex:randomIndex]];
		[oldArray removeObjectAtIndex:randomIndex];
	}
    //self = [NSArray arrayWithArray:newArray];
    //[newArray release];
    [oldArray release];
    return [newArray autorelease];
}

@end
