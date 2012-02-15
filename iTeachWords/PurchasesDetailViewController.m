//
//  PurchasesDetailViewController.m
//  iTeachWords
//
//  Created by admin on 15.02.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "PurchasesDetailViewController.h"
#import "MyUIViewClass.h"

#ifdef FREE_VERSION
#import "QQQInAppStore.h"
#endif


@implementation PurchasesDetailViewController

//const NSString *

- (id)initWithPurchaseType:(PurchaseType)_purchaseType {
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    if (self) {
        purchaseType = _purchaseType;
    }
    return self;
}

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

- (void)dealloc {
    [buyButton release];
    [super dealloc];
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    buyButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 410, 280, 37)];
    [buyButton setTitle:NSLocalizedString(@"Buy", @"") forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyFuture:) forControlEvents:UIControlEventTouchUpInside];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:buyButton];    
    CGRect frame = contentView.frame;
    frame.size.height = frame.size.height - 20 - buyButton.frame.size.height;
    [contentView setFrame:frame];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [buyButton release];
    buyButton = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)buyFuture:(id)sender{
#ifdef FREE_VERSION
    NSString *fullID = @"qqq.vitalyt.iteachwords.free.test1";
    if (![MKStoreManager isCurrentItemPurchased:fullID]) {
        [[QQQInAppStore sharedStore].storeManager setDelegate:self];
        [self showLoadingView];
        [[QQQInAppStore sharedStore].storeManager buyFeature:fullID];
        return;
    }
#endif
}


#pragma mark showing view

- (void)showLoadingView{
    //    UIActivityIndicatorView *activityIndicatorView;
    if (!loadingView) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        loadingView = [[UIView alloc] initWithFrame:frame];
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicatorView setFrame:CGRectMake(frame.size.width/2-10, frame.size.height/2-10, 20, 20)];
        [loadingView addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        [activityIndicatorView release];
        [self.view addSubview:loadingView];
        [loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    }
    [loadingView setHidden:NO];
}

- (void)hideLoadingView{
    if (loadingView) {
        [loadingView setHidden:YES];
    }
}

#ifdef FREE_VERSION
#pragma mark MKStoreKitDelegate
- (void)productPurchased{
    NSLog(@"Purchased");
    [self hideLoadingView];
}

- (void)failed{
    NSLog(@"filed");
    [self hideLoadingView];
    
}
#endif

@end
