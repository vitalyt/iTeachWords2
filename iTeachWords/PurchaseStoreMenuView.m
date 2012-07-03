//
//  PurchaseStoreMenuView.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 21.06.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "PurchaseStoreMenuView.h"
#import "SimpleWebViewController.h"
#import "PurchaseImageView.h"
#import "PurchasesDetailViewController.h"

@interface PurchaseStoreMenuView ()

@end

@implementation PurchaseStoreMenuView

- (void)dealloc
{
    [purchasesController release];
    purchasesController = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationItem setLeftBarButtonItem:
     [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeMyself)] autorelease] 
    ];
    
    [self.navigationController.navigationItem setTitle:NSLocalizedString(@"iStudyWords", @"")];
    [self.navigationItem setTitle:NSLocalizedString(@"iStudyWords", @"")];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (IBAction)closeMyself:(id)sender {
    [UIAlertView removeMessage];
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showDetailInfo:(id)sender {
    PurchaseType purchaseType = [self getCurrentPurchaseType];
    PurchasesDetailViewController *infoView = [[PurchasesDetailViewController alloc] initWithPurchaseType:purchaseType];
    [self presentModalViewController:infoView animated:YES];
    [infoView release];
}

- (IBAction)buyAction:(id)sender {
    PurchaseType purchaseType = [self getCurrentPurchaseType];
    if (purchasesController) {
        [[QQQInAppStore sharedStore].storeManager setDelegate:nil];
        [purchasesController release];
        purchasesController = nil;
    }
    purchasesController = [[PurchasesDetailViewController alloc] initWithPurchaseType:purchaseType];
//    [[QQQInAppStore sharedStore].storeManager setDelegate:self];
    if (![MKStoreManager isCurrentItemPurchased:[QQQInAppStore purchaseIDByType:purchaseType]]) {
        [purchasesController buyFuture:nil];
    }
    [[QQQInAppStore sharedStore].storeManager setDelegate:purchasesController];
}

- (PurchaseType)getCurrentPurchaseType{
    int index = [self currentPage];
    if (index>=[sourceData count]) {
        return 0;
    }
    return [[[sourceData objectAtIndex:index] objectForKey:@"purchaseType"] intValue];
}

- (void)loadData{
    if (!sourceData) {
        sourceData = [[NSMutableArray alloc] init];
    }
    NSDictionary *recognizerDict = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Recognizer", @""),@"title",
                                    NSLocalizedString(@"Web Smaller Recognizer Empty Designe", @""),@"fileName",
                                    [NSNumber numberWithInt:VOCALIZER],@"purchaseType",nil];
    NSDictionary *repeatDict = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Repeat", @""),@"title",
                                NSLocalizedString(@"Web Smaller Repetition Empty Designe", @""),@"fileName",
                                [NSNumber numberWithInt:NOTIFICATION],@"purchaseType",nil];
    NSDictionary *exercisesDict = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Exercises", @""),@"title",
                                   NSLocalizedString(@"Web Smaller Education Empty Designe", @""),@"fileName",
                                   [NSNumber numberWithInt:TESTGAME],@"purchaseType",nil];
    NSDictionary *exercisesDict1 = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Exercises", @""),@"title",
                                   NSLocalizedString(@"Web Smaller Education Empty Designe", @""),@"fileName",
                                   [NSNumber numberWithInt:TEST1],@"purchaseType",nil];
    
    [sourceData addObject:recognizerDict];
//    [sourceData addObject:exercisesDict];
    [sourceData addObject:exercisesDict1];
    [sourceData addObject:repeatDict];
    
    [repeatDict release];
    [exercisesDict release];
    [exercisesDict1 release];
    [recognizerDict release];
    
    [super loadData];
}

- (void) addPage:(int)index
{
	pageControl.numberOfPages = pageControl.numberOfPages + 1;
	pageControl.currentPage = pageControl.numberOfPages - 1;
	sv.contentSize = CGSizeMake(pageControl.numberOfPages * self.view.frame.size.width, BASEHEIGHT);
    
    PurchaseImageView *purchaseImageView = [[PurchaseImageView alloc] initWithNibName:@"PurchaseImageView" bundle:nil];    
	[sv addSubview:purchaseImageView.view];    
    [viewStore addObject:purchaseImageView];   
    [purchaseImageView.view setFrame:CGRectMake(pageControl.currentPage * self.view.frame.size.width, 0.0f, self.view.frame.size.width, BASEHEIGHT-40)];   
    [purchaseImageView release];
    if (index == 0) {
        [self loadContentOfPage:index];
    }
    [self.view insertSubview:sv aboveSubview:pageControl];
}


- (void)loadContentOfPage:(int)index{
    if (index<[viewStore count]) {
        PurchaseImageView *purchaseImageView = (PurchaseImageView*)[viewStore objectAtIndex:index];
        if (!purchaseImageView.imageView.image) {
            NSDictionary *dict = [self.sourceData objectAtIndex:index];
            [purchaseImageView.imageView setImage:[UIImage imageNamed:[dict objectForKey:@"fileName"]]];
        }
    }
}

@end
