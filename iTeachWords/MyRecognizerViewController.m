//
//  MyRecognizerViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/24/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "MyRecognizerViewController.h"

@implementation MyRecognizerViewController

@synthesize caller;

- (id)initWithDelegate:(id)_caller{
    self = [super initWithNibName:@"MyRecognizerViewController" bundle:nil];
    if(self){
        self.caller = _caller;
    }
    return self;
}

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
    NSString *nativeCountry = [[NSUserDefaults standardUserDefaults] objectForKey:@"nativeCountry"];
    NSString *translateCountry = [[NSUserDefaults standardUserDefaults] objectForKey:@"translateCountry"];
    
    [languageCodeLbl setText:NSLocalizedString(@"Language Code", @"")];
    [languageType setTitle:[NSString stringWithFormat:@"%@",translateCountry] forSegmentAtIndex:0];
    [languageType setTitle:[NSString stringWithFormat:@"%@",nativeCountry] forSegmentAtIndex:1];  
    
    [recordingTypeLbl setText:NSLocalizedString(@"Recognition Type", @"")];
    [recognitionType setTitle:NSLocalizedString(@"Search", @"") forSegmentAtIndex:0];
    [recognitionType setTitle:NSLocalizedString(@"Dictation", @"") forSegmentAtIndex:1];    
    
//    [recordButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    [helpBtn setTitle:NSLocalizedString(@"Settings", @"") forState:UIControlStateNormal];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [majorView setBackgroundColor:[UIColor clearColor]];
    [vuMeter setFrame:CGRectMake(vuMeter.frame.origin.x, vuMeter.frame.origin.y, 0.0, vuMeter.frame.size.height)];
    [languageType setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"lastLangType"]];
    [recognitionType setSelectedSegmentIndex:[[NSUserDefaults standardUserDefaults] integerForKey:@"lastRecognitionType"]];
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
    [helpBtn release];
    helpBtn = nil;
    [exitBtn release];
    exitBtn = nil;
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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
    [imageView setHidden:YES];
    [imageView release];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[[self.view subviews] objectAtIndex:0] setHidden:NO];    
    [self recordButtonAction:nil];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)close:(id)sender {
    if (transactionState == TS_RECORDING) {
        [voiceSearch stopRecording];
        [voiceSearch cancel];
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showToolsView:(id)sender {
    [self showHideToolsView];
}

- (void)showHideToolsView{
    CGRect majorViewFrame = [self getFrameForMajorView];
    CGRect exitBtnFrame = exitBtn.frame;
    exitBtnFrame.origin.y = majorViewFrame.origin.y-exitBtn.frame.size.height/2;
    
    //make button animation
    [UIView beginAnimations:@"SaveButtonAnimation" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [majorView setFrame:majorViewFrame];
    [exitBtn setFrame:exitBtnFrame];
    [UIView commitAnimations];
    if (!isToolsViewShowing) {
        [majorView performSelector:@selector(addSubview:) withObject:toolsView afterDelay:.3];
        [majorView sendSubviewToBack:toolsView];
    }else{
        [[NSUserDefaults standardUserDefaults] setInteger:recognitionType.selectedSegmentIndex forKey:@"lastRecognitionType"];
        [[NSUserDefaults standardUserDefaults] setInteger:languageType.selectedSegmentIndex forKey:@"lastLangType"];
        [toolsView performSelector:@selector(removeFromSuperview)withObject:nil afterDelay:0.1];
    }
    CGRect toolsViewFrame = [self getFrameForToolsView];
    [toolsView setFrame:toolsViewFrame];
    
    isToolsViewShowing = !isToolsViewShowing;
    [majorView performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:YES ];
}

- (CGRect)getFrameForMajorView{
    CGRect frame;
    static CGRect majorViewOriginFrame;
    static CGRect majorViewExtendedFrame;
    if (CGRectIsEmpty(majorViewOriginFrame)) {
        majorViewOriginFrame = majorView.frame;
    }
    majorViewExtendedFrame = CGRectMake(majorViewOriginFrame.origin.x, majorViewOriginFrame.origin.y-toolsView.frame.size.height/2, 
                                        majorViewOriginFrame.size.width, majorViewOriginFrame.size.height + toolsView.frame.size.height);
    frame = (!isToolsViewShowing)?majorViewExtendedFrame:majorViewOriginFrame;
    return frame;
}

- (CGRect)getFrameForToolsView{
    static CGRect toolsViewOriginFrame;
    if (CGRectIsEmpty(toolsViewOriginFrame)) {
        toolsViewOriginFrame = CGRectMake(0, 178, majorView.frame.size.width, toolsView.frame.size.height);//toolsView.frame;

    }
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
    NSLog(@"%@",langType);
    return langType;
}

#pragma mark -
#pragma mark SKRecognizerDelegate methods

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"Got results.");
    
    long numOfResults = [results.results count];
    NSLog(@"%@",results.results);
    transactionState = TS_IDLE;
    [recordButton setTitle:NSLocalizedString(@"Record", @"") forState:UIControlStateNormal];
    [messageLbl setText:NSLocalizedString(@"Tap to record", @"")];
//    NSArray *variants; 
    if ((0 < numOfResults <= 1) && [results firstResult]){
        NSArray *resultats = results.results;
        [self showTableAlertViewWithElements:resultats];
//        [self didSelectRowAtIndex:0 withContext:[results firstResult]];
        searchBox.text = [results firstResult];
    }else if (numOfResults > 1) {
        [self showTableAlertViewWithElements:[results.results subarrayWithRange:NSMakeRange(1, numOfResults-1)]];
		alternativesDisplay.text = [[results.results subarrayWithRange:NSMakeRange(1, numOfResults-1)] componentsJoinedByString:@"\n"];
    }
    
    if (results.suggestion) {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Suggestion"
                                                        message:results.suggestion
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];        
        [alert show];
        [alert release];
        
    }
    
	[voiceSearch release];
	voiceSearch = nil;
}

#pragma mark alert table functions

- (void)showTableAlertViewWithElements:(NSArray *)elements{
    NSString *title = [NSString stringWithFormat:@"%@ (%d)",NSLocalizedString(@"Alternatives", @""),[elements count]];
    RecognizerAlertTableView *alertTableView = [[RecognizerAlertTableView alloc] initWithCaller:self data:elements title:title andContext:@"context identificator"];
    [alertTableView show];
    [alertTableView autorelease];
}

#pragma mark alert table delegate

-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context{
    NSLog(@"Alert view index is ->%d",row);    
    if (context && row>=0) {
        if (caller) {
            [self close:nil];
            [caller didRecognizeText:context languageCode:[self getLangType]];
        }
    }
}


- (void)dealloc {
    self.caller = nil;
    [toolsView release];
    [recordingTypeLbl release];
    [languageCodeLbl release];
    [majorView release];
    [helpBtn release];
    [exitBtn release];
    [super dealloc];
}
@end
