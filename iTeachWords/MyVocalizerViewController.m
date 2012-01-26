//
//  MyVocalizerViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/26/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "MyVocalizerViewController.h"
#import "MyUIViewClass.h"

@implementation MyVocalizerViewController

@synthesize caller;

- (id)initWithDelegate:(id)_caller{
    self = [super initWithNibName:@"MyVocalizerViewController" bundle:nil];
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
    
    //    [recordButton setTitle:NSLocalizedString(@"Cancel", @"") forState:UIControlStateNormal];
    [helpBtn setTitle:NSLocalizedString(@"Help", @"") forState:UIControlStateNormal];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.caller = nil;
    [majorView release];
    majorView = nil;
    [toolsView release];
    toolsView = nil;
    [helpBtn release];
    helpBtn = nil;
    [exitBtn release];
    exitBtn = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    
    
    [speakButton setImage:[UIImage imageNamed:@"right.png"] forState:UIControlStateNormal];
    [self speakOrStopAction:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[[self.view subviews] objectAtIndex:0] removeFromSuperview];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [majorView release];
    [toolsView release];
    [helpBtn release];
    [exitBtn release];
    [super dealloc];
}

- (IBAction)close:(id)sender {
    if (isSpeaking) {
        [vocalizer cancel];
        isSpeaking = NO;
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
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [majorView setFrame:majorViewFrame];
    [exitBtn setFrame:exitBtnFrame];
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

- (NSString *)currentTextLanguage{
    NSString* langType;
    if ([NATIVE_LANGUAGE_CODE isEqualToString:[languageCode uppercaseString]]) {
        NSDictionary *nativeCountryInfo = NATIVE_COUNTRY_INFO;
        langType = [NSString stringWithFormat:@"%@_%@", [[nativeCountryInfo objectForKey:@"code"] lowercaseString],[[nativeCountryInfo objectForKey:@"codeExpended"] uppercaseString]] ;//@"en_US";
    }else {
        NSDictionary *translateCountryInfo = TRANSLATE_COUNTRY_INFO;
        langType = [NSString stringWithFormat:@"%@_%@",[[translateCountryInfo objectForKey:@"code"] lowercaseString],[[translateCountryInfo objectForKey:@"codeExpended"] uppercaseString]];//@"en_US";
    }
    NSLog(@"%@",langType);
    return langType;
}

- (void)setText:(NSString*)_text withLanguageCode:(NSString*)_languageCode{
    self.speakString = _text;
    self.languageCode = _languageCode;
}

@end
