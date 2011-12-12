//
//  TestsViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/21/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "TestsViewController.h"


@implementation TestsViewController

@synthesize toolsViewDelegate,testsViewDelegate;

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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//-----------------------------------------------------------------------------------

- (IBAction)close:(id)sender {
    if ((self.toolsViewDelegate)&&([self.toolsViewDelegate respondsToSelector:@selector(optionsSubViewDidClose:)])) {
		[self.toolsViewDelegate optionsSubViewDidClose:self];
	}
}


- (IBAction) clickGame{
	if ((self.testsViewDelegate)&&([self.testsViewDelegate respondsToSelector:@selector(clickGame)])) {
		[self.testsViewDelegate clickGame];
		return;
	}
}

- (IBAction) clickTestOneOfSix{
	if ((self.testsViewDelegate)&&([self.testsViewDelegate respondsToSelector:@selector(clickTestOneOfSix)])) {
		[self.testsViewDelegate clickTestOneOfSix];
		return;
	}
}

- (IBAction) clickTest1{
	if ((self.testsViewDelegate)&&([self.testsViewDelegate respondsToSelector:@selector(clickTest1)])) {
		[self.testsViewDelegate clickTest1];
		return;
	}
}

- (IBAction) clickStatistic{
	if ((self.testsViewDelegate)&&([self.testsViewDelegate respondsToSelector:@selector(clickStatistic)])) {
		[self.testsViewDelegate clickStatistic];
		return;
	}
}


@end
