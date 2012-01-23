//
//  VoiceRecordingViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/23/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "VoiceRecordingViewController.h"

@implementation VoiceRecordingViewController

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
- (void)loadView{
    [super loadView];
    recordingView.layer.cornerRadius = 5;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [recordingView release];
    recordingView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.view subviews] objectAtIndex:0] removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // grab an image of our parent view    
    // For iOS 5 you need to use presentingViewController:
    UIView *parentView = self.presentingViewController.view;
    
    UIGraphicsBeginImageContext(parentView.bounds.size);
    [parentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *parentViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // insert an image view with a picture of the parent view at the back of our view's subview stack...
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, parentView.bounds.size.width, parentView.bounds.size.height)];
    imageView.image = parentViewImage;
    [self.view insertSubview:imageView atIndex:0];
//    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75]];
    [imageView release];
    
    [self record:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc {
    [recordingView release];
    [super dealloc];
}
- (IBAction)cancel:(id)sender {
    [super close:nil];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)help:(id)sender {
}
@end
