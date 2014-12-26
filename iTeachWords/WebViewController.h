#import <UIKit/UIKit.h>
#import "AddWordOptionsView.h"

@interface WebViewController : AddWordOptionsView <UIWebViewDelegate,UITextFieldDelegate,UIWebViewDelegate>
{
    IBOutlet UIToolbar *toolbar;
    IBOutlet UIToolbar *urlToolbar;
    IBOutlet UITextField *urlFld;
    IBOutlet UIBarButtonItem *forwardBtn;
    IBOutlet UIBarButtonItem *backBtn;
	NSString *url;
	NSString *title;
	BOOL	flgLoad;
	BOOL	flgInternalLink;
	@protected
	NSMutableArray *textZoomer;
	UIActivityIndicatorView *progressView;
    NSString *modifiedDatetime;
    bool isUpdatedData;
}

@property (nonatomic,assign) UIWebView *webView;
@property (nonatomic,retain) NSString *url;
@property (nonatomic,retain) NSString *modifiedDatetime;
@property (nonatomic) BOOL flgInternalLink;

- (id)initWithFrame:(CGRect)frame;
-(void) hideAlert:(id)sender;
-(WebViewController *)initWithUrl: (NSString *) u;
- (void)clearContent;
- (void)loadContent;

- (IBAction)loadUrl:(id)sender;
- (IBAction)undo:(id)sender;
- (IBAction)redo:(id)sender;
- (IBAction)refresh:(id)sender;
- (IBAction)showInSafari:(id)sender;
- (void)reviewButtons;

@end
