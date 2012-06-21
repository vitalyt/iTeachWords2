//
//  PagesViewController.h
//  ABN op reis
//
//  Created by Vitaly Todorovych on 3/25/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
#define RSTRING(X) NSStringFromCGRect(X)

#define BASEHEIGHT	self.view.frame.size.height
#define INITPAGES	3
#define MAXPAGES	8

@interface PagesViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView *sv;
	IBOutlet UIPageControl *pageControl;
    NSMutableArray  *sourceData;
    NSMutableArray  *viewStore;
}

@property (nonatomic, retain)  NSMutableArray  *viewStore,*sourceData;

- (void) addPage:(int)index;
- (UIColor *)randomColor;
- (void) scrollViewDidScroll: (UIScrollView *) aScrollView;
- (void) pageTurn: (UIPageControl *) aPageControl;
- (void) setPageNum:(int)num;
- (void) loadData;
- (void)loadContentOfPage:(int)index;
- (int)currentPage;
@end
