//
//  QQQInAppStore.m
//  iTeachWords
//
//  Created by admin on 11.02.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "QQQInAppStore.h"

@implementation QQQInAppStore
@synthesize storeManager;
@synthesize costDictionary;

static QQQInAppStore* _sharedInAppStore; // self

- (void)dealloc {
    [storeManager release];
    [costDictionary release];
    [_sharedInAppStore release];
    [super dealloc];
}


+ (QQQInAppStore*)sharedStore
{
	@synchronized(self) {
		
        if (_sharedInAppStore == nil) {
            _sharedInAppStore = [[self alloc] init]; // assignment not done here
            
			NSMutableArray *fullIDs = [[NSMutableArray alloc] init];
            [fullIDs addObject: @"qqq.vitalyt.iteachwords.free.textrecognizer"];
            //            [fullIDs addObject: @"com.myBundleIdentifier.f2"];
            _sharedInAppStore.costDictionary = [[NSMutableDictionary alloc] init];
            _sharedInAppStore.storeManager = [[MKStoreManager alloc] initWithFeatureSet:fullIDs];
        }
    }
    return _sharedInAppStore;
}

@end
