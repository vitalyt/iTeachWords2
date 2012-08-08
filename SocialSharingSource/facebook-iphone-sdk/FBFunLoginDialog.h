//
//  FBFunLoginDialog.h
//  FBFun
//
//  Created by Ray Wenderlich on 7/13/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FBFunLoginDialogDelegate
- (void)accessTokenFound:(NSString *)apiKey;
- (void)displayRequired;
- (void)closeTapped;
@end

@interface FBFunLoginDialog : UIViewController <UIWebViewDelegate> {
    IBOutlet UINavigationBar *navigationBar;
    UIWebView *_webView;
    NSString *_apiKey;
    NSString *_requestedPermissions;
    id <FBFunLoginDialogDelegate> _delegate;
}

@property (retain) IBOutlet UIWebView *webView;
@property (copy) NSString *apiKey;
@property (copy) NSString *requestedPermissions;
@property (assign) id <FBFunLoginDialogDelegate> delegate;

- (id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions delegate:(id<FBFunLoginDialogDelegate>)delegate;
- (IBAction)closeTapped:(id)sender;
- (void)login;
- (void)logout;

-(void)checkForAccessToken:(NSString *)urlString;
-(void)checkLoginRequired:(NSString *)urlString;

@end
