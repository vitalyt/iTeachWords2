#import "SimpleWebViewController.h"
#import "OsdnDataBase.h"

#define documentsDirectory_Statement NSString *documentsDirectory; \
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); \
documentsDirectory = [paths objectAtIndex:0];

@implementation SimpleWebViewController

@synthesize url,webView;

-init
{
	return [self initWithUrl: @""];
}

- (id)initWithFrame:(CGRect)frame{
    if (!webView) {
        webView = [[UIWebView alloc] initWithFrame:frame];
        webView.delegate = self;
    }
    return [self initWithUrl: @""];
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

- (void)webViewDidStartLoad:(UIWebView *)_webView{
    if (!progressView) {
        progressView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-12, self.view.frame.size.height/2-12, 25, 25)];  
        progressView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;  
        progressView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |  
                                         UIViewAutoresizingFlexibleRightMargin |  
                                         UIViewAutoresizingFlexibleTopMargin |  
                                         UIViewAutoresizingFlexibleBottomMargin);
    } 
    [_webView addSubview:progressView];
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
    if (!webView) {
        webView = [[UIWebView alloc] initWithFrame: CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height-44)];
        webView.delegate = self;
    }
    [self loadContent];
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
    requestObj = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [webView loadRequest:requestObj];
}

- (void)clearContent{
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML = \"\";"];
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
	[webView release];
    [super dealloc];
}


@end
