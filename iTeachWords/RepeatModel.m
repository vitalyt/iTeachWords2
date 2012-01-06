//
//  RepeatModel.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/6/12.
//  Copyright 2012 OSDN. All rights reserved.
//

#import "RepeatModel.h"
#import "WordTypes.h"
#import "StatisticLearning.h"

@implementation RepeatModel

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initWithWordType:(WordTypes*)_wordType {
    self = [super init];
    if (self) {
        if (_wordType) {
            [self setWordType:_wordType];
        }
    }
    return self;
}

#pragma mark adding functions

- (void)setWordType:(WordTypes*)_wordType{
    if (_wordType != wordType) {
        [wordType release];
        wordType = [_wordType retain];
        [self updateLastThemeLearningDate];
    }
}

- (void)updateLastThemeLearningDate{
    NSArray *statisticLearningArray = [NSArray arrayWithArray:[wordType.statisticLearning allObjects]];
    NSSortDescriptor *status = [[NSSortDescriptor alloc] initWithKey:@"repeatStatus" ascending:YES];
    statisticLearningArray = [statisticLearningArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:status, nil]];
    lastThemeLearningDate = [((StatisticLearning *)[statisticLearningArray objectAtIndex:0]).lastLearningDate retain];  
}

- (void)registerRepeat{
    if (wordType) {
        NSArray *statisticLearningArray = [NSArray arrayWithArray:[wordType.statisticLearning allObjects]];
        NSSortDescriptor *status = [[NSSortDescriptor alloc] initWithKey:@"repeatStatus" ascending:YES];
        statisticLearningArray = [statisticLearningArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:status, nil]];
        StatisticLearning *statisticLearning = [statisticLearningArray lastObject];
        
        if (!statisticLearning) {
            statisticLearning = [self createStatisticLearningWithRepeatStatus:1];
        }else{
            [self setNewRepeatStatusToStatisticLearning:statisticLearning];
        }
        [self saveChanges];
    }
}

- (StatisticLearning *) createStatisticLearningWithRepeatStatus:(int)_repeatStatus{
    StatisticLearning *statisticLearning = [NSEntityDescription insertNewObjectForEntityForName:@"StatisticLearning" 
                                                         inManagedObjectContext:CONTEXT];
    [statisticLearning setCreateDate:[NSDate date]];
    [statisticLearning setWordType:wordType];
    [statisticLearning setWordTypeID:wordType.typeID];
    [statisticLearning setRepeatType:[NSNumber numberWithInt:0]];//set standart repeat type
    [statisticLearning setRepeatStatus:[NSNumber numberWithInt:_repeatStatus]];
    [statisticLearning setChangeDate:[NSDate date]];
    [statisticLearning setLastLearningDate:[NSDate date]];
    return statisticLearning;
}

- (void)setNewRepeatStatusToStatisticLearning:(StatisticLearning*)statisticLearning{
    NSDate *currentDate = [NSDate date];    
    if (statisticLearning) {
        int intervall = (int) [currentDate timeIntervalSinceDate:lastThemeLearningDate];//imterval is in secconds
        NSLog(@"status->%@",statisticLearning.repeatStatus);
        NSLog(@"lastLearningDate->%@",lastThemeLearningDate);
        NSLog(@"currentDate->%@",currentDate);
        int _repeatStatus = [self getRepeatStatusByIntervalSeconds:intervall];
        if (_repeatStatus > statisticLearning.repeatStatus.intValue) {
            statisticLearning = [self createStatisticLearningWithRepeatStatus:_repeatStatus];
        }
    }
}

- (int)getRepeatStatusByIntervalSeconds:(int)intervalSeconds{
    NSLog(@"interval->%d",intervalSeconds);    
    int _repeatStatus = 0;
    if (0<intervalSeconds && intervalSeconds<=900) {//<15 min
        _repeatStatus = 1;
    }else if (900<intervalSeconds && intervalSeconds<=3600) {//<1 h
        _repeatStatus = 2;
    }else if (3600<intervalSeconds && intervalSeconds<=10800) {//<3 d
        _repeatStatus = 3;
    }else if (10800<intervalSeconds && intervalSeconds<=324000) {//<1 m
        _repeatStatus = 4;
    }else if (324000<intervalSeconds) {//>1 m
        _repeatStatus = 5;
    }
    return _repeatStatus;
}

- (void)saveChanges{    
    NSError *_error;
    if (![CONTEXT save:&_error]) {
        [UIAlertView displayError:@"Data is not saved."];
    }else{
        [iTeachWordsAppDelegate clearUdoManager];
    }
}

- (NSArray*)getDelayedTheme{
    NSArray *themes = [[NSArray alloc] init];
    themes = [self loadAllThemes];
    NSMutableArray *content = [[NSMutableArray alloc] init];
    for (int i=0;i<[themes count];i++){
        WordTypes *_wordType = [themes objectAtIndex:i];
        
        NSArray *statisticLearningArray = [NSArray arrayWithArray:[_wordType.statisticLearning allObjects]];
        NSSortDescriptor *status = [[NSSortDescriptor alloc] initWithKey:@"repeatStatus" ascending:YES];
        statisticLearningArray = [statisticLearningArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:status, nil]];
        StatisticLearning *statisticLearning = [statisticLearningArray lastObject];
        lastThemeLearningDate = [((StatisticLearning *)[statisticLearningArray objectAtIndex:0]).lastLearningDate retain]; 
        
        if ([self isStatisticLearningDelayed:statisticLearning]) {
            [content addObject:_wordType];
        }
    }
    return [content autorelease];
}

- (bool)isStatisticLearningDelayed:(StatisticLearning*)statisticLearning{
    NSDate *currentDate = [NSDate date];    
    if (statisticLearning) {
        int intervall = (int) [currentDate timeIntervalSinceDate:lastThemeLearningDate];//imterval is in secconds
        NSLog(@"status->%@",statisticLearning.repeatStatus);
        NSLog(@"lastLearningDate->%@",lastThemeLearningDate);
        NSLog(@"currentDate->%@",currentDate);
        int _repeatStatus = [self getRepeatStatusByIntervalSeconds:intervall];
        if (_repeatStatus > statisticLearning.repeatStatus.intValue) {
            return YES;
        }
    }
    return NO;
}

- (NSArray*)loadAllThemes{
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"nativeCountryCode = %@ && translateCountryCode = %@",[[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE], [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE]];
    NSFetchedResultsController *fetches = [NSManagedObjectContext 
                                           getEntities:@"WordTypes" sortedBy:@"createDate" withPredicate:predicate];
    NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
	NSArray *companies = [fetches fetchedObjects];
	companies = [companies sortedArrayUsingDescriptors:[NSArray arrayWithObjects:date, nil]];
    return companies;
}

- (void)dealloc {
    wordType = nil;
    lastThemeLearningDate = nil;
    [super dealloc];
}

@end
