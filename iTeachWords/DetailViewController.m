//
//  DetailViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/16/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "DetailViewController.h"
#import "WebViewController.h"
#import "MyUIViewClass.h"
#import "SimpleWebViewController.h"

@implementation DetailViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showWebView];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // grab an image of our parent view
//    UIView *parentView = self.parentViewController.view;
    
    // For iOS 5 you need to use presentingViewController:
    // UIView *parentView = self.presentingViewController.view;
    
//    UIGraphicsBeginImageContext(parentView.bounds.size);
//    [parentView.layer renderInContext:UIGraphicsGetCurrentContext()];
//    UIImage *parentViewImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    // insert an image view with a picture of the parent view at the back of our view's subview stack...
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, parentView.bounds.size.width, parentView.bounds.size.height)];
//    imageView.image = parentViewImage;
    //[self.view insertSubview:imageView atIndex:0];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    //[imageView release];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // remove our image view containing a picture of the parent view at the back of our view's subview stack...
    [[self.view.subviews objectAtIndex:0] removeFromSuperview];
}


- (void)viewDidUnload
{
    [contentView release];
    contentView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showWebView{
    CGRect webViewFrame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    if (!webView) {
        webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    }
    [contentView addSubview:webView];
    [webView setFrame:webViewFrame];
}

- (IBAction)close:(id)sender{
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
    [contentView release];
    [super dealloc];
}
@end
