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
    [self.view setBackgroundColor:[UIColor clearColor]];
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
    UIView *parentView = self.presentedViewController.view;
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] >= 5.0) {
        parentView = self.presentingViewController.view;
    }else{
        parentView = self.parentViewController.view;
    }
    
    UIGraphicsBeginImageContext(parentView.bounds.size);
    [parentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *parentViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // insert an image view with a picture of the parent view at the back of our view's subview stack...
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -20, parentView.bounds.size.width, parentView.bounds.size.height)];
    imageView.image = parentViewImage;
    [self.view insertSubview:imageView atIndex:0];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
    
//    [self record:nil];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)close:(id)sender {
    if(isRecording){
        [self record:nil];
    }
    [self dismissModalViewControllerAnimated:YES];
    if ((self.toolsViewDelegate)&&([(id)self.toolsViewDelegate respondsToSelector:@selector(optionsSubViewDidClose:)])) {
		[self.toolsViewDelegate optionsSubViewDidClose:self];
	}
}

- (IBAction)help:(id)sender {
}

#pragma suoerclass function


-(void) updateMeterView{
    //get volume levels
    if (recorder) {
        [recorder updateMeters];
        float level = [recorder peakPowerForChannel:0];
        static bool startFlg;
        //        NSLog(@"%f",level);
        float width = [self materViewWidth];
        float scale = width/50;
        [vuMeter setFrame:CGRectMake(vuMeter.frame.origin.x, vuMeter.frame.origin.y, width+scale*level, vuMeter.frame.size.height)];
        if (level<-35 && startFlg) {
            ++status;
            if (status>=20) {
                [self close:nil];
            }
            NSLog(@"%d",status);
        }else{
            startFlg = YES;
            status = 0;
        }
        //        [self performSelector:@selector(updateMeterView) withObject:nil afterDelay:0.05];
    }
}

@end
