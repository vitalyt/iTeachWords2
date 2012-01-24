//
//  MyRecognizerViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/24/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "MyRecognizerViewController.h"

@implementation MyRecognizerViewController

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
    NSString *nativeCountry = [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY];
    NSString *translateCountry = [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY];
    
//    NSString *nativeCountry = [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE];
//    NSString *translateCountry = [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE];
//    [languageType setTitle:[NSString stringWithFormat:@"%@_%@",[translateCountry lowercaseString],[translateCountry uppercaseString]] forSegmentAtIndex:0];
//    [languageType setTitle:[NSString stringWithFormat:@"%@_%@", [nativeCountry lowercaseString],[nativeCountry uppercaseString]] 
//         forSegmentAtIndex:1];
    
    [languageCodeLbl setText:NSLocalizedString(@"Language Code", @"")];
    [languageType setTitle:[NSString stringWithFormat:@"%@",translateCountry] forSegmentAtIndex:0];
    [languageType setTitle:[NSString stringWithFormat:@"%@",nativeCountry] forSegmentAtIndex:1];  
    
    [recordingTypeLbl setText:NSLocalizedString(@"Recognition Type", @"")];
    [recognitionType setTitle:NSLocalizedString(@"Search", @"") forSegmentAtIndex:0];
    [recognitionType setTitle:NSLocalizedString(@"Dictation", @"") forSegmentAtIndex:1];    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [vuMeter setFrame:CGRectMake(vuMeter.frame.origin.x, vuMeter.frame.origin.y, 0.0, vuMeter.frame.size.height)];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [toolsView release];
    toolsView = nil;
    [recordingTypeLbl release];
    recordingTypeLbl = nil;
    [languageCodeLbl release];
    languageCodeLbl = nil;
    [majorView release];
    majorView = nil;
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
    UIView *parentView;
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
    [imageView release];
    
    //[self record:nil];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showToolsView:(id)sender {
    [self showHideToolsView];
}

- (void)showHideToolsView{
    CGRect majorViewFrame = [self getFrameForMajorView];
    
    //make button animation
    [UIView beginAnimations:@"SaveButtonAnimation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [majorView setFrame:majorViewFrame];
    [UIView commitAnimations];
    if (!isToolsViewShowing) {
        [majorView addSubview:toolsView];
        [majorView sendSubviewToBack:toolsView];
    }else{
        [toolsView performSelector:@selector(removeFromSuperview)withObject:nil afterDelay:0.5];
    }
    CGRect toolsViewFrame = [self getFrameForToolsView];
    [toolsView setFrame:toolsViewFrame];
    
    isToolsViewShowing = !isToolsViewShowing;
}

- (CGRect)getFrameForMajorView{
    CGRect frame;
    static CGRect majorViewOriginFrame;
    static CGRect majorViewExtendedFrame;
    if (CGRectIsEmpty(majorViewOriginFrame)) {
        majorViewOriginFrame = majorView.frame;
    }
    majorViewExtendedFrame = CGRectMake(majorViewOriginFrame.origin.x, majorViewOriginFrame.origin.y, 
                                        majorViewOriginFrame.size.width, majorViewOriginFrame.size.height + toolsView.frame.size.height);
    frame = (!isToolsViewShowing)?majorViewExtendedFrame:majorViewOriginFrame;
    return frame;
}

- (CGRect)getFrameForToolsView{
    CGRect frame;
    static CGRect toolsViewOriginFrame;
    static CGRect toolsViewExtendedFrame;
    if (CGRectIsEmpty(toolsViewOriginFrame)) {
        toolsViewOriginFrame = CGRectMake(0, 178, majorView.frame.size.width, toolsView.frame.size.height);//toolsView.frame;

    }
    //    majorViewExtendedFrame = CGRectMake(majorViewOriginFrame.origin.x, majorViewOriginFrame.origin.y, 
//                                        majorViewOriginFrame.size.width, majorViewOriginFrame.size.height + toolsView.frame.size.height);
//    frame = (!isToolsViewShowing)?majorViewExtendedFrame:majorViewOriginFrame;
    return toolsViewOriginFrame;
}

- (NSString*)getLangType{
    NSString* langType;
    
    switch (languageType.selectedSegmentIndex) {
        case 0:{
            NSDictionary *translateCountryInfo = TRANSLATE_COUNTRY_INFO;
            langType = [NSString stringWithFormat:@"%@_%@",[[translateCountryInfo objectForKey:@"code"] lowercaseString],[[translateCountryInfo objectForKey:@"codeExpended"] uppercaseString]];//@"en_US";
        }
            break;
        case 1:{
            NSDictionary *nativeCountryInfo = NATIVE_COUNTRY_INFO;
            langType = [NSString stringWithFormat:@"%@_%@", [[nativeCountryInfo objectForKey:@"code"] lowercaseString],[[nativeCountryInfo objectForKey:@"codeExpended"] uppercaseString]] ;//@"en_US";
        }
            break;
    }
    return langType;
}

- (void)dealloc {
    [toolsView release];
    [recordingTypeLbl release];
    [languageCodeLbl release];
    [majorView release];
    [super dealloc];
}
@end
