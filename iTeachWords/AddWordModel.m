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
        self.currentWord = _word;
        self.wordType = _word.type;
    }
}

- (void) createWord{
    if (!currentWord) {
        self.currentWord = [NSEntityDescription insertNewObjectForEntityForName:@"Words" 
                                                    inManagedObjectContext:CONTEXT];
        [currentWord setCreateDate:[NSDate date]];
    }
    [currentWord setChangeDate:[NSDate date]];
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
