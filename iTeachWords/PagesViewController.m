//
//  TipsViewController.m
//  ABN op reis
//
//  Created by Vitaly Todorovych on 3/25/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "PagesViewController.h"
#import "SimpleWebViewController.h"

@implementation PagesViewController

@synthesize viewStore,sourceData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sourceData = [[NSMutableArray alloc] init];
        viewStore = [[NSMutableArray alloc] init];
    }
    return self;
}
- (void)dealloc
{
//    [sourceFiles release];
    [viewStore removeAllObjects];
    [viewStore release];
    [sourceData release];
    [sv release];
    sv = nil;
    [super dealloc];
}

- (void) setPageNum:(int)num{
    sv.contentOffset = CGPointMake(self.view.frame.size.width * num, 0.0f);
    pageControl.currentPage = num;
    [self loadContentOfPage:num];
}

- (void)loadContentOfPage:(int)index{
    if (index<[viewStore count]) {
        SimpleWebViewController *webViewController = (SimpleWebViewController*)[viewStore objectAtIndex:index];
        if (!webViewController.url) {
            NSDictionary *dict = [self.sourceData objectAtIndex:index];
            [webViewController loadContentByFile:[dict objectForKey:@"1"]];
        }
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    
//    [sv setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, BASEHEIGHT)];
//    sv.contentSize = CGSizeMake(pageControl.numberOfPages * self.view.frame.size.width, BASEHEIGHT);
//    
//    for(int i =0; i<[viewStore count]; i++){
//        SimpleWebViewController *webView = [viewStore objectAtIndex:i];
//        [webView.view setFrame:CGRectMake(i * self.view.frame.size.width, webView.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
//    }
//	[sv setContentOffset:CGPointMake((pageControl.currentPage * self.view.frame.size.width), sv.frame.origin.y)];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	srandom(time(0));
}

- (void) loadData{	// Create the scroll view and set its content size and delegate

    if (!sv) {
        sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 44.0f, self.view.frame.size.width, BASEHEIGHT)] ;
    }
	sv.contentSize = CGSizeZero;
	sv.pagingEnabled = YES;
	sv.delegate = self;
	[self.view addSubview:sv];
    
	pageControl.numberOfPages = 0;
	[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
  	// Load in all the pages
    for (int i = 0; i < [sourceData count]; i++) [self addPage:i]; 
    
	pageControl.currentPage = 0;
	[self.view bringSubviewToFront:pageControl];
	[pageControl.superview bringSubviewToFront:pageControl];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark - Tips view functions

- (void) pageTurn: (UIPageControl *) aPageControl
{
	int whichPage = aPageControl.currentPage;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	sv.contentOffset = CGPointMake(self.view.frame.size.width * whichPage, 0.0f);
	[UIView commitAnimations];
    int index = pageControl.currentPage;
    [self loadContentOfPage:index];
}

- (void) scrollViewDidScroll: (UIScrollView *) aScrollView
{
	CGPoint offset = aScrollView.contentOffset;
	pageControl.currentPage = offset.x / self.view.frame.size.width;
}

- (int)currentPage{
    CGPoint offset = sv.contentOffset;
	pageControl.currentPage = offset.x / self.view.frame.size.width;
    int index = pageControl.currentPage;
    return index;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView{
    [self loadContentOfPage:[self currentPage]];
}

- (UIColor *)randomColor
{
	float red = (64 + (random() % 191)) / 256.0f;
	float green = (64 + (random() % 191)) / 256.0f;
	float blue = (64 + (random() % 191)) / 256.0f;
	return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}


- (void) addPage:(int)index
{
	pageControl.numberOfPages = pageControl.numberOfPages + 1;
	pageControl.currentPage = pageControl.numberOfPages - 1;
	sv.contentSize = CGSizeMake(pageControl.numberOfPages * self.view.frame.size.width, BASEHEIGHT);
    
    SimpleWebViewController *webViewController = [[SimpleWebViewController alloc] init];
    NSDictionary *dict = [self.sourceData objectAtIndex:index];
    NSLog(@"%@",dict);
    webViewController.title = [dict objectForKey:@"title"];
	[sv addSubview:webViewController.view];    
    [viewStore addObject:webViewController];    
    [webViewController.view setFrame:CGRectMake(pageControl.currentPage * self.view.frame.size.width, 0.0f, self.view.frame.size.width, BASEHEIGHT)];
    [webViewController release];
}


@end
