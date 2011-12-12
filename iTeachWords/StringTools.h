//
//  StringTools.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/24/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface StringTools : NSObject {
	NSString			*myText;
	NSMutableDictionary *arrayWords;
	NSArray				*arrayWordsSorting;
}

- (void) printString:(NSString *) str;
@property (nonatomic, retain) NSString				*myText;
@property (nonatomic, retain) NSMutableDictionary	*arrayWords;
@property (nonatomic, retain) NSArray				*arrayWordsSorting;

@end
