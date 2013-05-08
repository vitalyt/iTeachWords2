//
//  MenuViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/27/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "MenuViewController.h"
#import "TextViewController.h"
#import "LM15.h"
#import "LM7.h"
#import "TranslateViewController.h"
#import "WorldTableToolsController.h"
#import "DictionaryViewController.h"
#import "MenuLessons.h"
#import "LanguagePickerController.h"
#import "SettingsViewController.h"
#import "InfoViewController.h"
#import "SpeachView.h"
#import "WebViewController.h"
#import "DMVocalizerViewController.h"
#import "DMRecognizerViewController.h"
#import "WordTypes.h"

#import "RepeatModel.h"
#import "CustomBadge.h"

#import "ThemesTableView.h"

#ifdef FREE_VERSION
#import "PurchaseStoreMenuView.h"
#endif

#import "PurchasesDetailViewController.h"
@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitle:NSLocalizedString(@"iStudyWords", @"")];
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [titleLbl1 release];
    [titleLbl2 release];
    [titleLbl4 release];
    [titleLbl5 release];
    [titleLbl6 release];
    [titleLbl7 release];
    [titleLbl8 release];
    [titleLbl9 release];
    [menuBtn1 release];
    if (customBadge1) {
        [customBadge1 removeFromSuperview];
        customBadge1 = nil;
    }
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  //  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self checkDelayedThemes];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"nativeCountryCode"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"translateCountryCode"]){
        LanguagePickerController *languageView = [[LanguagePickerController alloc] initWithNibName:@"LanguagePickerController" bundle:nil];
        [self.navigationItem setBackBarButtonItem: BACK_BUTTON];
        [self.navigationController pushViewController:languageView animated:YES];
        [languageView release];
        [UIAlertView displayMessage:NSLocalizedString(@"This is your first launch iStudyWords.\nPlease, choose the languages that you will use.", @"") title:NSLocalizedString(@"Suggestion", @"")];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Web Empty Designe"]]];
    [self setTitles];
    [self addInfoButton];
    [self addMailButton];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];

    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [titleLbl1 release];
    titleLbl1 = nil;
    [titleLbl2 release];
    titleLbl2 = nil;
    [titleLbl4 release];
    titleLbl4 = nil;
    [titleLbl5 release];
    titleLbl5 = nil;
    [titleLbl6 release];
    titleLbl6 = nil;
    [titleLbl7 release];
    titleLbl7 = nil;
    [titleLbl8 release];
    titleLbl8 = nil;
    [titleLbl9 release];
    titleLbl9 = nil;
    [menuBtn1 release];
    menuBtn1 = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Custom Badge

- (void)addCustomBadgeWithCount:(int)badgeCount toObjectWithFrame:(CGRect)objectFrame{
    if (badgeCount>0) {
        if (customBadge1) {
            [customBadge1 removeFromSuperview];
            customBadge1 = nil;
        }
        customBadge1 = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%d",badgeCount] 
                                          withStringColor:[UIColor whiteColor] 
                                           withInsetColor:[UIColor redColor] 
                                           withBadgeFrame:YES 
                                      withBadgeFrameColor:[UIColor whiteColor] 
                                                withScale:1.0
                                              withShining:YES];
        [customBadge1 setTag:111];
        [customBadge1 setFrame:CGRectMake(objectFrame.origin.x+objectFrame.size.width-customBadge1.frame.size.width/2, objectFrame.origin.y-customBadge1.frame.size.height/2, customBadge1.frame.size.width, customBadge1.frame.size.height)];
        [self.view addSubview:customBadge1];
        [customBadge1 retain];
    }
}

#pragma mark my functios

- (void)checkDelayedThemes{
    if (customBadge1) {
        [customBadge1 removeFromSuperview];
        customBadge1 = nil;
    }
    UIApplication* app = [UIApplication sharedApplication];
    app.applicationIconBadgeNumber = 0;
    if (IS_REPEAT_OPTION_ON) {
        NSArray *repeatDelayedThemes = [[NSArray alloc] initWithArray:[[iTeachWordsAppDelegate sharedDelegate] loadRepeatDelayedTheme]];
        int repeatDelayedThemesCount = 0;
        if ([repeatDelayedThemes count]>0) {
            for (int i=0;i<[repeatDelayedThemes count];i++){
                NSDictionary *dict = [repeatDelayedThemes objectAtIndex:i];
                int interval = [[dict objectForKey:@"intervalToNexLearning"] intValue];
                if (interval < 0) {
                    ++repeatDelayedThemesCount;
                }
            }
            UIApplication* app = [UIApplication sharedApplication];
            app.applicationIconBadgeNumber = repeatDelayedThemesCount;
            [self addCustomBadgeWithCount:repeatDelayedThemesCount toObjectWithFrame:menuBtn1.frame];
        } 
        [repeatDelayedThemes release];
    }
    
}

- (void)addInfoButton{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [btn addTarget:self action:@selector(showInfoView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
}

- (void)setTitles{
    [titleLbl1 setText:NSLocalizedString(@"Word book", @"")];
    [titleLbl2 setText:NSLocalizedString(@"Search translate", @"")];
    [titleLbl4 setText:NSLocalizedString(@"Add new word", @"")];
    [titleLbl5 setText:NSLocalizedString(@"Speech Translator", @"")];
    [titleLbl6 setText:NSLocalizedString(@"Web", @"")];
    [titleLbl7 setText:NSLocalizedString(@"Settings", @"")];
    [titleLbl8 setText:NSLocalizedString(@"Vocalizer", @"")];
    [titleLbl9 setText:NSLocalizedString(@"Recognizer", @"")];
}


- (void)showInfoView{
    DetailViewController *infoView = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
//    [self performTransitionType:kCATransitionPush subType:kCATransitionFromBottom];
//    [self.navigationController pushViewController:infoView animated:YES];
    [self.navigationController presentModalViewController:infoView animated:YES];
    [infoView loadContentByFile:NSLocalizedString(@"GeneralInfo", @"")];
    [infoView release];
}

- (void)showLastItem{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastItem"]) {
        int lastItem = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastItem"];
        switch (lastItem) {
            case 0:
            case 1:
            case 4:
                [self showOptionView:nil];
                break;
            default:
                break;
        }
    }    
}

- (IBAction)showOptionView:(id)sender {
    if ([iTeachWordsAppDelegate isAppHacked]) {
        [UIAlertView displayError:NSLocalizedString(@"You are using a hacked app!!!", @"")];
        return;
    }
    if (!IS_HELP_MODE) {
        [UIAlertView displayGuideMessage:NSLocalizedString(@"If you will have a problem with value of buttons you can make available a help mode within the Settings view.", @"") title:NSLocalizedString(@"Suggestion", @"")];
    }
    int selectedButtonIndex = (sender)?((UIButton*)sender).tag:[[NSUserDefaults standardUserDefaults] integerForKey:@"lastItem"];
    [[NSUserDefaults standardUserDefaults] setInteger:selectedButtonIndex forKey:@"lastItem"];
    switch (selectedButtonIndex) {
        case 1:{
            [self showTeachView];          
        }
            break;
//        case 2:{
//            MenuLessons *lessonMenu = [[MenuLessons alloc] initWithNibName:@"MenuLessons" bundle:nil];
//            [self.navigationController pushViewController:lessonMenu animated:YES];
//            //            LM7 *lessonMaker = [[LM7 alloc] initWithNibName:@"LM7" bundle:nil];
//            //            [self.navigationController pushViewController:lessonMaker animated:YES];
//            //            lessonMaker.textContent = @"Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user. Quits the application and it begins the transition to the background state.";
//            //            [lessonMaker release];
//            
//        }
//            break;        
        case 2:{
            [self showDictionaryView] ;
        }
            break; 
        case 4:{
            [self showAddingWordView];
        }
            break;           
        case 5:{
            [self showTextParserView]; 
        }
            break;          
        case 6:{
            [self showWebView]; 
        }
            break;       
        case 7:{
            //            LanguagePickerController *languageView = [[LanguagePickerController alloc] initWithNibName:@"LanguagePickerController" bundle:nil];
            //            [self.navigationController pushViewController:languageView animated:YES];
            //            [languageView release];          
            
            [self showSettingsView];
        }  
            break;      
        case 8:{
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            [self showVocalizerView];
        }  
            break;      
        case 9:{
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            [self showRecognizerView];
        }
            break;
        default:
            break;
    }
}

#pragma mark showing  functions

- (void)showTeachView{
//    NSLog(@"%d",[usedObjects indexOfObject:menuBtn1]);
//    if ([usedObjects indexOfObject:menuBtn1] == NSNotFound) {
//        _currentSelectedObject = menuBtn1;
//        [_hint presentModalMessage:@"One last hint for ya." where:self.view];
//        return;
//    }

    WorldTableToolsController *myTableView = [[WorldTableToolsController alloc] initWithNibName:@"WorldTableViewController" bundle:nil];
    [self.navigationItem setBackBarButtonItem: BACK_BUTTON];
//    [self performTransitionType:kCATransitionPush subType:kCATransitionFromBottom];
    [self.navigationController pushViewController:myTableView animated:YES];
    [myTableView release];
}

- (void)showAddingWordView{
    TranslateViewController *myAddWordView = [[TranslateViewController alloc] initWithNibName:@"TranslateViewController" bundle:nil];
    [myAddWordView setDelegate:self];
    [self.navigationItem setBackBarButtonItem: BACK_BUTTON];
//    [self performTransitionType:kCATransitionPush subType:kCATransitionFromLeft];
    [self.navigationController pushViewController:myAddWordView animated:YES];
    [myAddWordView release]; 
}

- (void)showTextParserView{
    TextViewController *myTextView = [[TextViewController alloc] initWithNibName:@"TextViewController" bundle:nil];
    [self.navigationItem setBackBarButtonItem: BACK_BUTTON];
//    [self performTransitionType:kCATransitionPush subType:kCATransitionReveal];
    [self.navigationController pushViewController:myTextView animated:YES];
    [myTextView release];
}

- (void)showDictionaryView{
    DictionaryViewController *dictionaryView = [[DictionaryViewController alloc] initWithNibName:@"DictionaryViewController" bundle:nil];
    [self.navigationItem setBackBarButtonItem: BACK_BUTTON];
//    [self performTransitionType:kCATransitionPush subType:kCATransitionFromBottom];
    [self.navigationController pushViewController:dictionaryView animated:YES];
    [dictionaryView release];
}

- (void)showSettingsView{
    SettingsViewController *languageView = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
    [self.navigationItem setBackBarButtonItem: BACK_BUTTON];
//    [self performTransitionType:kCATransitionPush subType:kCATransitionFromTop];
    [languageView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self.navigationController pushViewController:languageView animated:YES];
    [languageView release];
}

- (void)showWebView {
    WebViewController *webViewController = [[WebViewController alloc] initWithFrame:self.view.frame];
    NSString *url ;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"LastUrl"] && [[NSUserDefaults standardUserDefaults] stringForKey:@"LastUrl"]!= NULL) {
        url = [[NSUserDefaults standardUserDefaults] stringForKey:@"LastUrl"];
    }else{
        url = @"www.yandex.com";
    }
    [self.navigationItem setBackBarButtonItem: BACK_BUTTON];
	[self.navigationController pushViewController:webViewController animated:YES];
    webViewController.url = url;
	[webViewController release];

}

- (void)showVocalizerView{
    DMVocalizerViewController *vocalizerView = [[DMVocalizerViewController alloc] initWithNibName:@"DMVocalizerViewController" bundle:nil];
    [self.navigationItem setBackBarButtonItem: BACK_BUTTON];
    [self.navigationController pushViewController:vocalizerView animated:YES];
    [vocalizerView release];
}

- (void)showThemes{
    ThemesTableView *themesTableView = [[ThemesTableView alloc] initWithNibName:@"ThemesTableView" bundle:nil];
    [self.navigationController pushViewController:themesTableView animated:YES];
    [themesTableView release];
}

- (void)showRecognizerView{
    DMRecognizerViewController *recognizerView = [[DMRecognizerViewController alloc] initWithNibName:@"DMRecognizerViewController" bundle:nil];
    [self.navigationItem setBackBarButtonItem: BACK_BUTTON];
    [self.navigationController pushViewController:recognizerView animated:YES];
    [recognizerView release];
}

-(void)performTransitionType:(NSString*)type subType:(NSString*)subType {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = subType;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

#ifdef FREE_VERSION
- (void)showPurchasePagesView{
    PurchaseStoreMenuView *purchaseStoreMenu = [[PurchaseStoreMenuView alloc] initWithNibName:@"PurchaseStoreMenuView" bundle:nil];
    [purchaseStoreMenu setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:purchaseStoreMenu animated:YES];
    [purchaseStoreMenu release];
}
#endif

@end
