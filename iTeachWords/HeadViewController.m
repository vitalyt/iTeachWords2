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

- (void)dealloc
{
    [super dealloc];
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
        self.statisticViewController = [[DetailStatisticViewController alloc] initWithNibName:@"DetailStatisticViewController" bundle:nil];
        [self.view addSubview:self.statisticViewController.view];
        CGRect frame = CGRectMake(14, 23, 100, 20);
        [self.statisticViewController.view setFrame:frame];
    }
    [self.statisticViewController generateStatisticByWords:words];
}

- (void)removeStatisticView{
    [self.statisticViewController.view removeFromSuperview];
    [self.statisticViewController release];
    self.statisticViewController = nil;
}

- (void)viewDidUnload
{
    [titleLabel release];
    [subTitleLabel release];
    if (self.statisticViewController) {
        [self.statisticViewController release];
    }
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
