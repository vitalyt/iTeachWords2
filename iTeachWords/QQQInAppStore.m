//
//  QQQInAppStore.m
//  iTeachWords
//
//  Created by admin on 11.02.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "QQQInAppStore.h"
#import "MKStoreManager.h"

@implementation QQQInAppStore
@synthesize storeManager;
@synthesize costDictionary;

#define textVocalizerID @"qqq.vitalyt.iteachwords.free.textrecognizer"
#define test1ID @"qqq.vitalyt.iteachwords.free.test1";
#define testGameID @"qqq.vitalyt.iteachwords.free.testGame";
#define notificationID @"qqq.vitalyt.iteachwords.free.notification";

static QQQInAppStore* _sharedInAppStore; // self

- (void)dealloc {
    [_sharedInAppStore release];
    self.storeManager = nil;
    self.costDictionary = nil;
    [super dealloc];
}


+ (QQQInAppStore*)sharedStore
{
	@synchronized(self) {
		
        if (_sharedInAppStore == nil) {
            _sharedInAppStore = [[self alloc] init]; // assignment not done here
            
//			NSMutableArray *fullIDs = [[NSMutableArray alloc] init];
//            [fullIDs addObject: @"qqq.vitalyt.iteachwords.free.textGame"];
            //            [fullIDs addObject: @"com.myBundleIdentifier.f2"];
            _sharedInAppStore.costDictionary = [[NSMutableDictionary alloc] init];
            _sharedInAppStore.storeManager = [[MKStoreManager alloc] initWithFeatureSet:nil];
//            [_sharedInAppStore.storeManager setDelegate:_sharedInAppStore];
//            [fullIDs release];
        }
    }
    return _sharedInAppStore;
}

+ (NSString*)purchaseIDByType:(PurchaseType)_purchaseType{
    switch (_purchaseType) {
        case VOCALIZER:
            return textVocalizerID;
            break;
        case TEST1:
            return test1ID;
            break;
        case TESTGAME:
            return testGameID;
            break;
        case NOTIFICATION:
            return notificationID;
            break;
            
        default:
            break;
    }
    return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (id)autorelease
{
    return self;	
}

@end
