#import "WebViewController.h"
#import "OsdnDataBase.h"

#define documentsDirectory_Statement NSString *documentsDirectory; \
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); \
documentsDirectory = [paths objectAtIndex:0];

@implementation WebViewController

@synthesize url, title,flgInternalLink,webView,modifiedDatetime;

-init
{
	return [self initWithUrl: @""];
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithNibName:@"WebViewController" bundle:nil];
    if (!webView) {
        webView = [[UIWebView alloc] initWithFrame:frame];
        webView.delegate = self;
        [webView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(WebViewController *)initWithUrl: (NSString *)u
{
	self = [super initWithNibName:@"WebViewController" bundle:nil];
    [self clearContent];
    if (u && [u length]>0) {
        [self setUrl:u];
    }
	return self;
}


- (void)webViewDidStartLoad:(UIWebView *)_webView{
    if (!progressView) {
        progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(webView.frame.size.width/2-12, webView.frame.size.height/2-12, 25, 25)];  
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;  
        progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |  
                                         UIViewAutoresizingFlexibleRightMargin |  
                                         UIViewAutoresizingFlexibleTopMargin |  
                                         UIViewAutoresizingFlexibleBottomMargin);
    } 
    
//	NSURLRequest *urlRequest = [_webView request];
	//NSURL *u = [urlRequest mainDocumentURL];
    [self reviewButtons];
    urlFld.text = self.url;
    [_webView addSubview:progressView];
    [progressView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)_webView{
	NSURLRequest *urlRequest = [_webView request];
	NSURL *u = [urlRequest mainDocumentURL];
    [urlFld setText:[u absoluteString]];
    [[NSUserDefaults standardUserDefaults] setValue:[u absoluteString] forKey:@"LastUrl"];
	if (isUpdatedData) {
        isUpdatedData = NO;
		[OsdnDataBase addWebBaseWithURL:[u absoluteString] data:u];		
	}
    [progressView removeFromSuperview];
    [self reviewButtons];
    //[progressView release];    	
}

-(void) hideAlert:(id)sender{    
    [progressView removeFromSuperview];   
}  

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad 
{
	[super viewDidLoad];
    
    [self.navigationItem setTitle:NSLocalizedString(@"iStudyWords", @"")];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
//    if (urlFld) {
//        self.url = [[NSUserDefaults standardUserDefaults] setValue:_url forKey:@"LastUrl"];
//    }

    if (!webView) {
        webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 44+urlToolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
    }
    webView.delegate = self;
    [urlFld setDelegate:self];
    [toolbar setFrame:CGRectMake(0, self.view.frame.size.height-toolbar.frame.size.height, toolbar.frame.size.width, toolbar.frame.size.height)];
    [urlToolbar setFrame:CGRectMake(0, 44, urlToolbar.frame.size.width, urlToolbar.frame.size.height)];
    [webView setFrame:CGRectMake(0.0, 44+urlToolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-urlToolbar.frame.size.height)];
	[self.view insertSubview:webView belowSubview:toolbar];
    [self.view bringSubviewToFront:urlToolbar];
    [self loadContent];
    
    [urlFld setText:url];
    CGRect barFrame = self.bar.frame;
    [self.bar setFrame:CGRectMake(barFrame.origin.x, 370, barFrame.size.width, barFrame.size.height)];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)setUrl:(NSString *)_url{
    if (url == _url) {
        return;
    }
    if (url) {
        [url release];
    }
    if (![_url hasPrefix:@"http://"]) {
        _url = [NSString stringWithFormat:@"http://%@",_url];
    }
    url = [_url retain];
    [self loadContent];
}

- (void)reviewButtons{
    [backBtn setEnabled:([webView canGoBack])?YES:NO];
    [forwardBtn setEnabled:([webView canGoForward])?YES:NO];
}

- (void)loadContent{
    [webView stopLoading];
    [self reviewButtons];
    [self clearContent];
    if (!url) {
        return;
    }
    NSURLRequest *requestObj;
    if ([iTeachWordsAppDelegate  isNetwork]) {
        requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        NSLog(@"requestObj->%@",requestObj);
        isUpdatedData = YES;
        [webView loadRequest:requestObj];
        return;
    }
    NSString *myData = [OsdnDataBase loadWebBaseWithURL:url];
    if (myData  != nil) {
        isUpdatedData = NO;
        [webView loadHTMLString:myData baseURL:[NSURL URLWithString:url]];
    }else{
        isUpdatedData = YES;
        requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [webView loadRequest:requestObj];
    }
}

- (IBAction)loadUrl:(id)sender {
    self.url = urlFld.text;
    [urlFld resignFirstResponder];
}

- (IBAction)undo:(id)sender {
    [webView goBack];
}

- (IBAction)redo:(id)sender {
    [webView goForward];
}

- (IBAction)refresh:(id)sender {
    [webView reload];
}

- (IBAction)showInSafari:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
	

- (void)clearContent{
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
//    [webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}
//
//-(void)back
//{
//    
//	[self dismissModalViewControllerAnimated:YES];
//}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    NSLog(@"%@",NSStringFromSelector(action));
    if (action == @selector(select:)) {
        NSString *selectedText = [self getSelectedText];
        if (selectedText.length > 0 && !isExpandingBarShowed) {
            [self.bar showButtonsAnimated:YES];
            isExpandingBarShowed = YES;
        }
    }
    if (action == @selector(parseText:) || action == @selector(translateText:) || action == @selector(playText:)) {
        return YES;
    }
    return NO;
}


- (NSString *)getSelectedText{
    NSString *selectedText = [webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    return selectedText;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self loadUrl:nil];
    return YES;
}

- (void)dealloc 
{
    if (progressView) {
        [progressView release];
    }
    [modifiedDatetime release];
	[url release];
	[title release];
	[webView release];
    [urlToolbar release];
    [urlFld release];
    [forwardBtn release];
    [backBtn release];
    [super dealloc];
}


- (void)viewDidUnload {
    [urlToolbar release];
    urlToolbar = nil;
    [urlFld release];
    urlFld = nil;
    [forwardBtn release];
    forwardBtn = nil;
    [backBtn release];
    backBtn = nil;
    [super viewDidUnload];
}
@end
