//
//  MKStoreManager.m
//
//  Created by Mugunth Kumar on 17-Oct-09.
//  Copyright 2009 Mugunth Kumar. All rights reserved.
//  mugunthkumar.com
//

#import "MKStoreManager.h"

@implementation MKStoreManager

@synthesize purchasableObjects;
@synthesize storeObserver;
@synthesize delegate;

// all your features should be managed one and only by StoreManager
//static NSString *featureAId = @"com.luxuryecards.test2";

//BOOL featureAPurchased;

static MKStoreManager* _sharedStoreManager; // self

- (void)dealloc {
	
	[_sharedStoreManager release];
	[storeObserver release];
	[purchasableObjects release];
	
	[featureAId release];
	[localSet release];
	 
	[super dealloc];
}

- (BOOL) isFeatureAPurchased {
	
	return featureAPurchased;
}

+ (MKStoreManager*)sharedManager
{
	@synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            [[self alloc] init]; // assignment not done here
			_sharedStoreManager.purchasableObjects = [[NSMutableArray alloc] init];			
			[_sharedStoreManager requestProductData];
			
//			[MKStoreManager loadPurchases];
			_sharedStoreManager.storeObserver = [[MKStoreObserver alloc] init];
			[[SKPaymentQueue defaultQueue] addTransactionObserver:_sharedStoreManager.storeObserver];
        }
    }
    return _sharedStoreManager;
}

- (id)initWithFeatureSet:(NSArray *)featureArray {
	if([self init]) {
		localSet = [[NSSet alloc] initWithArray:featureArray];
		featureAId = [[NSString alloc] initWithString:@"qqq.vitalyt.iteachwords.free.textrecognizer"];
		purchasableObjects = [[NSMutableArray alloc] init];
		[self requestProductData];
		
		storeObserver = [[MKStoreObserver alloc] init];
		[[SKPaymentQueue defaultQueue] addTransactionObserver:storeObserver];
		
	}
	return self;	
}

#pragma mark Singleton Methods

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_sharedStoreManager == nil) {
			
            _sharedStoreManager = [super allocWithZone:zone];			
            return _sharedStoreManager;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
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


- (void) requestProductData
{
	SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:localSet];
								 
	request.delegate = self;
	[request start];
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	[purchasableObjects addObjectsFromArray:response.products];
    NSLog(@"%@",purchasableObjects);
	// populate your UI Controls here
	for(int i=0;i<[purchasableObjects count];i++)
	{
		NSLog(@"%@",request);
        NSLog(@"%@",response.invalidProductIdentifiers);
		SKProduct *product = [purchasableObjects objectAtIndex:i];
		
		NSString *costValue = [NSString stringWithFormat:@"%f", [[product price] doubleValue]];
        NSLog(@"%@",costValue);
		NSNumberFormatter *numberFormatter = [[[NSNumberFormatter alloc] init] autorelease];
		[numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
		[numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
		[numberFormatter setLocale:product.priceLocale];
		NSString *formattedString = [numberFormatter stringFromNumber:product.price];
        NSLog(@"%@",formattedString);
		//save localized cost
		//...................
        
//        MyProjectAppDelegate *appDelegate = (MyProjectAppDelegate *)[[UIApplication sharedApplication] delegate];
//        //localized cost
//        [[appDelegate costDictionary] setObject:formattedString forKey:[product productIdentifier]]; //costDictionary is an NSMutableDictionary object, declared in AppDelegate.h
        
	}
	
	[request autorelease];
}

- (void) buyFeature:(NSString*) featureId
{
	featureAId = [[NSString alloc] initWithString:featureId];
	if ([SKPaymentQueue canMakePayments])
	{
		SKPayment *payment = [SKPayment paymentWithProductIdentifier:featureId];
		[[SKPaymentQueue defaultQueue] addPayment:payment];
	}
	else
	{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wishing Well" message:@"You are not authorized to purchase from AppStore"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];
		[alert release];
        if([delegate respondsToSelector:@selector(failed)])
            [delegate failed];
	}
}

-(void)paymentCanceled
{
	NSLog(@"paymentCanceled");
	if([delegate respondsToSelector:@selector(failed)])
		[delegate failed];
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction
{
	if([delegate respondsToSelector:@selector(failed)])
		[delegate failed];
	
	NSString *messageToBeShown = [NSString stringWithFormat:@"Reason: %@, You can try: %@", [transaction.error localizedFailureReason], [transaction.error localizedRecoverySuggestion]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to complete your purchase" message:messageToBeShown
												   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}

-(void) provideContent: (NSString*) productIdentifier
{
	if([productIdentifier isEqualToString:featureAId])
	{
		featureAPurchased = YES;
		if([delegate respondsToSelector:@selector(productPurchased)])
			[delegate productPurchased];
	}
	
	[self updatePurchases];
}


- (void) loadPurchases 
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	featureAPurchased = [userDefaults boolForKey:featureAId]; 	
}

- (void) updatePurchases
{
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setBool:featureAPurchased forKey:featureAId];
}

+ (BOOL)isCurrentItemPurchased: (NSString *)itemID {
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];	
	BOOL isPurchased = [userDefaults boolForKey:itemID];
	return isPurchased;
}

@end
