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

#import "SocialSharingViewController.h"

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
    [self showSocialSaringView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [self showSocialSaringView];
    //[imageView release];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // remove our image view containing a picture of the parent view at the back of our view's subview stack...
    [[self.view.subviews objectAtIndex:0] removeFromSuperview];
}


- (void)viewDidUnload
{
    [[self getScrollViewFromWebView:[self webView]] setDelegate:nil];
    [contentView release];
    contentView = nil;
    [closeBtn release];
    closeBtn = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (UIScrollView *)getScrollViewFromWebView: (UIWebView*) webView {
    UIScrollView *scrollView = nil;
    
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending) {
        return webView.scrollView;
    }
    else {
        for (UIView *subview in [webView subviews]) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                scrollView = (UIScrollView *)subview;
            }
        }
        
        if (scrollView == nil) {
            NSLog(@"Couldn’t get default scrollview!");
        }
    }
    return scrollView;
}

- (void)showWebView{
    CGRect webViewFrame = CGRectMake(0, 0, contentView.frame.size.width, contentView.frame.size.height);
    [contentView addSubview:[self webView]];
    [[self getScrollViewFromWebView:[self webView]] setDelegate:self];
    [[self webView] setFrame:webViewFrame];
    [self webView].opaque = NO;
    [self webView].backgroundColor = [UIColor clearColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:webViewFrame];
    imageView.image = [UIImage imageNamed:@"Web Empty Designe"];
    imageView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.frame = [self webView].bounds;
    [[self webView] insertSubview:imageView atIndex:0];
}

- (IBAction)close:(id)sender{
    
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]];
//    [self.navigationController ];
    [self dismissModalViewControllerAnimated:YES];
}

- (void)showSocialSaringView{
    if (!socialSharingViewController) {
        socialSharingViewController = [[SocialSharingViewController alloc] initWithNibName:@"SocialSharingViewController" bundle:nil];
    }
    [socialSharingViewController.view setHidden:YES];
    [socialSharingViewController setDelegate:self];
    [self.view addSubview:socialSharingViewController.view];
    [socialSharingViewController.view setFrame:CGRectMake(198, (contentView.frame.origin.y+contentView.frame.size.height)-socialSharingViewController.view.frame.size.height, socialSharingViewController.view.frame.size.width, socialSharingViewController.view.frame.size.height)];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>10) {
        [socialSharingViewController.view setHidden:NO];
    }else {
        [socialSharingViewController.view setHidden:YES];
    }
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
    [socialSharingViewController.view setHidden:YES];
    
}

- (void)dealloc {
    if (socialSharingViewController) {
        [socialSharingViewController release];
        socialSharingViewController = nil;
    }
    [contentView release];
    [closeBtn release];
    [super dealloc];
}
@end
