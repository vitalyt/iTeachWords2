//
//  StatisticType.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 7/28/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "StatisticType.h"
#import "Statistic.h"


@implementation StatisticType
@dynamic descriptionStr;
@dynamic statisticTypeID;
@dynamic statistics;

- (void)addStatisticsObject:(Statistic *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"statistics" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"statistics"] addObject:value];
    [self didChangeValueForKey:@"statistics" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeStatisticsObject:(Statistic *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"statistics" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"statistics"] removeObject:value];
    [self didChangeValueForKey:@"statistics" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addStatistics:(NSSet *)value {    
    [self willChangeValueForKey:@"statistics" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"statistics"] unionSet:value];
    [self didChangeValueForKey:@"statistics" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeStatistics:(NSSet *)value {
    [self willChangeValueForKey:@"statistics" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"statistics"] minusSet:value];
    [self didChangeValueForKey:@"statistics" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
