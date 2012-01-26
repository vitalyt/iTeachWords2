//
//  ButtonView.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/26/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView

@synthesize delegate,index;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self performInitializations];
    }
    return self;
}

- (void)performInitializations {
    
}

- (void)dealloc {
    [button release];
    [super dealloc];
}

- (IBAction)buttonAction:(id)sender {
    SEL selector = @selector(buttonDidClick: withIndex:);
    if ([delegate respondsToSelector:selector]) {
        [delegate performSelector:selector withObject:sender withObject:index];
    }
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
    [button release];
    button = nil;
    delegate = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)changeButtonImage:(UIImage*)_image{
    [button setImage:_image forState:UIControlStateNormal];
}

@end
