//
//  AddWord.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 4/29/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "AddWord.h"
#import "MyPickerViewContrller.h"
#import "WordTypes.h"
#import "Words.h"
#import "WBEngine.h"
#import "WBRequest.h"
#import "WBConnection.h"
#import "RecordingWordViewController.h"
#import "AddNewWordViewController.h"
//#define radius 10

@implementation AddWord
@synthesize myTextFieldEng,myTextFieldRus,myPickerLabel;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                        initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered
                                        target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = [backButton autorelease];
        wordsView = [[AddNewWordViewController alloc] initWithNibName:@"AddNewWordViewController" bundle:nil];
//        [wordsView.view setFrame:CGRectMake(.0, 44, wordsView.view.frame.size.width,wordsView.view.frame.size.height)];
        [wordsView setDelegate:self];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    loadWebButtonView.layer.cornerRadius = 10;
    myWebView.layer.cornerRadius = 10;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
    [self.view addSubview:wordsView.view];
    [searchingTranslateBtn setTitle:NSLocalizedString(@"Tap to find more translations", @"") forState:UIControlStateNormal];
    //[wordsView loadData];
}

- (IBAction) showMyPickerView{
    [wordsView showMyPickerView];
}

- (void) back{
	[wordsView back];
}

//#pragma mark Alert functions
//
//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//	if (buttonIndex == 1) {
//		[wordsView save];
//	}
//	else if (buttonIndex == 0){
//        [wordsView.dataModel.wordType removeWordsObject:wordsView.dataModel.currentWord];
//        NSError *_error;
//        if (![CONTEXT save:&_error]) {
//            [UIAlertView displayError:@"Data is not saved."];
//        }
//        
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
//        [self.navigationController popViewControllerAnimated:YES];
//	}
//	else if (buttonIndex == 0){
//		return;
//	}
//}

- (void)setThemeName{
    [self.navigationItem setPrompt:[NSString stringWithFormat:NSLocalizedString(@"Current theme is %@", @""),wordsView.dataModel.wordType.name]];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (IBAction) loadWebView
{
    if ([iTeachWordsAppDelegate isNetwork]) {
        [self clearWebViewContent];
        [loadWebButtonView setHidden:YES];
        [wordsView closeAllKeyboard];
        [wordsView.dataModel createUrls];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[wordsView.dataModel.urlShow  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        //NSLog(@"%@",dataModel.urlShow);
        myWebView.delegate = self;
        [myWebView loadRequest:requestObj];
    }
}

- (void)clearWebViewContent{
    [myWebView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
    //    [webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [animationView stopAnimating];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [animationView startAnimating];
}

- (void)createMenu{
    [self becomeFirstResponder];
    NSMutableArray *menuItemsMutableArray = [NSMutableArray new];
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Use as translate", @"")
                                                       action:@selector(parceTranslateWord)] autorelease];
    [menuItemsMutableArray addObject:menuItem];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect: CGRectMake(0, 0, 320, 200)
                           inView:self.view];
    menuController.menuItems = menuItemsMutableArray;
    [menuController setMenuVisible:YES
                          animated:YES];
    [[UIMenuController sharedMenuController] setMenuItems:menuItemsMutableArray];
    [menuItemsMutableArray release];
}

- (void)parceTranslateWord{
    NSString *selectedText = [myWebView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    [wordsView setTranslate:selectedText];
}

- (void)setText:(NSString*)text{
    [wordsView setText:text];
}

- (void)setTranslate:(NSString*)text{
    [wordsView setTranslate:text];
}

- (void)setWord:(Words *)_word{
    [wordsView setWord:_word];
}

- (void)save{
    [wordsView save];
}

- (void)showWebLoadingView{
    if (loadWebButtonView.hidden) {
        [loadWebButtonView setHidden:NO];
        [myWebView stopLoading];
    }
}

- (void)dealloc {
    if (myWebView) {
        myWebView.delegate = nil;
        [myWebView release];
    }
    [wordsView release];
    [loadWebButtonView release];
    [animationView release];
    [searchingTranslateBtn release];
    [super dealloc];
}

- (void)viewDidUnload {
    [loadWebButtonView release];
    loadWebButtonView = nil;
    [animationView release];
    animationView = nil;
    [searchingTranslateBtn release];
    searchingTranslateBtn = nil;
    [super viewDidUnload];
}
@end
