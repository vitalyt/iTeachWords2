//
//  AddWordModel.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/8/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoadingTranslateProtocol <NSObject>

- (void)translateDidLoad:(NSString *)translateText byLanguageCode:(NSString*)_activeTranslateLanguageCode;

@end

@class WordTypes,Words,WBEngine;

@interface AddWordModel : NSObject {
	NSString				*urlShow; 
	BOOL					isNeedToSave;
	UIAlertView				*alert;
	//Variables setup for access in the class:
    WordTypes               *wordType;
    Words                   *currentWord;
    
    NSString        *currentTranslateLanguageCode;
    WBEngine        *wbEngine;
    id              delegate;
}

@property (nonatomic, retain) NSString *urlShow;
@property (nonatomic, retain) WordTypes *wordType;
@property (nonatomic, retain) Words     *currentWord;
@property (nonatomic, retain) id        delegate;

//- (id)initWithDelegate:(id)_delegate;
- (void)     createWord;
- (void)     saveWord;
- (void)     undoChngesWord;
- (void)     setWord:(Words *)_word;
- (void)	 createUrls;

- (void)loadTranslateText:(NSString*)text fromLanguageCode:(NSString*)fromLanguageCode toLanguageCode:(NSString*)toLanguageCode withDelegate:(id)_delegate;
@end
