//
//  HeadViewController.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 10/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "HeadViewController.h"
#import "DetailStatisticViewController.h"

@implementation HeadViewController
@synthesize titleLabel,subTitleLabel,statisticViewController;
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
    // Do any additional setup after loading the view from its nib.
}

- (void)generateStatisticViewWithWords:(NSSet*)words{
    if(self.statisticViewController == nil){
        statisticViewController = [[DetailStatisticViewController alloc] initWithNibName:@"DetailStatisticViewController" bundle:nil];
        [self.view addSubview:statisticViewController.view];
        CGRect frame = CGRectMake(14, 23, 100, 20);
        [statisticViewController.view setFrame:frame];
    }
    [statisticViewController generateStatisticByWords:words];
}

- (void)removeStatisticView{
    [statisticViewController.view removeFromSuperview];
    statisticViewController = nil;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
