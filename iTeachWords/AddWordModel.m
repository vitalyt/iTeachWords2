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
#import "WBConnection.h"
#import "WBRequest.h"
#import "WBEngine.h"
#import "XMLReader.h"

@implementation AddWordModel
@synthesize urlShow;
@synthesize wordType,currentWord;
@synthesize delegate;

//- (id)initWithDelegate:(id)_delegate {
//    self = [super init];
//    if (self) {
//        self.delegate = _delegate;
//    }
//    return self;
//}

- (void)dealloc {
    [delegate release];
    [wbEngine release];
    [currentTranslateLanguageCode release];
    [urlShow release];
    [wordType release];
    [currentWord release];
    [super dealloc];
}

- (void) setWord:(Words *)_word{
    if (currentWord != _word) {
        [self createUndoBranch];
        currentWord = [_word retain];
        wordType = [_word.type retain];
    }
}

- (void) createWord{
    if (!currentWord) {
        //        [iTeachWordsAppDelegate clearUdoManager];
//        [[CONTEXT undoManager] removeAllActions];
        [self createUndoBranch];
        self.currentWord = [NSEntityDescription insertNewObjectForEntityForName:@"Words" 
                                                    inManagedObjectContext:CONTEXT];
        [currentWord setCreateDate:[NSDate date]];
        [wordType addWordsObject:currentWord];
    }
    [currentWord setType:wordType];
    [currentWord setTypeID:wordType.typeID];
    [currentWord setChangeDate:[NSDate date]];
}

- (void)createUndoBranch{
    [iTeachWordsAppDelegate createUndoBranch];
}

- (void)removeChanges{
    [iTeachWordsAppDelegate remoneUndoBranch];
}

- (void)saveWord{    
    [iTeachWordsAppDelegate saveUndoBranch];
}

- (void)setCurrentTranslateLanguageCode:(NSString *)_currentTranslateLanguageCode{
    if (currentTranslateLanguageCode != _currentTranslateLanguageCode) {
        [currentTranslateLanguageCode release];
        currentTranslateLanguageCode = [_currentTranslateLanguageCode retain];
    }
}

-(void) createUrls{
//	url = [[NSString alloc] initWithFormat: @"https://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=%@&langpair=%@|%@",currentWord.text,
//          TRANSLATE_LANGUAGE_CODE,
//          NATIVE_LANGUAGE_CODE];
    
    self.urlShow = [[NSString alloc] initWithFormat: @"http://translate.google.com/?hl=%@&sl=%@&tl=%@&ie=UTF-8&prev=_m&q=%@",
               NATIVE_LANGUAGE_CODE,
           TRANSLATE_LANGUAGE_CODE,
           NATIVE_LANGUAGE_CODE,currentWord.text];
    NSLog(@"%@",urlShow);
}

#pragma loading translate

#pragma mark loading data functions

- (void)loadTranslateText:(NSString*)text fromLanguageCode:(NSString*)fromLanguageCode toLanguageCode:(NSString*)toLanguageCode withDelegate:(id)_delegate
{
    if ([iTeachWordsAppDelegate isNetwork]) {
        self.delegate = _delegate;
        if (!wbEngine) {
            wbEngine = [[WBEngine alloc] init];
        }
        [UIAlertView showLoadingViewWithMwssage:NSLocalizedString(@"Loadnig translate...", @"")];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSString *url = [[NSString stringWithFormat:@"http://api.microsofttranslator.com/v2/http.svc/translate?appId=%@&text=%@&from=%@&to=%@"
                          ,[[[NSBundle mainBundle] infoDictionary] objectForKey:@"TranslateAppId"],
                          text,
                          [fromLanguageCode uppercaseString],
                          [toLanguageCode uppercaseString]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self setCurrentTranslateLanguageCode:toLanguageCode];
        NSLog(@"%@",text);
        NSLog(@"url->%@",url);
//        NSString *url = [[NSString alloc] initWithFormat: @"https://ajax.googleapis.com/ajax/services/language/translate?v=1.0&q=%@&langpair=%@|%@",currentWord.text,
//                         TRANSLATE_LANGUAGE_CODE,
//                         NATIVE_LANGUAGE_CODE];
        WBRequest * _request = [WBRequest getRequestWithURL:url delegate:self];
        [wbEngine performRequest:_request];
    }
    

}


#pragma mark - WBRequest functions

- (void) connectionDidFinishLoading: (WBConnection*)connection {
	NSData *value = [connection data];
    NSString *response = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
    [UIAlertView removeMessage];
    @try
    {
        NSDictionary *result = [XMLReader dictionaryForXMLString:response error:nil];
        NSLog(@"%@",result);
        SEL selector = @selector(translateDidLoad:byLanguageCode:);
        if (!result || ![result objectForKey:@"string"] || [[result objectForKey:@"string"] objectForKey:@"text"]) {
            if ([delegate respondsToSelector:selector]) {
                NSString *_translate = [[result objectForKey:@"string"] objectForKey:@"text"];
                [delegate performSelector:selector withObject:_translate withObject:currentTranslateLanguageCode];
            }
        }else{
            if ([delegate respondsToSelector:selector]) {
                [delegate performSelector:selector withObject:nil withObject:currentTranslateLanguageCode];
            }
        }
    }
    @finally
    {
        [response release];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

- (void) connection: (WBConnection*)connection didFailWithError: (NSError*)error{
    [UIAlertView removeMessage];
}

@end
