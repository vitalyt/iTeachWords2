//
//  FBFunViewController.m
//  FBFun
//
//  Created by Ray Wenderlich on 7/13/10.
//  Copyright Ray Wenderlich 2010. All rights reserved.
//

#import "FBFunViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"

@implementation FBFunViewController
@synthesize loginStatusLabel = _loginStatusLabel;
@synthesize loginButton = _loginButton;
@synthesize loginDialog = _loginDialog;
@synthesize loginDialogView = _loginDialogView;
@synthesize textView = _textView;
@synthesize imageView = _imageView;
@synthesize segControl = _segControl;
@synthesize webView = _webView;
@synthesize accessToken = _accessToken;

#pragma mark Main

- (void)dealloc {
    self.loginStatusLabel = nil;
    self.loginButton = nil;
    self.loginDialog = nil;
    self.loginDialogView = nil;
    self.textView = nil;
    self.imageView = nil;
    self.segControl = nil;
    self.webView = nil;
    self.accessToken = nil;
    [super dealloc];
}

- (void)refresh {
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
        _loginStatusLabel.text = @"Not connected to Facebook";
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        _loginButton.hidden = NO;
    } else if (_loginState == LoginStateLoggingIn) {
        _loginStatusLabel.text = @"Connecting to Facebook...";
        _loginButton.hidden = YES;
    } else if (_loginState == LoginStateLoggedIn) {
        _loginStatusLabel.text = @"Connected to Facebook";
        [_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        _loginButton.hidden = NO;
    }   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self refresh];
}

#pragma mark Login Button

- (IBAction)loginButtonTapped:(id)sender {
    
    NSString *appId = @"207459929376099";
    NSString *permissions = @"publish_stream";
    
    if (_loginDialog == nil) {
        self.loginDialog = [[[FBFunLoginDialog alloc] initWithAppId:appId requestedPermissions:permissions delegate:self] autorelease];
        self.loginDialogView = _loginDialog.view;
    }
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
        _loginState = LoginStateLoggingIn;
        [_loginDialog login];
    } else if (_loginState == LoginStateLoggedIn) {
        _loginState = LoginStateLoggedOut;        
        [_loginDialog logout];
    }
    
    [self refresh];
    
}

#pragma mark FB Requests

- (void)showLikeButton {
    
    // Source: http://developers.facebook.com/docs/reference/plugins/like-box
    NSString *likeButtonIframe = @"<iframe src=\"http://www.facebook.com/plugins/likebox.php?id=207459929376099&amp;width=292&amp;connections=0&amp;stream=false&amp;header=false&amp;height=62\" scrolling=\"no\" frameborder=\"0\" style=\"border:none; overflow:hidden; width:282px; height:62px;\" allowTransparency=\"true\"></iframe>";
    NSString *likeButtonHtml = [NSString stringWithFormat:@"<HTML><BODY>%@</BODY></HTML>", likeButtonIframe];
    
    [_webView loadHTMLString:likeButtonHtml baseURL:[NSURL URLWithString:@""]];
    
}

- (void)getFacebookProfile {
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/me?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDidFinishSelector:@selector(getFacebookProfileFinished:)];
    
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)rateTapped:(id)sender {

    NSString *likeString;
    NSString *filePath = nil;
    if (_imageView.image == [UIImage imageNamed:@"angelina.jpg"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"angelina" ofType:@"jpg"];
        likeString = @"babe";
    } else if (_imageView.image == [UIImage imageNamed:@"depp.jpg"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"depp" ofType:@"jpg"];
        likeString = @"dude";
    } else if (_imageView.image == [UIImage imageNamed:@"maltese.jpg"]) {
        filePath = [[NSBundle mainBundle] pathForResource:@"maltese" ofType:@"jpg"];
        likeString = @"puppy";
    }
    likeString = @"angelina";
    filePath = [[NSBundle mainBundle] pathForResource:@"angelina" ofType:@"jpg"];

    if (filePath == nil) return;
    
    NSString *adjectiveString;
    if (_segControl.selectedSegmentIndex == 0) {
        adjectiveString = @"cute";
    } else {
        adjectiveString = @"ugly";
    }
    
    NSString *message = [NSString stringWithFormat:@"I am testing the iPhone app!", adjectiveString, likeString];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/photos?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request addFile:filePath forKey:@"file"];
    [request setPostValue:message forKey:@"message"];
//    [request setPostValue:[_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"access_token"];
    [request setDidFinishSelector:@selector(sendToPhotosFinished:)];
    NSLog(@"%@",_accessToken);
    [request setDelegate:self];
    [request startAsynchronous];
    
}

- (void)sendToPhotosFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *photoId = [responseJSON objectForKey:@"id"];
    NSLog(@"Photo id is: %@", photoId);
    
    NSString *urlString = [NSString stringWithFormat:@"https://graph.facebook.com/%@?access_token=%@", photoId, [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *newRequest = [ASIHTTPRequest requestWithURL:url];
    [newRequest setDidFinishSelector:@selector(getFacebookPhotoFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];
 
}

#pragma mark FB Responses

- (void)getFacebookProfileFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    NSLog(@"Got Facebook Profile: %@", responseString);
    
    NSString *likesString;
    NSMutableDictionary *responseJSON = [responseString JSONValue];   
    NSArray *interestedIn = [responseJSON objectForKey:@"interested_in"];
    if (interestedIn != nil) {
        NSString *firstInterest = [interestedIn objectAtIndex:0];
        if ([firstInterest compare:@"male"] == 0) {
            [_imageView setImage:[UIImage imageNamed:@"depp.jpg"]];
            likesString = @"dudes";
        } else if ([firstInterest compare:@"female"] == 0) {
            [_imageView setImage:[UIImage imageNamed:@"angelina.jpg"]];
            likesString = @"babes";
        }        
    } else {
        [_imageView setImage:[UIImage imageNamed:@"maltese.jpg"]];
        likesString = @"puppies";
    }
    
    NSString *username;
    NSString *firstName = [responseJSON objectForKey:@"first_name"];
    NSString *lastName = [responseJSON objectForKey:@"last_name"];
    if (firstName && lastName) {
        username = [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    } else {
        username = @"mysterious user";
    }
    
    _textView.text = [NSString stringWithFormat:@"Hi %@!  I noticed you like %@, so tell me if you think this pic is hot or not!",
                      username, likesString];
    
    [self refresh];    
    [self postToWall];
}

- (void)getFacebookPhotoFinished:(ASIHTTPRequest *)request
{
    NSString *responseString = [request responseString];
    NSLog(@"Got Facebook Photo: %@", responseString);
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];   
    
    NSString *link = [responseJSON objectForKey:@"link"];
//    if (link == nil) return;   
    NSLog(@"Link to photo: %@", link);
    
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/feed"];
    ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
    [newRequest setPostValue:@"I'm learning how to post to Facebook from an iPhone app!" forKey:@"message"];
    [newRequest setPostValue:@"Check out the tutorial!" forKey:@"name"];
    [newRequest setPostValue:@"This tutorial shows you how to post to Facebook using the new Open Graph API." forKey:@"caption"];
    [newRequest setPostValue:@"From Ray Wenderlich's blog - an blog about iPhone and iOS development." forKey:@"description"];
    [newRequest setPostValue:@"http://www.osdn.nl" forKey:@"link"];
    [newRequest setPostValue:@"http://d1xzuxjlafny7l.cloudfront.net/wp-content/uploads/2010/07/FacebookUpdateSmall.jpg" forKey:@"picture"];
    [newRequest setPostValue:_accessToken forKey:@"access_token"];
    [newRequest setDidFinishSelector:@selector(postToWallFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous];    
}

- (void)postToWall{

}

- (void)postToWallFinished:(ASIHTTPRequest *)request
{
    [UIAlertView removeMessage];
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSMutableDictionary *responseJSON = [responseString JSONValue];
    NSString *postId = [responseJSON objectForKey:@"id"];
    NSLog(@"Post id is: %@", postId);
    
    [UIAlertView displayMessage:NSLocalizedString(@"Request succeeded", @"")];
    
//    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Article has been posted!" 
//												  message:@"Check out your Facebook to see!"
//												 delegate:nil 
//										cancelButtonTitle:@"OK"
//										otherButtonTitles:nil] autorelease];
//	[av show];
    
}

#pragma mark FBFunLoginDialogDelegate

- (void)accessTokenFound:(NSString *)accessToken {
    NSLog(@"Access token found: %@", accessToken);
    self.accessToken = accessToken;
    _loginState = LoginStateLoggedIn;
    [self dismissModalViewControllerAnimated:YES];    
    [self getFacebookProfile];  
    [self showLikeButton];
    [self refresh];
}

- (void)displayRequired {
    [self presentModalViewController:_loginDialog animated:YES];
}

- (void)closeTapped {
    [self dismissModalViewControllerAnimated:YES];
    _loginState = LoginStateLoggedOut;        
    [_loginDialog logout];
    [self refresh];
}

@end
