//
//  AddWord.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 4/29/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface SemiWebViewController : UIViewController <UIWebViewDelegate, UITextFieldDelegate, UIActionSheetDelegate,UIWebViewDelegate>{
	IBOutlet UIWebView		*myWebView;
    IBOutlet UIView         *loadWebButtonView;
    IBOutlet UIActivityIndicatorView *animationView;
    IBOutlet UIButton *searchingTranslateBtn;
    IBOutlet UILabel *searchTranslateLbl;
}

- (void)     showWebLoadingView;
- (void)     clearWebViewContent;
- (IBAction) loadWebViewWithUrl:(NSString*)url;
- (IBAction) loadWebViewWithHtml:(NSString*)html;

@end
