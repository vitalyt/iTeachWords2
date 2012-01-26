//
//  PagesScrollView.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/26/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ButtonView;

@interface PagesScrollView : UIViewController<UIScrollViewDelegate>{
    UIScrollView    *pagingScrollView;
    UIPageControl   *pageControl;
    
    NSMutableSet    *recycledPages;
    NSMutableSet    *visiblePages;
    
    // these values are stored off before we start rotation so we adjust our content offset appropriately during rotation
    int           firstVisiblePageIndexBeforeRotation;
    CGFloat       percentScrolledIntoFirstVisiblePage;
    
    id            delegate;
}

@property (nonatomic, assign) id delegate;

- (void)tilePages;
- (void) pageTurn: (UIPageControl *) aPageControl;

- (CGRect)frameForPagingScrollView;
- (CGRect)frameForPageAtIndex:(NSUInteger)index ;
- (CGSize)contentSizeForPagingScrollView;

- (ButtonView *)dequeueRecycledPage;
- (BOOL)isDisplayingPageForIndex:(NSUInteger)index;
- (void)configurePage:(ButtonView *)page forIndex:(NSUInteger)index;

- (NSArray*)contentData;
- (NSInteger)contentDataCount;
- (NSString*)countDataImageNameAtIndex:(NSInteger)index;
- (UIImage *)imageButtonAtIndex:(NSUInteger)index;

@end
