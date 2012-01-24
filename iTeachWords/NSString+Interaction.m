//
//  NSString+Interaction.m
//  iCollab
//
//  Created by Yalantis on 05.04.10.
//  Copyright 2010 Yalantis. All rights reserved.
//

#import "NSString+Interaction.h"
#import "JSON.h"
#import "XMLReader.h"

@implementation NSString (Interaction)

- (NSString *)flattenHTML {
	
	NSString *retValue = self;
    NSScanner *theScanner;
    NSString *text = nil;
	
    theScanner = [NSScanner scannerWithString:self];
	
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ; 
        [theScanner scanUpToString:@">" intoString:&text] ;
        retValue = [retValue stringByReplacingOccurrencesOfString: [NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    return retValue;
}

- (BOOL) validateEmail {
    NSString *regexp = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp]; 
	
    return [test evaluateWithObject:self];
}

- (BOOL) validateAlphanumeric {
    NSString *regexp = @"[\\w ]*"; 
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexp]; 
    return [test evaluateWithObject:self];
}

- (void) removeSpaces{
    NSMutableString *str = [[NSMutableString alloc]initWithString:self];
    while ([str hasPrefix:@"\n"]) {
        NSRange range;
        range.location = 0;
        range.length = 1;
        [str replaceCharactersInRange:range withString:@""];
    }
    while ([str hasSuffix:@"\n"]) {
        NSRange range;
        range.location = [str length]-1;
        range.length = 1;
        [str replaceCharactersInRange:range withString:@""];
    }
    while ([str hasPrefix:@" "]) {
        NSRange range;
        range.location = 0;
        range.length = 1;
        [str replaceCharactersInRange:range withString:@""];
    }
    while ([str hasSuffix:@" "]) {
        NSRange range;
        range.location = [str length]-1;
        range.length = 1;
        [str replaceCharactersInRange:range withString:@""];
    }
    self = str;
    [str release];
}

- (NSString *) translateString{
    if ([iTeachWordsAppDelegate isNetwork]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSString *url = [[NSString stringWithFormat:@"http://api.microsofttranslator.com/v2/http.svc/translate?appId=%@&text=%@&from=%@&to=%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"TranslateAppId"],
                          self,
                          [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE],
                          [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"url->%@",url);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseText->%@",response);
        @try
        {
            NSDictionary *result = [XMLReader dictionaryForXMLString:response error:nil];
            if (!result || ![result objectForKey:@"string"] || [[result objectForKey:@"string"] objectForKey:@"text"]) {
                return [[result objectForKey:@"string"] objectForKey:@"text"];
            }
        }
        @finally
        {
            [response release];
        }
        return NSLocalizedString(@"", @"");
    }
    return nil;
}

- (NSString *) translateStringWithLanguageCode:(NSString*)code{
    if ([iTeachWordsAppDelegate isNetwork]) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSString* translateCountryCode = [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE];
        NSString* nativeCountryCode = [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE];
        
        NSString* fromLanguage = [code uppercaseString];
        NSString* toLanguage = ([nativeCountryCode isEqualToString:fromLanguage])?translateCountryCode:nativeCountryCode;
        NSString *url = [[NSString stringWithFormat:@"http://api.microsofttranslator.com/v2/http.svc/translate?appId=%@&text=%@&from=%@&to=%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"TranslateAppId"],
                          self,
                          [fromLanguage uppercaseString],
                          [toLanguage uppercaseString]
                          ] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"url->%@",url);
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"responseText->%@",response);
        @try
        {
            NSDictionary *result = [XMLReader dictionaryForXMLString:response error:nil];
            if (!result || ![result objectForKey:@"string"] || [[result objectForKey:@"string"] objectForKey:@"text"]) {
                return [[result objectForKey:@"string"] objectForKey:@"text"];
            }
        }
        @finally
        {
            [response release];
        }
        return NSLocalizedString(@"", @"");
    }
    return nil;
}

- (NSDate *) dateWithFormat:(NSString *)format{
	NSDateFormatter *df = [[NSDateFormatter alloc] init];    
    [df setDateFormat:format]; 
   // NSTimeZone *timeZone = [NSTimeZone timeZoneForSecondsFromGMT:[iTeachWordsAppDelegate timezone]];
   // [df setTimeZone:timeZone];
	NSDate *date = [[[NSDate alloc] init] autorelease];
	date = [df dateFromString:self];
	if (date == nil) {
		date = [NSDate date];
	}
	[df release];
    NSLog(@"%@",date);
    return date;
}

@end
