//
//  StringTools.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/24/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#define slash @" ,.\t\n\r{}*:;"

#import "StringTools.h"

@implementation StringTools

@synthesize arrayWords;
@synthesize arrayWordsSorting;
@synthesize myText;

- (void) printString:(NSString *) str{
	myText = @"You’ve encountered string objects in your programs before.Whenever you enclosed a se- quence of character strings inside a pair of double quotes, as in Programming is fun	you created a character string object in Objective-C.The Foundation framework supports a class called NSString for working with character string objects.Whereas C-style strings consist of char characters, NSString objects consist of unichar characters. A unichar character is a multibyte character according to the Unicode standard.This enables you to work with character sets that can contain literally millions of characters. Luckily, you don’t have to worry about the internal representation of the characters in your strings because the NSString class automatically handles this for you.1 By using the methods from this class, you can more easily develop applications that can be localized—that is, made to work in different languages all over the world. 	1 Currently, unichar characters occupy 16 bits, but the Unicode standard provides for characters larger than that size. So in the future, unichar characters might be larger than 16 bits. The bottom line is to never make an assumption about the size of a Unicode character.	As you know, you create a constant character string object in Objective-C by putting the @ character in front of the string of double-quoted characters. So the expression	@”Programming is fun” creates a constant character string object. In particular, it is a constant character string that belongs to the class NSConstantString. NSConstantString is a subclass of the string ob- ject class NSString.To use string objects in your program, include the following line: More on the NSLog Function Program 15.2, which follows, shows how to define an NSString object and assign an ini- tial value to it. It also shows how to use the format characters %@ to display an NSString object.";
	NSCharacterSet *wordTokenizingSet = [NSCharacterSet characterSetWithCharactersInString:slash];
	NSArray	*wordArray = [str componentsSeparatedByCharactersInSet:wordTokenizingSet];
	//NSArray	*wordArray = [text componentsSeparatedByString:@" "];
	
	arrayWords = [[NSMutableDictionary alloc] init];
	for (NSString *word in wordArray){
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



@end
