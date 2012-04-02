//
//  RecordingViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/19/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "RecordingViewController.h"
#import "ToolsViewController.h"
@implementation RecordingViewController

@synthesize delegate,toolsViewDelegate;

- (void)dealloc {
    [vuMeter release];
    [super dealloc];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self materViewWidth];
    activityIndicatorView.hidden = YES;
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
    if (IS_HELP_MODE && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)delegate).view];
        return;
    }
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
    if (IS_HELP_MODE && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)delegate).view];
        return;
    }
    
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

-(UIView*)hintStateViewForDialog:(id)hintState
{
    CGRect frame = ((UIViewController*)delegate).view.frame;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height/4, frame.size.width-20, frame.size.height/2)];
    [l setTextAlignment:UITextAlignmentCenter];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:[self helpMessageForButton:_currentSelectedObject]];
    return l;
}

- (NSString*)helpMessageForButton:(id)_button{
    NSString *message = nil;
    int index = ((UIBarButtonItem*)_button).tag+1;
    switch (index) {
        case 1:
            message = NSLocalizedString(@"Запись", @"");
            break;
        case 2:
            message = NSLocalizedString(@"Воспроизведение", @"");
            break;
            
        default:
            break;
    }
    return message;
}

-(UIView*)hintStateViewToHint:(id)hintState
{
    [usedObjects addObject:_currentSelectedObject];
    UIView *buttonView = nil;
    UIView *view = _currentSelectedObject;
    if (![view respondsToSelector:@selector(frame)]) {
        @try {
            view = ([_currentSelectedObject valueForKey:@"view"])?[_currentSelectedObject valueForKey:@"view"]:nil;
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
    }
    CGRect frame = view.frame;
    ToolsViewController *toolsView =  ((ToolsViewController*)toolsViewDelegate);
    buttonView = [[[UIView alloc] initWithFrame:frame] autorelease];
    [buttonView setFrame:CGRectMake(frame.origin.x+self.view.frame.origin.x-toolsView.scrollView.contentOffset.x, frame.origin.y+((UIViewController*)toolsViewDelegate).view.frame.origin.y, frame.size.width, frame.size.height)];
    return buttonView;
}
@end
