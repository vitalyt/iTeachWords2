//
//  BannerTableViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 11/28/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "BannerTableViewController.h"

@implementation BannerTableViewController

@synthesize bannerIsVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)createBunnerView{
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.frame = CGRectOffset(adView.frame, 0, -adView.frame.size.height);
    adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifier320x50];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
    [self.view addSubview:adView];
    adView.delegate=self;
    self.bannerIsVisible=NO;
}

- (void)viewDidUnload
{
    if (adView) {
        adView.delegate = nil;
        [adView release];
    }
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark ADBannerView

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height+table.tableHeaderView.frame.size.height);
        UIView *headerVeiw = table.tableHeaderView;
        [headerVeiw setFrame:CGRectMake(0, 0, table.tableHeaderView.frame.size.width, table.tableHeaderView.frame.size.height+banner.frame.size.height)];
        [table setTableHeaderView:headerVeiw];
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height-table.tableHeaderView.frame.size.height);
        UIView *headerVeiw = table.tableHeaderView;
        [headerVeiw setFrame:CGRectMake(0, 0, table.tableHeaderView.frame.size.width, table.tableHeaderView.frame.size.height-banner.frame.size.height)];
        [table setTableHeaderView:headerVeiw];
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

@end
