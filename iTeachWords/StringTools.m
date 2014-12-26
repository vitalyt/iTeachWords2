//
//  StringTools.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/24/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#define slash @" ,.\t\n\r{}*:;"
#define translateSlash @"~"

#import "StringTools.h"
#import "WBEngine.h"
#import "WBRequest.h"
#import "WBConnection.h"
//#import "XMLReader.h"

@implementation StringTools

@synthesize arrayWords;
@synthesize arrayWordsSorting;
@synthesize myText;
@synthesize caller; 

- (void) printString:(NSString *) str{
	myText = @"You’ve encountered string objects in your programs before.Whenever you enclosed a se- quence of character strings inside a pair of double quotes, as in Programming is fun	you created a character string object in Objective-C.The Foundation framework supports a class called NSString for working with character string objects.Whereas C-style strings consist of char characters, NSString objects consist of unichar characters. A unichar character is a multibyte character according to the Unicode standard.This enables you to work with character sets that can contain literally millions of characters. Luckily, you don’t have to worry about the internal representation of the characters in your strings because the NSString class automatically handles this for you.1 By using the methods from this class, you can more easily develop applications that can be localized—that is, made to work in different languages all over the world. 	1 Currently, unichar characters occupy 16 bits, but the Unicode standard provides for characters larger than that size. So in the future, unichar characters might be larger than 16 bits. The bottom line is to never make an assumption about the size of a Unicode character.	As you know, you create a constant character string object in Objective-C by putting the @ character in front of the string of double-quoted characters. So the expression	@”Programming is fun” creates a constant character string object. In particular, it is a constant character string that belongs to the class NSConstantString. NSConstantString is a subclass of the string ob- ject class NSString.To use string objects in your program, include the following line: More on the NSLog Function Program 15.2, which follows, shows how to define an NSString object and assign an ini- tial value to it. It also shows how to use the format characters %@ to display an NSString object.";
	NSCharacterSet *wordTokenizingSet = [NSCharacterSet characterSetWithCharactersInString:slash];
	NSMutableArray	*wordArray = [[str componentsSeparatedByCharactersInSet:wordTokenizingSet] mutableCopy];
	//NSArray	*wordArray = [text componentsSeparatedByString:@" "];
	arrayWords = [[NSMutableDictionary alloc] init];
    NSInteger *index = 0;
	for (NSString *word in wordArray){
        NSString *str = [NSString removeSpaces:word];
        [wordArray replaceObjectAtIndex:index++ withObject:str];
        if ([word length]==0) {
            continue;
        }
		if ([arrayWords objectForKey:word] == nil) {
			[arrayWords setObject:[NSNumber numberWithInt:1] forKey:word];
		}
		else {
			int q = [[arrayWords objectForKey:word] intValue];
			q ++;
			[arrayWords setObject:[NSNumber numberWithInt:q] forKey:word];
		}
	}
	arrayWordsSorting = [arrayWords keysSortedByValueUsingSelector:@selector(compare:)];    
    for(NSString *theValue in arrayWordsSorting)
    {
        NSLog(@"%@\t->%d", theValue,[[arrayWords objectForKey:theValue] intValue]);
    }
}

- (void)loadTranslateForWords:(NSArray*)wordsArray withDelegate:(id)_caller{
    self.caller = _caller;
    NSString *wordsRequestString = [[NSString alloc] initWithFormat:@"%@",
                                    [wordsArray componentsJoinedByString:translateSlash]];
    wordsRequestString = [NSString removeSpaces:wordsRequestString];
    [self sendRequestWitchText:wordsRequestString];
}

#pragma mark loading data functions

- (void)sendRequestWitchText:(NSString*)wordsText
{
    [UIAlertView showLoadingViewWithMwssage:NSLocalizedString(@"Loading...", @"")];
    if (!wbEngine) {
        wbEngine = [[WBEngine alloc] init];
    }
    NSString *url = [[NSString stringWithFormat:@"http://api.microsofttranslator.com/v2/http.svc/translate?appId=%@&text=%@&from=%@&to=%@",
                      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"TranslateAppId"],
                      wordsText,
                      TRANSLATE_LANGUAGE_CODE,
                      NATIVE_LANGUAGE_CODE] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"url-->%@",[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    NSLog(@"url->%@",url);
    WBRequest * _request = [WBRequest getRequestWithURL:url delegate:self];
    [wbEngine performRequest:_request];
}


#pragma mark - WBRequest functions

- (void) connectionDidFinishLoading: (WBConnection*)connection {
    
	NSData *value = [connection data];
    NSString *response = [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
    NSLog(@"responseText->%@",response);
    @try
    {
//        NSDictionary *result = [XMLReader dictionaryForXMLString:response error:nil];
//        if (!result || ![result objectForKey:@"string"] || [[result objectForKey:@"string"] objectForKey:@"text"]) {
//            NSString *translateText = [[result objectForKey:@"string"] objectForKey:@"text"];
//            [caller didLoadTranslate:[translateText componentsSeparatedByString:translateSlash]];
//        }else{
//            CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:NSLocalizedString(@"", @"")
//                                                             message:NSLocalizedString(@"No results found", @"")  
//                                                            delegate:self 
//                                                   cancelButtonTitle:NSLocalizedString(@"OK", @"") 
//                                                   otherButtonTitles: nil];
//            [alert show];
//        }
    }
    @finally
    {
        [UIAlertView removeMessage];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

@end
