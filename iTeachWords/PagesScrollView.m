//
//  PagesScrollView.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/26/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "PagesScrollView.h"
//#import "BaseScrollView.h"
#import "ButtonView.h"


@implementation PagesScrollView

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        
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

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    // Step 1: make the outer paging scroll view
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    pagingScrollView.pagingEnabled = YES;
//    pagingScrollView.backgroundColor = [UIColor blackColor];
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    pagingScrollView.delegate = self;
    [self.view addSubview:pagingScrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(.0, -20*2/3, pagingScrollViewFrame.size.width, 20)];
	[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    [self.view bringSubviewToFront:pageControl];
    [pageControl setNumberOfPages:[self contentDataCount]+1];
    [pageControl setCurrentPage:1];
    prevPage = 1;

    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
    
    [self pageTurn:pageControl];
//    [self tilePages];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark CageScroll delegate methods

- (void) pageTurn: (UIPageControl *) aPageControl
{
	int whichPage = aPageControl.currentPage;
	pagingScrollView.contentOffset = CGPointMake(self.view.frame.size.width * whichPage, 0.0f);
    [self scrollViewDidEndDecelerating:pagingScrollView];
}
#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGRect visibleBounds = pagingScrollView.bounds;
    int numberOfPage = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    pageControl.currentPage = 1;
    if (numberOfPage == 1) {
        return;
    }
    
    NSDictionary *obj0 = [[self contentData] objectAtIndex:0];
    NSDictionary *obj1 = [[self contentData] objectAtIndex:1];
    [[self contentData] insertObject:obj0 atIndex:1];
    [[self contentData] insertObject:obj1 atIndex:0];
    
    for (UIView *view in pagingScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    int whichPage = pageControl.currentPage;
    pagingScrollView.contentOffset = CGPointMake(self.view.frame.size.width * whichPage, 0.0f);
    [self tilePages];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"scrollImageWasShowed"];
}

#pragma mark -
#pragma mark Tiling and page configuration

- (void)tilePages 
{
    // Calculate which pages are visible
    CGRect visibleBounds = pagingScrollView.bounds;
    
    int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    int lastNeededPageIndex  = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    
    firstNeededPageIndex = MAX(firstNeededPageIndex, 0);
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self contentDataCount] );
    pageControl.currentPage = lastNeededPageIndex;
    
    // Recycle no-longer-visible pages 
    for (ButtonView *page in visiblePages) {
        if (page.index < firstNeededPageIndex || page.index > lastNeededPageIndex) {
            [recycledPages addObject:page];
            [page.view removeFromSuperview];
        }
    }
    [visiblePages minusSet:recycledPages];
    // add missing pages
    
    for (int index = firstNeededPageIndex; index <= lastNeededPageIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            ButtonView *page = [self dequeueRecycledPage];
            if (page == nil) { 
                page = [[ButtonView alloc] initWithNibName:@"ButtonView" bundle:nil];
                [page setDelegate:delegate];
            }
            [self configurePage:page forIndex:index];
            [pagingScrollView addSubview:page.view];
            [visiblePages addObject:page];
        }
    }   
}

- (ButtonView *)dequeueRecycledPage
{
    ButtonView *page = [recycledPages anyObject];
    if (page) {
        [recycledPages removeObject:page];
    }
    return page;
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index
{
    BOOL foundPage = NO;
    for (ButtonView *page in visiblePages) {
        if (page.index == index) {
            foundPage = YES;
            break;
        }
    }
    return foundPage;
}

- (void)configurePage:(ButtonView *)page forIndex:(NSUInteger)index
{
    page.index = index;
    page.view.frame = [self frameForPageAtIndex:index];
    
    if (index==[self contentDataCount]) {
        index = 0;
    }
    NSDictionary *element = [[self contentData] objectAtIndex:index];
    [page setType:[[element objectForKey:@"type"] integerValue]];

    // Use tiled images
//    [page displayTiledImageNamed:[self imageNameAtIndex:index] size:[self imageSizeAtIndex:index]];
    
    // To use full images instead of tiled images, replace the "displayTiledImageNamed:" call
    // above by the following line:
    [page changeButtonImage:[self imageButtonAtIndex:index]];
}

#pragma mark -
#pragma mark  Frame calculations
#define PADDING  0
#define HEIGHT 60

- (CGRect)frameForPagingScrollView {
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.height = HEIGHT;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.size.height = HEIGHT;
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = pagingScrollView.bounds;
    return CGSizeMake((bounds.size.width * ((float)[self contentDataCount]+1)), bounds.size.height);
}

#pragma mark -
#pragma mark Content wrangling

- (NSMutableArray*)contentData{
    static NSMutableArray *_contentData = nil;
    if (_contentData == nil) {
        NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:@"micIcon2",@"name",[NSNumber numberWithInt:0],@"type", nil];
        NSDictionary *object1 = [NSDictionary dictionaryWithObjectsAndKeys:@"voiceIcon2",@"name",[NSNumber numberWithInt:1],@"type", nil];
        _contentData = [[NSMutableArray alloc] initWithObjects:object1,object, nil];
    }
    return _contentData;
}

- (NSInteger)contentDataCount{
    static NSInteger _count = NSNotFound;// only count the content once
    if (_count == NSNotFound) {
        _count = [[self contentData] count];
    }
    return _count;
}

- (NSString*)countDataImageNameAtIndex:(NSInteger)index{
    NSString *_name = nil;
    if (index<[self contentDataCount]) {
        NSDictionary *element = [[self contentData] objectAtIndex:index];
        _name = [element objectForKey:@"name"];
    }
    NSLog(@"%@",_name);
    return _name;
}


- (UIImage *)imageButtonAtIndex:(NSUInteger)index {
    // use "imageWithContentsOfFile:" instead of "imageNamed:" here to avoid caching our images
    NSString *imageName = [self countDataImageNameAtIndex:index];
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];    
}

@end
