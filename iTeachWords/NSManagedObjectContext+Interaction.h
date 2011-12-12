//
//  NSManagedObjectContext+Interaction.h
//  iCollab
//
//  Created by Yalantis on 13.04.10.
//  Copyright 2010 Yalantis Software. All rights reserved.
//

@interface NSManagedObjectContext (Interaction) 

+ (NSManagedObject *)getEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate;

+ (NSFetchedResultsController *)getEntities:(NSString *)entityName 
				sortedBy:(NSString *)sortString
		   withPredicate:(NSPredicate *)predicate;

+ (NSFetchedResultsController *)getEntities:(NSString *)entityName 
								   sortedBy:(NSString *)sortString
							  withPredicate:(NSPredicate *)predicate
									splitBy:(NSString *)sectionName;

+ (NSFetchedResultsController *)getEntities:(NSString *)entityName 
								   sortedBy:(NSString *)sortString
							  withPredicate:(NSPredicate *)predicate
									splitBy:(NSString *)sectionName
								  ascending:(BOOL)ascending;

+ (int)countObjectsForEntity:(NSString *)entityName;
+ (int)countObjectsForEntity:(NSString *)entityName withPredicate:(NSPredicate *)predicate;

@end
