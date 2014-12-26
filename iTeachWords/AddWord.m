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
        [iTeachWordsAppDelegate clearUdoManager];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                        initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered
                                        target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = backButton;
        wordsView = [[AddNewWordViewController alloc] initWithNibName:@"AddNewWordViewController" bundle:nil];
        [wordsView setDelegate:self];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedString(@"iStudyWords", @"")];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
    [self.view addSubview:wordsView.view];
    [searchTranslateLbl setText:NSLocalizedString(@"Tap to find more translations", @"")];
    [wordsView.view setFrame:CGRectMake(.0, 44, wordsView.view.frame.size.width,wordsView.view.frame.size.height)];
    
    loadWebButtonView.layer.cornerRadius = 10;
    loadWebButtonView.layer.borderWidth = 1;
    loadWebButtonView.layer.borderColor = [[UIColor grayColor] CGColor];
    myWebView.layer.cornerRadius = 10;
    //[wordsView loadData];
}

- (IBAction) showMyPickerView{
    [wordsView showMyPickerView:nil];
}

- (void) back{
	[wordsView back];
}

//#pragma mark Alert functions
//
- (IBAction) loadWebViewWithUrl:(NSString*)url
{
    [self clearWebViewContent];
    [loadWebButtonView setHidden:YES];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[url  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    //NSLog(@"%@",dataModel.urlShow);
    myWebView.delegate = self;
    [myWebView loadRequest:requestObj];
}

- (IBAction) loadWebViewWithHtml:(NSString*)html
{
    [self clearWebViewContent];
    [loadWebButtonView setHidden:YES];
    [myWebView loadHTMLString:html baseURL:nil];
    myWebView.delegate = self;
}

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
    UIMenuItem *menuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Use as translate", @"")
                                                       action:@selector(parceTranslateWord)];
    [menuItemsMutableArray addObject:menuItem];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect: CGRectMake(0, 0, 320, 200)
                           inView:self.view];
    menuController.menuItems = menuItemsMutableArray;
    [menuController setMenuVisible:YES
                          animated:YES];
    [[UIMenuController sharedMenuController] setMenuItems:menuItemsMutableArray];
}

- (void)parceTranslateWord{
    NSString *selectedText = [myWebView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    selectedText = [NSString removeSpaces:selectedText];
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
    [wordsView save:nil];
}

- (void)showWebLoadingView{
    if (loadWebButtonView.hidden) {
        [loadWebButtonView setHidden:NO];
        [myWebView stopLoading];
    }
}

- (void)viewDidUnload {    [super viewDidUnload];
}
@end
