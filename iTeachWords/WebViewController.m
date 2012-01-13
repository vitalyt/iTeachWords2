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
    if (!webView) {
        webView = [[UIWebView alloc] initWithFrame:frame];
        webView.delegate = self;
        [webView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    }
    return [self initWithUrl: @""];
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
        progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-12, self.view.frame.size.height/2-12, 25, 25)];  
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;  
        progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |  
                                         UIViewAutoresizingFlexibleRightMargin |  
                                         UIViewAutoresizingFlexibleTopMargin |  
                                         UIViewAutoresizingFlexibleBottomMargin);
    } 
    
	NSURLRequest *urlRequest = [_webView request];
	//NSURL *u = [urlRequest mainDocumentURL];
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
    //[progressView release];    	
}

-(void) hideAlert:(id)sender{    
    [progressView removeFromSuperview];   
}  

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

-(void)viewDidLoad 
{
	[super viewDidLoad];
    //self.url = [[NSUserDefaults standardUserDefaults] setValue:_url forKey:@"LastUrl"];
    if (!webView) {
        webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, urlToolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)];
        webView.delegate = self;
    }
    [urlFld setDelegate:self];
    [toolbar setFrame:CGRectMake(0, self.view.frame.size.height-toolbar.frame.size.height, toolbar.frame.size.width, toolbar.frame.size.height)];
    [urlToolbar setFrame:CGRectMake(0, 0, urlToolbar.frame.size.width, urlToolbar.frame.size.height)];
    [webView setFrame:CGRectMake(0.0, urlToolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height-urlToolbar.frame.size.height)];
	[self.view insertSubview:webView belowSubview:toolbar];
    [self.view bringSubviewToFront:urlToolbar];
    [self loadContent];
    
    [urlFld setText:url];
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

- (void)loadContent{
    [webView stopLoading];
    [self clearContent];
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
    [super dealloc];
}


- (void)viewDidUnload {
    [urlToolbar release];
    urlToolbar = nil;
    [urlFld release];
    urlFld = nil;
    [super viewDidUnload];
}
@end
