//
//  NSManagedObjectContext+Interaction.m
//  iCollab
//
//  Created by Yalantis on 13.04.10.
//  Copyright 2010 Yalantis Software. All rights reserved.
//

#import "NSManagedObjectContext+Interaction.h"

@implementation NSManagedObjectContext (Interaction) 

+ (NSManagedObject *)getEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [NSFetchRequest new];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:CONTEXT];
	[request setEntity:entity];
	
	NSSortDescriptor *dateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:dateDescriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	[request setPredicate:predicate];
	
	NSFetchedResultsController *fetchResults = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
									managedObjectContext:CONTEXT sectionNameKeyPath:nil cacheName:nil];
	[fetchResults performFetch:nil];
	NSArray *results = [fetchResults fetchedObjects];
	return [results lastObject];
}

+ (NSFetchedResultsController *)getEntities:(NSString *)entityName 
		   sortedBy:(NSString *)sortString
		   withPredicate:(NSPredicate *)predicate {
	return [NSManagedObjectContext getEntities:entityName sortedBy:sortString withPredicate:predicate splitBy:nil];
}

+ (NSFetchedResultsController *)getEntities:(NSString *)entityName 
								   sortedBy:(NSString *)sortString
							  withPredicate:(NSPredicate *)predicate
									splitBy:(NSString *)sectionName
								  ascending:(BOOL)ascending {
	NSFetchRequest *request = [NSFetchRequest new];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:CONTEXT];
	[request setEntity:entity];
	
	NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:sortString ascending:ascending];
	NSArray *sortDescriptors = [NSArray arrayWithObjects:descriptor, nil];
	[request setSortDescriptors:sortDescriptors];
	
	if (predicate) [request setPredicate:predicate];
	
	NSFetchedResultsController *fetchResults = [[NSFetchedResultsController alloc] initWithFetchRequest:request 
										managedObjectContext:CONTEXT sectionNameKeyPath:sectionName cacheName:nil];
	[fetchResults performFetch:nil];
	return fetchResults;
}

+ (NSFetchedResultsController *)getEntities:(NSString *)entityName 
				sortedBy:(NSString *)sortString
				withPredicate:(NSPredicate *)predicate
				splitBy:(NSString *)sectionName {
	return [self getEntities:entityName sortedBy:sortString withPredicate:predicate splitBy:sectionName ascending:YES];
	
}

+ (int)countObjectsForEntity:(NSString *)entityName {
	return [self countObjectsForEntity:entityName withPredicate:nil];
}

+ (int)countObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [NSFetchRequest new];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:CONTEXT];
	[request setEntity:entity];
	if (predicate) [request setPredicate:predicate];
	return [CONTEXT countForFetchRequest:request error:nil];
}


@end
