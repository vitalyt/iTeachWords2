//
//  AddWord.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 4/29/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "SemiWebViewController.h"
//#define radius 10

@implementation SemiWebViewController

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
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedString(@"iStudyWords", @"")];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
    [searchTranslateLbl setText:NSLocalizedString(@"Tap to find more translations", @"")];
    
    loadWebButtonView.layer.cornerRadius = 5;
    loadWebButtonView.layer.borderWidth = 1;
    loadWebButtonView.layer.borderColor = [[UIColor grayColor] CGColor];
    myWebView.layer.cornerRadius = 5;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

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
        myWebView = nil;
    }
    [loadWebButtonView release];
    [animationView release];
    [searchingTranslateBtn release];
    [searchTranslateLbl release];
    [super dealloc];
}

- (void)viewDidUnload {
    [loadWebButtonView release];
    loadWebButtonView = nil;
    [animationView release];
    animationView = nil;
    [searchingTranslateBtn release];
    searchingTranslateBtn = nil;
    [searchTranslateLbl release];
    searchTranslateLbl = nil;
    [super viewDidUnload];
}
@end
