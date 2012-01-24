//
//  NSString+Interaction.h
//  iCollab
//
//  Created by Yalantis on 05.04.10.
//  Copyright 2010 Yalantis. All rights reserved.
//


@interface NSString (Interaction)

- (NSString *)flattenHTML;
- (BOOL) validateEmail;
- (BOOL) validateAlphanumeric;
- (void) removeSpaces;
- (NSString *) translateString;
- (NSString *) translateStringWithLanguageCode:(NSString*)code;
- (NSDate *) dateWithFormat:(NSString *)format;

@end
