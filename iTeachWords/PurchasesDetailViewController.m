//
//  PurchasesDetailViewController.m
//  iTeachWords
//
//  Created by admin on 15.02.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "PurchasesDetailViewController.h"
#import "MyUIViewClass.h"
#import "SimpleWebViewController.h"

@implementation PurchasesDetailViewController

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
    if ([QQQInAppStore sharedStore].storeManager.delegate == self) {
        [[QQQInAppStore sharedStore].storeManager setDelegate:nil];
    }
    [buyButton release];
    [super dealloc];
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    if (!buyButton) {
        buyButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    }
    [buyButton setFrame:CGRectMake(20, 410, 280, 37)];
    [buyButton setTitle:NSLocalizedString(@"Buy", @"") forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buyFuture:) forControlEvents:UIControlEventTouchUpInside];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{    
    if ([QQQInAppStore sharedStore].storeManager.delegate == self) {
        [[QQQInAppStore sharedStore].storeManager setDelegate:nil];
    }
    [super viewDidLoad];
    
    CGRect frame = contentView.frame;
    frame.size.height = frame.size.height - 20 - buyButton.frame.size.height;
    [contentView setFrame:frame];
    [[self webView] setFrame:CGRectMake(.0, .0, frame.size.width, frame.size.height)];
    [self loadContentByFile:[self fileNameByPurchaseType:purchaseType]];
//    [self setUrl:[self urlByPurchaseType:purchaseType]];
    
    [self.view addSubview:buyButton];
    [UIAlertView displayMessage:NSLocalizedString(@"Unfortunately, this functionality is not yet available in this version of the program.", @"") title:NSLocalizedString(@"", @"")];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [[QQQInAppStore sharedStore].storeManager setDelegate:nil];
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
    NSString *fullID = [QQQInAppStore purchaseIDByType:purchaseType];
    NSLog(@"%@",fullID);
    if (![MKStoreManager isCurrentItemPurchased:fullID]) {
        [[QQQInAppStore sharedStore].storeManager setDelegate:self];
        [self showLoadingView];
        [[QQQInAppStore sharedStore].storeManager buyFeature:fullID];
    }
}

- (NSString*)urlByPurchaseType:(PurchaseType)_purchaseType{
    switch (_purchaseType) {
        case VOCALIZER:
            return NSLocalizedString(@"http://www.google.ru", @"");
            break;
        case TEST1:
            return NSLocalizedString(@"http://www.yandex.ru", @"");
            break;
        case TESTGAME:
            return NSLocalizedString(@"http://www.en.wikipedia.org/wiki/Forgetting_curve", @"");
            break;
        case NOTIFICATION:
            return NSLocalizedString(@"http://www.en.wikipedia.org/wiki/Forgetting_curve", @"");
            break;
            
        default:
            break;
    }
    return nil;
}

- (NSString*)fileNameByPurchaseType:(PurchaseType)_purchaseType{
    switch (_purchaseType) {
        case VOCALIZER:
            return NSLocalizedString(@"RecognizerInfo", @"");
            break;
        case TEST1:
            return NSLocalizedString(@"ExercisesInfo", @"");
            break;
        case TESTGAME:
            return NSLocalizedString(@"ExercisesInfo", @"");
            break;
        case NOTIFICATION:
            return NSLocalizedString(@"RepeatInfo", @"");
            break;
            
        default:
            break;
    }
    return nil;
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
    [self.view bringSubviewToFront:closeBtn];
}

- (void)hideLoadingView{
    if (loadingView) {
        [loadingView setHidden:YES];
    }
}

#pragma mark MKStoreKitDelegate
- (void)productPurchased{
    NSLog(@"Purchased");
    [self hideLoadingView];
}

- (void)failed{
    NSLog(@"filed");
    [self hideLoadingView];
    
}

@end
