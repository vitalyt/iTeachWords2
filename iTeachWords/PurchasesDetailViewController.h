//
//  PurchasesDetailViewController.h
//  iTeachWords
//
//  Created by admin on 15.02.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

//#import <UIKit/UIKit.h>
//#import "InfoViewController.h"
#import "DetailViewController.h"
#import "MKStoreManager.h"
#import "QQQInAppStore.h"


@interface PurchasesDetailViewController : DetailViewController
<MKStoreKitDelegate>
{
    UIButton    *buyButton;
    UIView      *loadingView;
    PurchaseType purchaseType;
}

- (id)initWithPurchaseType:(PurchaseType)_purchaseType;
- (IBAction)buyFuture:(id)sender;
- (NSString*)urlByPurchaseType:(PurchaseType)_purchaseType;

- (void)showLoadingView;
- (void)hideLoadingView;
@end
