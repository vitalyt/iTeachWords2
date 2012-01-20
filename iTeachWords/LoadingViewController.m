//
//  LoadingViewController.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/6/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "LoadingViewController.h"

#define LOADING_VIEWTAG 998

@implementation LoadingViewController

@synthesize myProgressView,titleLabel,total;

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
    [self closeLoadingView];
    [titleLabel release];
    [myProgressView release];
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
    [myProgressView setProgress:0.0];
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

- (void)updateDataCurrentIndex:(NSNumber *) currentIndex{
    if (total != 0 && currentIndex != 0) {
        [myProgressView setProgress:(100.0/total*[currentIndex floatValue])/100.0];
    }
}

- (void)showLoadingView{
    UIView* _baseView = [[UIApplication sharedApplication] keyWindow];
    if ([_baseView viewWithTag:LOADING_VIEWTAG] != nil) {
		return;
	}
    [self updateDataCurrentIndex:0];
    [self.view setTag:LOADING_VIEWTAG];
	[_baseView addSubview:self.view];
    [_baseView bringSubviewToFront:self.view];
}

- (void)closeLoadingView{
    UIView* _baseView = [[UIApplication sharedApplication] keyWindow];
    [[_baseView viewWithTag:LOADING_VIEWTAG] removeFromSuperview];
    [[self view] removeFromSuperview];
}

@end
