//
//  WordTypes.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/12/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "WordTypes.h"
#import "Words.h"


@implementation WordTypes

@dynamic typeID;
@dynamic sorted;
@dynamic createBy;
@dynamic changeBy;
@dynamic delete;
@dynamic changeDate;
@dynamic descriptionStr;
@dynamic createDate;
@dynamic name;
@dynamic nativeCountryCode;
@dynamic translateCountryCode;
@dynamic words;

- (void)addWordsObject:(NSManagedObject *)value {    
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


@end
