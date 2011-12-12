//
//  BannerTableViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 11/28/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "TableViewController.h"
#import <iAd/iAd.h>

@interface BannerTableViewController : TableViewController <ADBannerViewDelegate>{
    ADBannerView *adView;
    BOOL bannerIsVisible;
}

@property (nonatomic,assign) BOOL bannerIsVisible;

- (void)createBunnerView;
@end
