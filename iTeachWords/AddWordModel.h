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
	CustomAlertView				*alert;
	//Variables setup for access in the class:

    WBEngine        *wbEngine;
}

@property (nonatomic, strong) NSString *currentTranslateLanguageCode;
@property (nonatomic, strong) NSString *urlShow;
@property (nonatomic, strong) WordTypes *wordType;
@property (nonatomic, strong) Words     *currentWord;
@property (nonatomic, strong) id        delegate;

//- (id)initWithDelegate:(id)_delegate;
- (void)     createWord;
- (void)     saveWord;
//- (void)     undoChngesWord;
- (void)     createUndoBranch;
- (void)     removeChanges;
- (void)     setWord:(Words *)_word;
- (void)	 createUrls;

- (void)loadTranslateText:(NSString*)text fromLanguageCode:(NSString*)fromLanguageCode toLanguageCode:(NSString*)toLanguageCode withDelegate:(id)_delegate;
@end
