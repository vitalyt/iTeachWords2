//
//  ManagerViewController.m
//  iTeachWords
//
//  Created by  user on 03.07.11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "ManagerViewController.h"
#import "ToolsViewProtocol.h"

@implementation ManagerViewController

@synthesize managerViewDelegate,toolsViewDelegate,segmentControll;

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
    [segmentControll release];
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
    [segmentControll setTitle:TRANSLATE_LANGUAGE_CODE forSegmentAtIndex:0];
    [segmentControll setTitle:NATIVE_LANGUAGE_CODE forSegmentAtIndex:2];
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


- (IBAction)close:(id)sender {
    SEL selector = @selector(managerSubViewDidClose:);
    if ((self.toolsViewDelegate)&&([(id)toolsViewDelegate respondsToSelector:selector])) {
		[(id)self.toolsViewDelegate performSelector:selector withObject:self afterDelay:0.01];
	}
}

- (IBAction) mixingWords{
    SEL selector = @selector(mixingWords);
    if ((self.managerViewDelegate)&&([self.managerViewDelegate respondsToSelector:selector])) {
		[(id)self.managerViewDelegate performSelector:selector withObject:nil afterDelay:0.01];
	}
}

- (IBAction)selectedLanguage:(id)sender {
    SEL selector = @selector(selectedLanguage:);
    //UISegmentedControl *segment = (UISegmentedControl*)sender;
    if ((self.managerViewDelegate)&&([self.managerViewDelegate respondsToSelector:selector])) {
		[(id)self.managerViewDelegate performSelector:selector withObject:sender afterDelay:0.01];
	}
}

@end
