//
//  StringTools.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/24/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StringToolsViewDelegate
@required
-(void)didLoadTranslate:(NSArray*)translate;
@end

@class WBEngine;
@interface StringTools : NSObject {
	NSString			*myText;
	NSMutableDictionary *arrayWords;
	NSArray				*arrayWordsSorting;
    
    WBEngine                *wbEngine;
    id<StringToolsViewDelegate> caller;
}
@property (nonatomic, retain) NSString				*myText;
@property (nonatomic, retain) NSMutableDictionary	*arrayWords;
@property (nonatomic, retain) NSArray				*arrayWordsSorting;

@property(nonatomic, retain) id<StringToolsViewDelegate> caller;


- (void) printString:(NSString *) str;

- (void)loadTranslateForWords:(NSArray*)wordsArray withDelegate:(id)_caller;
- (void)sendRequestWitchText:(NSString*)wordsText;

@end
