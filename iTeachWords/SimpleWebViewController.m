#import "SimpleWebViewController.h"
#import "OsdnDataBase.h"

#define documentsDirectory_Statement NSString *documentsDirectory; \
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); \
documentsDirectory = [paths objectAtIndex:0];

@implementation SimpleWebViewController

@synthesize url;


-init
{
	return [self initWithUrl: @""];
}

- (id)initWithFrame:(CGRect)frame{
	self = [super init];
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.delegate = self;
    }
    return self;
}

- (UIWebView*)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 0.0, 320, 480)];
        _webView.delegate = self;
    }
    return _webView;
}

-(SimpleWebViewController *)initWithUrl: (NSString *)u
{
	self = [super initWithNibName:@"WebViewController" bundle:nil];
    [self clearContent];
    if (u && [u length]>0) {
        [self setUrl:u];
    }
	return self;
}

- (void)webViewDidStartLoad:(UIWebView *)__webView{
    if (!progressView) {
        progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-10, self.view.frame.size.height/2-10, 20, 20)];  
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;  
        progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |  
                                         UIViewAutoresizingFlexibleRightMargin |  
                                         UIViewAutoresizingFlexibleTopMargin |  
                                         UIViewAutoresizingFlexibleBottomMargin);
    } 
    [__webView addSubview:progressView];
    [progressView startAnimating];
}
- (void)webViewDidFinishLoad:(UIWebView *)_webView{
    [progressView removeFromSuperview];  
    //[progressView release];    	
}

-(void) hideAlert:(id)sender{    
    [progressView removeFromSuperview];   
}  



-(void)viewDidLoad 
{
	[super viewDidLoad];
//    _webView.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-44);
    [self.view addSubview:[self webView]];
//    [self loadContent];
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
    NSLog(@"Loading->%@",_url);
    url = [_url retain];
    [self loadContent];
}

- (void)loadContent{
//    [self loadContentByFile:@"Instructie"];
//    return;
    [[self webView] stopLoading];
    [self clearContent];
    NSURLRequest *requestObj;
    requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [[self webView] loadRequest:requestObj];
}

- (void)loadContentByFile:(NSString*)fileName{
    [[self webView] stopLoading];
    [self clearContent];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
    NSLog(@"%@",path);

    NSURL *mainBundleURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    if (path) {
        NSError *error = nil;
        NSURL *_url = [NSURL fileURLWithPath:path];
        NSString *_html = [NSString stringWithContentsOfURL:_url 
                                                  encoding:NSUTF8StringEncoding
                                                     error:&error];
        NSString *htmlData = [NSMutableString stringWithString:_html ];
        [[self webView] loadHTMLString:htmlData baseURL:mainBundleURL];
    }
}

- (void)clearContent{
    [[self webView] stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
    //    [webView loadHTMLString:@"<html><head></head><body></body></html>" baseURL:nil];
}
-(void)back
{
	[self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc 
{
    if (progressView) {
        [progressView release];
    }
	[url release];
	[_webView release];
    [super dealloc];
}


@end
