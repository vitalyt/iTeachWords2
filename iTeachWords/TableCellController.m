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
    if(self.statisticViewController == nil){
        self.statisticViewController = [[DetailStatisticViewController alloc] initWithNibName:@"DetailStatisticViewController" bundle:nil];
        [self addSubview:self.statisticViewController.view];
    }
}

- (void) removeStatisticView{
    [self.statisticViewController.view removeFromSuperview];
    [self.statisticViewController release];
    self.statisticViewController = nil;
}

- (void)dealloc {
	[lblEng release];
	[lblRus release];
	[lblEngH release];
	[lblRusH release];
	if (statisticViewController) {
        [self removeStatisticView];
    }
    [super dealloc];
}

- (IBAction)btnActionClick:(id)sender{
    SEL selector = @selector(btnActionClickWithCell:);
    if ([delegate respondsToSelector:selector]) {
        [delegate performSelector:selector withObject:self afterDelay:0.1];
    }
}
@end
