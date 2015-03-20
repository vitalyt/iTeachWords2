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

#define textVocalizerID @"qqq.vitalyt.iteachwords.lite.voicerecognizer"
#define testGameID @"qqq.vitalyt.iteachwords.lite.extratestes";
#define notificationID @"qqq.vitalyt.iteachwords.lite.notification";

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
            _sharedInAppStore.costDictionary = [[[NSMutableDictionary alloc] init] autorelease];
            _sharedInAppStore.storeManager = [[[MKStoreManager alloc] initWithFeatureSet:nil] autorelease];
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

@end
