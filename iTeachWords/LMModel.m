//
//  LMModel.m
//  MenuItemTesting
//
//  Created by Vitaly Todorovych on 3/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "LMModel.h"
#import "SynthesizeSingleton.h"

@implementation LMModel


@synthesize wordsStore;

-(id) init {
	if ([super init]) {
        wordsStore = [[NSMutableArray alloc] init];
	}
	return self;
}
/*
static LMModel *sharedLMModel = nil; 

+ (LMModel *)sharedLMModel 
{ 
	@synchronized(self) 
	{ 
		if (sharedLMModel == nil) 
		{ 
			sharedLMModel = [[self alloc] init]; 
		} 
	} 
    
	return sharedLMModel; 
}
*/

@end
