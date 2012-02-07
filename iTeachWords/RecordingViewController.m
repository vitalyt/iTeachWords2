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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self materViewWidth];
    
    CGRect frame = vuMeter.frame;
    frame.size.width = 0;
    vuMeter.frame =  frame;
}

- (float)materViewWidth{
    static float materWidth;
    if (!materWidth) {
        materWidth = vuMeter.frame.size.width;
    }
    return materWidth;
}

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

#pragma meter func

- (void)runTimer{
    if (meterTimer && [meterTimer isValid]) {
        [meterTimer invalidate];
        meterTimer = nil;
    }
    meterTimer = [NSTimer scheduledTimerWithTimeInterval:.05 target:self selector:@selector(updateMeterView) userInfo:nil repeats:YES];
}

-(void) updateMeterView{
    //get volume levels
    if (recorder) {
        [recorder updateMeters];
        float level = [recorder peakPowerForChannel:0];
//        NSLog(@"%f",level);
        float width = [self materViewWidth];
        float scale = width/50;
        [vuMeter setFrame:CGRectMake(vuMeter.frame.origin.x, vuMeter.frame.origin.y, width+scale*level, vuMeter.frame.size.height)];
//      [self performSelector:@selector(updateMeterView) withObject:nil afterDelay:0.05];
    }
}

#pragma mark Action functions

- (IBAction)record:(id)sender {
    NSString *imageName;
    if(!isRecording){
        isRecording = YES;
        activityIndicatorView.hidden = NO;
        [vuMeter setHidden:NO];
        [activityIndicatorView startAnimating];
        imageName = @"Stop 16x16.png";
        [self startRecordInFile:fileName];
        //if (vuMeter) {
        [self runTimer];
        //[self updateMeterView];
        //}
    }
    else{
        isRecording = NO;
        activityIndicatorView.hidden = YES;
        [vuMeter setHidden:YES];
        [activityIndicatorView stopAnimating];
        imageName = @"Record 16x16.png"; 
        if (meterTimer && [meterTimer isValid]) {
            [meterTimer invalidate];
            meterTimer = nil;
        }
        [recorder stop];
        
    }
    if([sender isKindOfClass:[UIButton  class]]){
        [((UIButton *)sender) setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }else {
        [recordButton setImage:[UIImage imageNamed:imageName]];
    }
}

- (IBAction)play:(id)sender {
    NSData *data;
    data = [[NSData alloc]initWithContentsOfURL:recordedTmpFile];
    [[iTeachWordsAppDelegate sharedDelegate] playSound:data inView:self.view];
    [data release];
}

- (IBAction)close:(id)sender {
    if(isRecording == YES){
        [self record:nil];
    }
    NSLog(@"%@",isRecording);
    if ((self.toolsViewDelegate)&&([(id)self.toolsViewDelegate respondsToSelector:@selector(optionsSubViewDidClose:)])) {
		[self.toolsViewDelegate optionsSubViewDidClose:self];
	}
}

- (void)setVUMeterWidth:(float)width{

}

- (void)dealloc {
    [vuMeter release];
    [super dealloc];
}
@end
