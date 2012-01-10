//
//  EditingView.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 2/22/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "EditingView.h"


@implementation EditingView

@synthesize editingViewDelegate,toolsViewDelegate;

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


- (IBAction)close:(id)sender {
    if ((self.toolsViewDelegate)&&([self.toolsViewDelegate respondsToSelector:@selector(editingSubViewDidClose:)])) {
        
		[self.toolsViewDelegate performSelector:@selector(editingSubViewDidClose:) withObject:self];
	}
}

- (IBAction) deleteWord{
    if ((self.editingViewDelegate)&&([self.editingViewDelegate respondsToSelector:@selector(deleteWord)])) {
		[self.editingViewDelegate deleteWord];
		return;
	}
}

- (IBAction) editWord{
    if ((self.editingViewDelegate)&&([self.editingViewDelegate respondsToSelector:@selector(editWord)])) {
		[self.editingViewDelegate editWord];
		return;
	} 
}

//- (void) toolbarAddSubView:(UIView *)_subView after:(id)sender{
//    NSMutableArray *items = [[toolbar items] mutableCopy];
//    UIBarButtonItem *recordingButton = [[UIBarButtonItem alloc] initWithCustomView:_subView];
//    int index = [items indexOfObject:sender]+1;
//    [recordingButton setTag:index];
//    [_subView setTag:index];
//    [items insertObject:recordingButton atIndex:[items indexOfObject:sender]+1];
//    [recordingButton release];
//    ((UIBarButtonItem *)sender).enabled = NO;
//    [toolbar setItems:nil];
//    [toolbar setFrame:CGRectMake(0.0, 0.0, 
//                                 toolbar.frame.size.width + _subView.frame.size.width, 
//                                 toolbar.frame.size.height)];    
//    [toolbar setItems:items animated:YES];
//    [items release];
//}

- (IBAction) reassignWord{
    if ((self.editingViewDelegate)&&([self.editingViewDelegate respondsToSelector:@selector(reassignWord)])) {
		[self.editingViewDelegate reassignWord];
		return;
	}
}

- (IBAction)selectAll:(id)sender {
    if ((self.editingViewDelegate)&&([self.editingViewDelegate respondsToSelector:@selector(selectAll)])) {
		[self.editingViewDelegate selectAll];
		return;
	}
}

@end
