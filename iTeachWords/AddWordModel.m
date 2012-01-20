//
//  AddWordModel.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/8/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "AddWordModel.h"
#import "WordTypes.h"
#import "Words.h"

@implementation AddWordModel
@synthesize url,urlShow;
@synthesize wordType,currentWord;

- (void)dealloc {
    [url release];
    [urlShow release];
    [wordType release];
    [currentWord release];
    [super dealloc];
}

- (void) setWord:(Words *)_word{
    if (currentWord != _word) {
        [iTeachWordsAppDelegate clearUdoManager];
        currentWord = [_word retain];
        wordType = [_word.type retain];
    }
}

- (void) createWord{
    if (!currentWord) {
        [iTeachWordsAppDelegate clearUdoManager];
        self.currentWord = [NSEntityDescription insertNewObjectForEntityForName:@"Words" 
                                                    inManagedObjectContext:CONTEXT];
        [currentWord setCreateDate:[NSDate date]];
        [wordType addWordsObject:currentWord];
    }
    [currentWord setType:wordType];
    [currentWord setTypeID:wordType.typeID];
    [currentWord setChangeDate:[NSDate date]];
}

- (void)saveWord{    
    NSError *_error;
    if (![CONTEXT save:&_error]) {
        [UIAlertView displayError:@"Data is not saved."];
    }else{
        NSLog(@"Word saved->%@",self.currentWord);
        [iTeachWordsAppDelegate clearUdoManager];
    }
}

- (void)undoChngesWord{
    [CONTEXT rollback];
}

-(void) createUrls{
	url = [[NSString alloc] initWithFormat: @"https://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=%@&langpair=%@|%@",currentWord.text,
          [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE],
          [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE]];
    
    self.urlShow = [[NSString alloc] initWithFormat: @"http://translate.google.com/?hl=%@&sl=%@&tl=%@&ie=UTF-8&prev=_m&q=%@",
               [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE],
           [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE],
           [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE],currentWord.text];
    NSLog(@"%@",urlShow);
}

@end
