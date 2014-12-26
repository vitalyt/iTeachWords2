//
//  TableCellController.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/22/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "TableCellController.h"
#import "DetailStatisticViewController.h"


@implementation TableCellController
@synthesize lblEng,lblRus,lblEngH,lblRusH;
@synthesize btn;
@synthesize statisticViewController;
@synthesize delegate;

- (NSString *) reuseIdentifier {
	return @"TableCell";
}

- (void) generateStatisticView{
    if(statisticViewController == nil){
        statisticViewController = [[DetailStatisticViewController alloc] initWithNibName:@"DetailStatisticViewController" bundle:nil];
        [self addSubview:statisticViewController.view];
    }
}

- (void) removeStatisticView{
    if (statisticViewController) {
        [statisticViewController.view removeFromSuperview];
        self.statisticViewController = nil;
    }
}

- (void)dealloc {
    [self removeStatisticView];
}

- (IBAction)btnActionClick:(id)sender{
    SEL selector = @selector(btnActionClickWithCell:);
    if ([delegate respondsToSelector:selector]) {
        [delegate performSelector:selector withObject:self afterDelay:0.01];
    }
}
@end
