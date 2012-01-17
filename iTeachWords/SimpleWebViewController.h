#import <UIKit/UIKit.h>

@interface SimpleWebViewController : UIViewController < UIWebViewDelegate>
{
	NSString *url;
	BOOL	flgLoad;
	BOOL	flgInternalLink;
@protected
    UIWebView *webView;
	UIActivityIndicatorView *progressView;
}

@property (nonatomic,assign) UIWebView *webView;
@property (nonatomic,retain) NSString *url;

- (id)initWithFrame:(CGRect)frame;
-(void) hideAlert:(id)sender;
-(SimpleWebViewController *)initWithUrl: (NSString *) u;
- (void)clearContent;
- (void)loadContent;

@end
