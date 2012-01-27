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

- (void)dealloc {
    [pagingScrollView release];
    [pageControl release];
    [super dealloc];
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
    pagingScrollView.backgroundColor = [UIColor blackColor];
    pagingScrollView.showsVerticalScrollIndicator = NO;
    pagingScrollView.showsHorizontalScrollIndicator = NO;
    pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    pagingScrollView.delegate = self;
    [self.view addSubview:pagingScrollView];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(.0, pagingScrollViewFrame.size.height-36*2/3, pagingScrollViewFrame.size.width, 36)];
	[pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    [self.view bringSubviewToFront:pageControl];
    [pageControl setNumberOfPages:[self contentDataCount]];
    [pageControl setCurrentPage:1];
    [self pageTurn:pageControl];

    // Step 2: prepare to tile content
    recycledPages = [[NSMutableSet alloc] init];
    visiblePages  = [[NSMutableSet alloc] init];
    
    [self tilePages];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    [pagingScrollView release];
    pagingScrollView = nil;
    [pageControl release];
    pageControl = nil;
    [recycledPages release];
    recycledPages = nil;
    [visiblePages release];
    visiblePages = nil;
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
}
#pragma mark -
#pragma mark ScrollView delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    [self tilePages];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    CGRect visibleBounds = pagingScrollView.bounds;
    int numberOfPage = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds));
    [pageControl setCurrentPage:numberOfPage];
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
    lastNeededPageIndex  = MIN(lastNeededPageIndex, [self contentDataCount] - 1);
    
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
                page = [[[ButtonView alloc] initWithNibName:@"ButtonView" bundle:nil] autorelease];
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
        [[page retain] autorelease];
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
    
    // Use tiled images
//    [page displayTiledImageNamed:[self imageNameAtIndex:index] size:[self imageSizeAtIndex:index]];
    
    // To use full images instead of tiled images, replace the "displayTiledImageNamed:" call
    // above by the following line:
    [page changeButtonImage:[self imageButtonAtIndex:index]];
}

#pragma mark -
#pragma mark  Frame calculations
#define PADDING  0
#define HEIGHT 80

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
    return CGSizeMake((bounds.size.width * ((float)[self contentDataCount])), bounds.size.height);
}

#pragma mark -
#pragma mark Content wrangling

- (NSArray*)contentData{
    static NSArray *_contentData = nil;
    if (_contentData == nil) {
        NSDictionary *object = [NSDictionary dictionaryWithObjectsAndKeys:@"siri-icon1",@"name", nil];
        NSDictionary *object1 = [NSDictionary dictionaryWithObjectsAndKeys:@"siri-icon",@"name", nil];
       // NSDictionary *object2 = [NSDictionary dictionaryWithObjectsAndKeys:@"siri-icon1",@"name", nil];
        _contentData = [[NSArray alloc] initWithObjects:object,object1, nil];
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
    return _name;
}


- (UIImage *)imageButtonAtIndex:(NSUInteger)index {
    // use "imageWithContentsOfFile:" instead of "imageNamed:" here to avoid caching our images
    NSString *imageName = [self countDataImageNameAtIndex:index];
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:path];    
}

@end
