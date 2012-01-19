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
        statisticsLearningArray = [[self loadAllStatisticsLearningWithWordType:wordType] retain];
//        lastThemeLearningDate = [[self getLastThemeLearningDate] retain];
    }
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

- (NSArray*)loadAllStatisticsLearningWithWordType:(WordTypes*)_wordType{
    NSArray *_statisticLearningArray = [NSArray arrayWithArray:[_wordType.statisticLearning allObjects]];
    NSSortDescriptor *status = [[NSSortDescriptor alloc] initWithKey:@"repeatStatus" ascending:YES];
    _statisticLearningArray = [_statisticLearningArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:status, nil]]; 
    return _statisticLearningArray;
}

- (NSDate *)getLastThemeLearningDateWithStatisticsArray:(NSArray*)_statisticsLearningArray{
    if (_statisticsLearningArray) {
        NSDate *_lastThemeLearningDate = ((StatisticLearning *)[_statisticsLearningArray lastObject]).lastLearningDate; 
        NSLog(@"lastLearningDate->%@",_lastThemeLearningDate);
        return _lastThemeLearningDate;
    } 
    return nil;
}

- (void)registerRepeat{
    if (wordType) {
        [[NSUserDefaults standardUserDefaults]  setBool:NO forKey:@"isNotShowRepeatList"];
        StatisticLearning *statisticLearning = [statisticsLearningArray lastObject];
        if (!statisticLearning) {
            statisticLearning = [self createStatisticLearningWithRepeatStatus:1];
        }else{
            [self setNewRepeatStatusToStatisticLearning:statisticLearning];
        }
        
        [[iTeachWordsAppDelegate sharedDelegate] activateNotification];
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
    NSLog(@"%@",[[NSDate date] stringWithFormat:@"dd.MM.YYYY  HH:mm"]);
    NSLog(@"%@",[[statisticLearning lastLearningDate] stringWithFormat:@"dd.MM.YYYY  HH:mm"]);
    return statisticLearning;
}

- (void)setNewRepeatStatusToStatisticLearning:(StatisticLearning*)statisticLearning{
    NSDate *currentDate = [NSDate date];
    NSDate *_lastThemeLearningDate = [self getLastThemeLearningDateWithStatisticsArray:statisticsLearningArray];
    if (statisticLearning) {
        int intervall = (int) [currentDate timeIntervalSinceDate:_lastThemeLearningDate];//imterval is in secconds
        NSLog(@"status->%@",statisticLearning.repeatStatus);
        NSLog(@"lastLearningDate->%@",_lastThemeLearningDate);
        NSLog(@"currentDate->%@",currentDate);
        NSLog(@"interval->%d",intervall);
        int _repeatStatus = [self getRepeatStatusByIntervalSeconds:intervall];
        NSLog(@"new status->%d",_repeatStatus);
        if (_repeatStatus > statisticLearning.repeatStatus.intValue) {
            statisticLearning = [self createStatisticLearningWithRepeatStatus:_repeatStatus];
        }
    }
}

- (int)getRepeatStatusByIntervalSeconds:(int)intervalSeconds{
    NSLog(@"interval->%d",intervalSeconds);    
    int _repeatStatus = 0;
    if (0<intervalSeconds && intervalSeconds<=30) {//<15 min
        _repeatStatus = 1;
    }else if (30<intervalSeconds && intervalSeconds<=60) {//<1 h
        _repeatStatus = 2;
    }else if (60<intervalSeconds && intervalSeconds<=604800) {//<7 d      86400 -> 1d
        _repeatStatus = 3;
    }else if (604800<intervalSeconds && intervalSeconds<=2592000) {//<1 m
        _repeatStatus = 4;
    }else if (2592000<intervalSeconds) {//>1 m
        _repeatStatus = 5;
    }
    bool availability = [[NSUserDefaults standardUserDefaults] boolForKey:[RepeatModel keyForStatus:_repeatStatus]];

    if (!availability) {
        return 0;
    }
    return _repeatStatus;
}

- (void)saveChanges{    
    NSError *_error;
    if (![CONTEXT save:&_error]) {
        [UIAlertView displayError:NSLocalizedString(@"Data is not saved.", @"")];
    }else{
        [iTeachWordsAppDelegate clearUdoManager];
    }
}

- (NSArray*)getDelayedTheme{
    NSArray *themes = [[NSArray alloc] initWithArray:[self loadAllThemes]];
    NSMutableArray *content = [[NSMutableArray alloc] init];
    for (int i=0;i<[themes count];i++){
        WordTypes *_wordType = [themes objectAtIndex:i];
        NSArray *_statisticsLearningArray = [self loadAllStatisticsLearningWithWordType:_wordType];
        int intervalToNexLearning = [self getTimeIntervalToNexLearning:_statisticsLearningArray];
        NSLog(@"intervalToNexLearning->%d",intervalToNexLearning);
        
        if (intervalToNexLearning>0) {
            NSDate *currentDate = [NSDate date];
            NSDate *_lastThemeLearningDate = [self getLastThemeLearningDateWithStatisticsArray:_statisticsLearningArray];
            int currentIntervall = (int) [currentDate timeIntervalSinceDate:_lastThemeLearningDate];//interval is in secconds
            NSLog(@"realCurrentIntervall->%d",currentIntervall);
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:_wordType forKey:@"wordType"];
            [dict setObject:[NSNumber numberWithInt:intervalToNexLearning-currentIntervall] forKey:@"intervalToNexLearning"];
            [content addObject:dict];
            [dict release];
        }
    }
    [themes release];
    return [content autorelease];
}


+ (NSString*)keyForStatus:(int)status{
    NSString *key = @"";
    switch (status) {
        case 2:
            key = @"repeatTimeIntervalAvailable1";
            break;
        case 3:
            key = @"repeatTimeIntervalAvailable2";
            break;
        case 4:
            key = @"repeatTimeIntervalAvailable3";
            break;
        case 5:
            key = @"repeatTimeIntervalAvailable4";
            break;
            
        default:
            break;
    }
    return key;
}

- (int)getTimeIntervalToNexLearning:(NSArray *)_statisticsLearningArray{
    StatisticLearning *_statisticLearning = [_statisticsLearningArray lastObject];
    int intervallToNextRepeat = 0;
    if (_statisticLearning) {
        int _repeatStatus = [_statisticLearning.repeatStatus intValue];
        int nexStatus = _repeatStatus+1;
        while (nexStatus<=5) {
            bool availability = [[NSUserDefaults standardUserDefaults] boolForKey:[RepeatModel keyForStatus:nexStatus]];
            if (availability) {
                break;
            }
            ++nexStatus;
        }
        switch (nexStatus-1) {
            case 0:
                intervallToNextRepeat = 0;
            case 1:
                intervallToNextRepeat = 30;//1200;   //20 min
                break;
            case 2:
                intervallToNextRepeat = 60;   //1d
                break;
            case 3:
                intervallToNextRepeat = 1209600; //2 w
                break;
            case 4:
                intervallToNextRepeat = 5184000; //2 m
                break;
                
            default:
                intervallToNextRepeat = 0;
                break;
        }
    }
    return intervallToNextRepeat;
}

- (void)dealloc {
    statisticsLearningArray = nil;
    wordType = nil;
//    lastThemeLearningDate = nil;
    [super dealloc];
}

@end
