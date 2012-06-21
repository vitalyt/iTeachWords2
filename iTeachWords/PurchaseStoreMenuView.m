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
    [self.navigationController.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeMyself)]];
    
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
    [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)buyAction:(id)sender {
    PurchaseType purchaseType;
    int index = [self currentPage];
    switch (index) {
        case 0:
            purchaseType = VOCALIZER;
            break;
        case 1:
            purchaseType = TESTGAME;
            break;
        case 2:
            purchaseType = NOTIFICATION;
            break;
            
        default:
            break;
    }
    if (!purchasesController) {
        [purchasesController release];
    }
    purchasesController = [[PurchasesDetailViewController alloc] initWithPurchaseType:purchaseType];
    
    if (![MKStoreManager isCurrentItemPurchased:[QQQInAppStore purchaseIDByType:purchaseType]]) {
        [purchasesController buyFuture:nil];
    }
}

- (void)showPurchaseInfoView{
    PurchasesDetailViewController *infoView = [[PurchasesDetailViewController alloc] initWithPurchaseType:NOTIFICATION];
    [self.navigationController presentModalViewController:infoView animated:YES];
    [infoView release];
}
- (void)loadData{
    if (!sourceData) {
        sourceData = [[NSMutableArray alloc] init];
    }
    NSDictionary *recognizerDict = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Repeat", @""),@"title",
                                NSLocalizedString(@"Recognizer Empty Designe", @""),@"fileName",nil];
    NSDictionary *repeatDict = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Exercises", @""),@"title",
                                   NSLocalizedString(@"Repetition Empty Designe", @""),@"fileName",nil];
    NSDictionary *exercisesDict = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"Recognizer", @""),@"title",
                                   NSLocalizedString(@"Education Empty Designe", @""),@"fileName",nil];
    
    [sourceData addObject:recognizerDict];
    [sourceData addObject:exercisesDict];
    [sourceData addObject:repeatDict];
    
    [repeatDict release];
    [exercisesDict release];
    [recognizerDict release];
    
    [super loadData];
}

- (void) addPage:(int)index
{
	pageControl.numberOfPages = pageControl.numberOfPages + 1;
	pageControl.currentPage = pageControl.numberOfPages - 1;
	sv.contentSize = CGSizeMake(pageControl.numberOfPages * self.view.frame.size.width, BASEHEIGHT);
    
    PurchaseImageView *purchaseImageView = [[PurchaseImageView alloc] initWithNibName:@"PurchaseImageView" bundle:nil];    
    
//    CGRect frame = CGRectMake(0, 0, 320, BASEHEIGHT-40);
//    SimpleWebViewController *webViewController = [[SimpleWebViewController alloc] initWithFrame:frame];
//    NSDictionary *dict = [self.sourceData objectAtIndex:index];
//    webViewController.title = [dict objectForKey:@"title"];
    
	[sv addSubview:purchaseImageView.view];    
    [viewStore addObject:purchaseImageView];   
    [purchaseImageView.view setFrame:CGRectMake(pageControl.currentPage * self.view.frame.size.width, 0.0f, self.view.frame.size.width, BASEHEIGHT-40)];   
//    [webViewController.view setFrame:CGRectMake(pageControl.currentPage * self.view.frame.size.width, 0.0f, self.view.frame.size.width, BASEHEIGHT-40)];
//    [webViewController release];
    [purchaseImageView release];
    if (index == 0) {
        [self loadContentOfPage:index];
    }
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
