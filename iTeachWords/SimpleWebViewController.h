#import <UIKit/UIKit.h>

@interface SimpleWebViewController : UIViewController < UIWebViewDelegate>
{
	NSString *url;
	BOOL	flgLoad;
	BOOL	flgInternalLink;
@private
    IBOutlet UIWebView *_webView;
	UIActivityIndicatorView *progressView;
}

@property (nonatomic,retain) NSString *url;

- (id)initWithFrame:(CGRect)frame;
-(void) hideAlert:(id)sender;
-(SimpleWebViewController *)initWithUrl: (NSString *) u;
- (void)clearContent;
- (void)loadContent;
- (void)loadContentByFile:(NSString*)fileName;
- (UIWebView*)webView;
@end
