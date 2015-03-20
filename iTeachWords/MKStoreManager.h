//
//  StoreManager.h
//  MKSync
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 MK Inc. All rights reserved.
//  mugunthkumar.com

#import <StoreKit/StoreKit.h>

@class MKStoreObserver;
@protocol MKStoreKitDelegate <NSObject>
@optional
- (void)productPurchased;
- (void)failed;
@end

@interface MKStoreManager : NSObject<SKProductsRequestDelegate> {

	NSMutableArray *purchasableObjects;
	MKStoreObserver *storeObserver;	

	id<MKStoreKitDelegate> delegate;
	
	NSString *featureAId;
	NSSet *localSet;
	BOOL featureAPurchased;
}

@property (nonatomic, weak) id<MKStoreKitDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *purchasableObjects;
@property (nonatomic, retain) MKStoreObserver *storeObserver;

- (void) requestProductData;

- (void) buyFeature:(NSString*) featureId;

-(void)paymentCanceled;

- (void) failedTransaction: (SKPaymentTransaction *)transaction;
-(void) provideContent: (NSString*) productIdentifier;

+ (MKStoreManager*)sharedManager;

- (BOOL) isFeatureAPurchased; //ex +

- (void) loadPurchases; //+
- (void) updatePurchases; //+

- (id)initWithFeatureSet:(NSArray *)featureSet;

+ (BOOL)isCurrentItemPurchased: (NSString *)itemID;

@end
