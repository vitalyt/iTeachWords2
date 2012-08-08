//
//  FBFunLoginDialog.m
//  FBFun
//
//  Created by Ray Wenderlich on 7/13/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "FBFunLoginDialog.h"

@implementation FBFunLoginDialog
@synthesize webView = _webView;
@synthesize apiKey = _apiKey;
@synthesize requestedPermissions = _requestedPermissions;
@synthesize delegate = _delegate;

#pragma mark Main

- (id)initWithAppId:(NSString *)apiKey requestedPermissions:(NSString *)requestedPermissions delegate:(id<FBFunLoginDialogDelegate>)delegate {
    if ((self = [super initWithNibName:@"FBFunLoginDialog" bundle:[NSBundle mainBundle]])) {
        self.apiKey = apiKey;
        self.requestedPermissions = requestedPermissions;
        self.delegate = delegate;
    }
    return self;    
}

- (void)dealloc {
    self.webView = nil;
    self.apiKey = nil;
    self.requestedPermissions = nil;
    [navigationBar release];
    [super dealloc];
}

- (void)viewDidLoad{
    [super viewDidLoad];
}
#pragma mark Login / Logout functions

- (void)login {
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
       
    NSString *redirectUrlString = @"http://www.facebook.com/connect/login_success.html";
    NSString *authFormatString = @"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch";
       
    NSString *urlString = [NSString stringWithFormat:authFormatString, _apiKey, redirectUrlString, _requestedPermissions];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];	   
}

-(void)logout {    
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    
    [self checkForAccessToken:urlString];    
    [self checkLoginRequired:urlString];
    
    return TRUE;
}

#pragma mark Helper functions

-(void)checkForAccessToken:(NSString *)urlString {
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"access_token=(.*)&" options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_delegate accessTokenFound:accessToken];               
        }
    }
}

-(void)checkLoginRequired:(NSString *)urlString {
    NSLog(@"Url: %@",urlString);
    if ([urlString rangeOfString:@"login.php"].location != NSNotFound && [urlString rangeOfString:@"refid"].location == NSNotFound) {
        [_delegate displayRequired];
    } else if ([urlString rangeOfString:@"user_denied"].location != NSNotFound) {
        [_delegate closeTapped];
    }
}

- (IBAction)closeTapped:(id)sender {
    [_delegate closeTapped];
}

- (void)viewDidUnload {
    [navigationBar release];
    navigationBar = nil;
    [super viewDidUnload];
}
@end
