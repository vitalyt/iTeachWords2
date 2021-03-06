//
//  PurchaseStoreMenuView.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 21.06.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagesViewController.h"
#import "QQQInAppStore.h"

@class PurchasesDetailViewController;
@interface PurchaseStoreMenuView : PagesViewController{
    PurchasesDetailViewController *purchasesController;
}

- (IBAction)closeMyself:(id)sender;
- (IBAction)showDetailInfo:(id)sender;
- (IBAction)buyAction:(id)sender;

- (PurchaseType)getCurrentPurchaseType;

@end
