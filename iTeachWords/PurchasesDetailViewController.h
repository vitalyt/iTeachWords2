//
//  PurchasesDetailViewController.h
//  iTeachWords
//
//  Created by admin on 15.02.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "InfoViewController.h"
#import "DetailViewController.h"

#ifdef FREE_VERSION
#import "MKStoreManager.h"
#endif

typedef enum {
	VOCALIZER = 0,
	TEST1,
    TESTGAME,
    NOTIFICATION
}PurchaseType;

@interface PurchasesDetailViewController : DetailViewController<
#ifdef FREE_VERSION
MKStoreKitDelegate
#endif
>
{
    UIButton    *buyButton;
    UIView      *loadingView;
    PurchaseType purchaseType;
}

- (id)initWithPurchaseType:(PurchaseType)_purchaseType;

- (IBAction)buyFuture:(id)sender;

- (void)showLoadingView;
- (void)hideLoadingView;
@end
