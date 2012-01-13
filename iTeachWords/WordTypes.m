//
//  WordTypes.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/6/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "WordTypes.h"
#import "Words.h"


@implementation WordTypes

@dynamic sorted;
@dynamic descriptionStr;
@dynamic createDate;
@dynamic translateCountryCode;
@dynamic changeBy;
@dynamic delete;
@dynamic nativeCountryCode;
@dynamic changeDate;
@dynamic typeID;
@dynamic name;
@dynamic createBy;
@dynamic statisticLearning;
@dynamic words;

- (void)addWordsObject:(Words *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"words" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"words"] addObject:value];
    [self didChangeValueForKey:@"words" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeWordsObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"words" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"words"] removeObject:value];
    [self didChangeValueForKey:@"words" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addWords:(NSSet *)value {    
    [self willChangeValueForKey:@"words" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"words"] unionSet:value];
    [self didChangeValueForKey:@"words" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeWords:(NSSet *)value {
    [self willChangeValueForKey:@"words" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"words"] minusSet:value];
    [self didChangeValueForKey:@"words" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}




- (void)addStatisticLearningObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"statisticLearning" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"statisticLearning"] addObject:value];
    [self didChangeValueForKey:@"statisticLearning" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeStatisticLearningObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"statisticLearning" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"statisticLearning"] removeObject:value];
    [self didChangeValueForKey:@"statisticLearning" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addStatisticLearning:(NSSet *)value {    
    [self willChangeValueForKey:@"statisticLearning" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"statisticLearning"] unionSet:value];
    [self didChangeValueForKey:@"statisticLearning" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeStatisticLearning:(NSSet *)value {
    [self willChangeValueForKey:@"statisticLearning" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"statisticLearning"] minusSet:value];
    [self didChangeValueForKey:@"statisticLearning" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}
@end
