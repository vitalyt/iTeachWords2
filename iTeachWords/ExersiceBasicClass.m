//
//  ExersiceBasicClass.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/23/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "ExersiceBasicClass.h"
#import "StatisticViewController.h"
#import "Statistic.h"
#import "RepeatModel.h"

#define WORD(array,index) ((Words *)[array objectAtIndex:index])

@implementation ExersiceBasicClass

@synthesize data,textBox,lblWordEng,lblWordRus,bannerIsVisible,doneButton;
@synthesize wordType;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(back)] autorelease];
    }
    return self;
}

- (void) dealloc{
    [wordType release];
    [lblWordEng release];
    [lblWordRus release];
    [textBox release];
    [doneButton release];
    [self.data release];
    if (statisticView) {
        [statisticView release];
    }
    if (multiPlayer) {
        [multiPlayer closePlayer];
        [multiPlayer release];
    }
    if (adView) {
        adView.delegate = nil;
        [adView release];
    }
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [textBox setFont:FONT_TEXT];
    [lblWordEng setFont:FONT_TEXT];
    [lblWordRus setFont:FONT_TEXT];
    //[self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grnd.png"]]];
	[textBox setReturnKeyType:UIReturnKeyNext];
	textBox.delegate = self;
    [self createBunnerView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    if (adView) {
        adView.delegate = nil;
        [adView release];
    }
    [super viewDidUnload];
}


- (void)createBunnerView{
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.frame = CGRectOffset(adView.frame, 0, -50);
    adView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifier320x50,ADBannerContentSizeIdentifier480x32,nil];
    adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
    [self.view addSubview:adView];
    adView.delegate=self;
    self.bannerIsVisible=NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self nextWord];
	return YES;
}

- (void) createStatisticsView{
    statisticView = [[StatisticViewController alloc] initWithNibName:@"StatisticViewController" bundle:NULL];
    self.navigationItem.titleView = statisticView.view;
}

- (void) nextWord{
    
}

- (void) back{ 
    [self registerRepeat];
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)registerRepeat{
    if (wordType) {
        RepeatModel *repeatModel = [[RepeatModel alloc] initWithWordType:wordType];
        [repeatModel registerRepeat];
        [repeatModel release];
    }
}

- (void) showTestMessageResultat:(bool)rightFlg{
    if (rightFlg) {
        [UIAlertView showMessage:@"Good job." withColor:[UIColor greenColor]];
    }else{
        [UIAlertView showMessage:@"You made mistake." withColor:[UIColor redColor]];
    }
}

- (void) playSoundWithIndex:(int)index{
    if (multiPlayer) {
        [multiPlayer closePlayer];
        [multiPlayer release];
    }
    NSArray *sounds = [[NSArray alloc] initWithObjects:[self.data objectAtIndex:index], nil];
    multiPlayer = [[MultiPlayer alloc] initWithNibName:@"MultiPlayer" bundle:nil];
	multiPlayer.delegate = self;
	[multiPlayer openViewWithAnimation:self.view];
	[multiPlayer playList:sounds];
    [sounds release];
}

- (void) checkingWord:(Words *)word success:(BOOL)success{
    Statistic *statistic;
    if ([[word statistics] count] == 0) {
        statistic = [NSEntityDescription insertNewObjectForEntityForName:@"Statistic" 
                                                    inManagedObjectContext:CONTEXT];
        [word addStatisticsObject:statistic];
    }else{
        statistic = [[[word statistics] allObjects] objectAtIndex:0];
    }
    if(success){
        int successfulCount = [statistic.successfulCount intValue];
        [statistic setSuccessfulCount:[NSNumber numberWithInt:++successfulCount]];
    }
    int requestCount = [statistic.requestCount intValue];
    [statistic setRequestCount:[NSNumber numberWithInt:++requestCount]];
    
    NSError *_error;
    [CONTEXT save:&_error];
}


- (NSArray *)getStatisticIndexesArrayWithWords:(NSArray*)wordsArray{
    NSMutableArray *indexesArray = [[NSMutableArray alloc] init];
    for (int i=0; i<[wordsArray count]; i++) {
        int count = 10;
        if (WORD(wordsArray, i).statistics && [[WORD(wordsArray, i).statistics allObjects] count]>0) {
            Statistic *statistic = [[WORD(wordsArray, i).statistics allObjects] objectAtIndex:0];
            int requestCount = [statistic.requestCount intValue];
            int successfulCount = [statistic.successfulCount intValue];
            float procent = (float)((float)(requestCount - successfulCount)/requestCount);
            count = procent * 10.0;
        }
        [indexesArray addObject:[NSNumber numberWithInt:i]];
        for (int j=0; j<count; j++) {
            [indexesArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    [indexesArray autorelease];
    return [NSArray mixArray:indexesArray];
}

#pragma mark ADBannerView
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft ||
        [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) 
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier480x32;
    else
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifier320x50;
    [self moveViewObjects];
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // banner is invisible now and moved out of the screen on 50 px
        self.bannerIsVisible = YES;
        [self moveViewObjects];
        [UIView commitAnimations];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // banner is visible and we move it out of the screen, due to connection issue
        self.bannerIsVisible = NO;
        [self moveViewObjects];
        [UIView commitAnimations];
    }
}

- (void)moveViewObjects{
    float offset ;
    if (!self.bannerIsVisible) {
        offset = -20;
        adView.frame = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height-adView.frame.size.height, adView.frame.size.width, adView.frame.size.height);
    }else{
        offset = adView.frame.size.height;
        adView.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, adView.frame.size.width, adView.frame.size.height);
    }
    
    [textBox setFrame:CGRectMake(textBox.frame.origin.x, 97+offset, textBox.frame.size.width, textBox.frame.size.height)];
    [lblWordEng setFrame:CGRectMake(lblWordEng.frame.origin.x, 102+offset, lblWordEng.frame.size.width, lblWordEng.frame.size.height)];
    [lblWordRus setFrame:CGRectMake(lblWordRus.frame.origin.x, 50+offset, lblWordRus.frame.size.width, lblWordRus.frame.size.height)];
    [doneButton setFrame:CGRectMake(doneButton.frame.origin.x, 136+offset, doneButton.frame.size.width, doneButton.frame.size.height)];
    
}

@end
