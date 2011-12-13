//
//  AddWordModel.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/8/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WordTypes,Words;

@interface AddWordModel : NSObject {
    NSString				*url;
	NSString				*urlShow; 
	BOOL					isNeedToSave;
	UIAlertView				*alert;
	//Variables setup for access in the class:
    WordTypes               *wordType;
    Words                   *currentWord;
}

@property (nonatomic, retain) NSString *url,*urlShow;
@property (nonatomic, retain) WordTypes *wordType;
@property (nonatomic, retain) Words     *currentWord;

- (void)     createWord;
- (void)     saveWord;
- (void)     undoChngesWord;
- (void)     setWord:(Words *)_word;
- (void)	 createUrls;

@end
