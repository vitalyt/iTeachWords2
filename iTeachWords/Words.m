//
//  Words.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/23/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "Words.h"
#import "Sounds.h"
#import "WordTypes.h"


@implementation Words
@dynamic translate;
@dynamic wordID;
@dynamic descriptionStr;
@dynamic createDate;
@dynamic changeBy;
@dynamic changeDate;
@dynamic text;
@dynamic isSelected;
@dynamic typeID;
@dynamic createBy;
@dynamic statistics;
@dynamic type;
@dynamic sounds;

- (void)addStatisticsObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"statistics" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"statistics"] addObject:value];
    [self didChangeValueForKey:@"statistics" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
}

- (void)removeStatisticsObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"statistics" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"statistics"] removeObject:value];
    [self didChangeValueForKey:@"statistics" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
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



- (void)addSoundsObject:(Sounds *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"sounds" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"sounds"] addObject:value];
    [self didChangeValueForKey:@"sounds" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
}

- (void)removeSoundsObject:(Sounds *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"sounds" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"sounds"] removeObject:value];
    [self didChangeValueForKey:@"sounds" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
}

- (void)addSounds:(NSSet *)value {    
    [self willChangeValueForKey:@"sounds" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"sounds"] unionSet:value];
    [self didChangeValueForKey:@"sounds" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeSounds:(NSSet *)value {
    [self willChangeValueForKey:@"sounds" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"sounds"] minusSet:value];
    [self didChangeValueForKey:@"sounds" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
