//
//  QQQInAppStore.h
//  iTeachWords
//
//  Created by admin on 11.02.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	VOCALIZER = 0,
    TESTGAME,
    NOTIFICATION
}PurchaseType;

@class MKStoreManager;
@interface QQQInAppStore : NSObject
{
    MKStoreManager      *storeManager;
    NSMutableDictionary *costDictionary;
}

@property (nonatomic,retain) MKStoreManager *storeManager;
@property (nonatomic,retain) NSMutableDictionary *costDictionary;

+ (NSString*)purchaseIDByType:(PurchaseType)_purchaseType;
+ (QQQInAppStore*)sharedStore;

@end
