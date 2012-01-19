//
//  RecordingViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/19/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "RecordingViewController.h"

@implementation RecordingViewController

@synthesize delegate,toolsViewDelegate;

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [vuMeter release];
    vuMeter = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//
//#pragma mark -
//#pragma mark VU Meter
//- (void)setVUMeterWidth:(float)width {
//    if (width < 0)
//        width = 0;
//    
//    CGRect frame = vuMeter.frame;
//    frame.size.width = width+10;
//    vuMeter.frame = frame;
//}
//
//- (void)updateVUMeter {
//    float width = (90+voiceSearch.audioLevel)*5/2;
//    
//    [self setVUMeterWidth:width];    
//    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
//}

#pragma mark Action functions

- (IBAction)record:(id)sender {
    NSString *imageName;
    if(activityIndicatorView.hidden == YES){
        activityIndicatorView.hidden = NO;
        [activityIndicatorView startAnimating];
        imageName = @"Stop 16x16.png";
        [self startRecordInFile:fileName];
    }
    else{
        activityIndicatorView.hidden = YES;
        [activityIndicatorView stopAnimating];
        imageName = @"Record 16x16.png"; 
        [recorder stop];
        
    }
    if ([sender isKindOfClass:[UIBarButtonItem  class]]) {
        [((UIBarButtonItem *)sender) setImage:[UIImage imageNamed:imageName]];
    }else if([sender isKindOfClass:[UIButton  class]]){
        [((UIButton *)sender) setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
}

- (IBAction)play:(id)sender {
    NSData *data;
    data = [[NSData alloc]initWithContentsOfURL:recordedTmpFile];
    [[iTeachWordsAppDelegate sharedDelegate] playSound:data inView:self.view];
    [data release];
}

- (IBAction)close:(id)sender {
    if(activityIndicatorView.hidden == NO){
        [self record:nil];
    }
    if ((self.toolsViewDelegate)&&([(id)self.toolsViewDelegate respondsToSelector:@selector(optionsSubViewDidClose:)])) {
		[self.toolsViewDelegate optionsSubViewDidClose:self];
	}
}

- (void)dealloc {
    [vuMeter release];
    [super dealloc];
}
@end
