//
//  SocialSharingViewController.m
//  iTeachWords
//
//  Created by admin on 22.07.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "SocialSharingViewController.h"
#import "NSString+Gender.h"

#import "SA_OAuthTwitterEngine.h"

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

#define kOAuthConsumerKey				@"hcOXnIqFaUCIcXOAQkILg"		//REPLACE ME
#define kOAuthConsumerSecret			@"lFtotIK1hTA80oQJBcOjCd0nDXj7GpbMkwBJvvlhm4"		//REPLACE ME

@implementation SocialSharingViewController

@synthesize delegate;
@synthesize session = _session;
@synthesize posting = _posting;


- (void)dealloc {
    
    _vkontakte.delegate = nil;
    [_session release];
	_session = nil;
    [_facebookName release];
	_facebookName = nil;
    self.loginDialog = nil;
    self.accessToken = nil;
    
	[_engine release];
    delegate = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)refreshVkontakteState
{
    if (![_vkontakte isAuthorized]) 
    {
    } 
    else 
    {
        [_vkontakte getUserInfo];
    }
}


- (IBAction)postVkontakte:(id)sender
{
    _vkontakte = [Vkontakte sharedInstance];
    _vkontakte.delegate = self;
    if (![_vkontakte isAuthorized]) 
    {
        [_vkontakte authenticate];
    }
    else
    {
        [self postImageWithTextAndLinkPressed:sender];
//        [_vkontakte logout];
    }
}

- (IBAction)loginPressed:(id)sender
{
    if (![_vkontakte isAuthorized]) 
    {
        [_vkontakte authenticate];
    }
    else
    {
        [_vkontakte logout];
    }
}

- (IBAction)postMessagePressed:(id)sender
{
    [_vkontakte postMessageToWall:APP_DESCRIPTION_FOR_POSTING];
}

- (IBAction)postImagePressed:(id)sender
{
    [_vkontakte postImageToWall:[UIImage imageNamed:@"Icon@2x.png"]];
}

- (IBAction)postMessageWithLinkPressed:(id)sender
{
    [_vkontakte postMessageToWall:APP_DESCRIPTION_FOR_POSTING 
                             link:[NSURL URLWithString:APP_WEB_URL]];
}

- (IBAction)postImageWithTextPressed:(id)sender
{
    [_vkontakte postImageToWall:[UIImage imageNamed:@"Icon@2x.png"] 
                           text:APP_DESCRIPTION_FOR_POSTING];
}

- (IBAction)postImageWithTextAndLinkPressed:(id)sender
{
    [UIAlertView showLoadingViewWithMwssage:NSLocalizedString(@"Posting To vkontakte...", @"")];
    [_vkontakte postImageToWall:[UIImage imageNamed:@"Icon@2x.png"] 
                           text:APP_DESCRIPTION_FOR_POSTING 
                           link:[NSURL URLWithString:APP_WEB_URL]];
}

#pragma mark - VkontakteDelegate

- (void)vkontakteDidFailedWithError:(NSError *)error
{
    [UIAlertView removeMessage];
    [self vkontakteAuthControllerDidCancelled];
}

- (void)showAuthController:(UIViewController *)controller
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) 
    {
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    vkontakteRegistrationView = controller;
    [self presentModalViewController:vkontakteRegistrationView animated:YES];
//    [delegate presentModalViewController:vkontakteRegistrationView animated:YES];
}

- (void)vkontakteAuthControllerDidCancelled
{
    [UIAlertView removeMessage];
    if ([delegate respondsToSelector:@selector(presentingViewController)]) {
        [((UIViewController*)delegate).presentingViewController dismissModalViewControllerAnimated:YES]; // for IOS 5+
    } else {
        [((UIViewController*)delegate).parentViewController dismissModalViewControllerAnimated:YES]; // for pre IOS 5
    }
}

- (void)authControllerDidCancelled
{
    [UIAlertView removeMessage];
    if ([delegate respondsToSelector:@selector(presentingViewController)]) {
        [((UIViewController*)delegate).presentingViewController dismissModalViewControllerAnimated:YES]; // for IOS 5+
    } else {
        [((UIViewController*)delegate).parentViewController dismissModalViewControllerAnimated:YES]; // for pre IOS 5
    }
}

- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte
{
    [UIAlertView removeMessage];
    [self vkontakteAuthControllerDidCancelled];
    [self refreshVkontakteState];
    [self postVkontakte:nil];
}

- (void)vkontakteDidFinishLogOut:(Vkontakte *)vkontakte
{
    [self refreshVkontakteState];
}

- (void)vkontakteDidFinishGettinUserInfo:(NSDictionary *)info
{
    NSLog(@"%@", info);
    
//    NSString *photoUrl = [info objectForKey:@"photo_big"];
//    NSData *photoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:photoUrl]];
//    _userImage.image = [UIImage imageWithData:photoData];
    
//    _userName.text = [info objectForKey:@"first_name"];
//    _userSurName.text = [info objectForKey:@"last_name"];
//    _userBDate.text = [info objectForKey:@"bdate"];
//    _userGender.text = [NSString stringWithGenderId:[[info objectForKey:@"sex"] intValue]];
//    _userEmail.text = [info objectForKey:@"email"];
}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)responce
{
    [UIAlertView removeMessage];
    NSLog(@"%@", responce);
}




//=============================================================================================================================
#pragma mark SA_OAuthTwitterEngineDelegate
- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults			*defaults = [NSUserDefaults standardUserDefaults];
    
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

//=============================================================================================================================
#pragma mark SA_OAuthTwitterControllerDelegate
- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
    [UIAlertView removeMessage];
    [UIAlertView displayMessage:[NSString stringWithFormat:@"Authenicated for %@", username]];
	NSLog(@"Authenicated for %@", username);
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
    [UIAlertView removeMessage];
    [UIAlertView displayError:NSLocalizedString(@"Authentication Failed!", @"")];
	NSLog(@"Authentication Failed!");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
    [UIAlertView removeMessage];
	NSLog(@"Authentication Canceled.");
}

//=============================================================================================================================
#pragma mark TwitterEngineDelegate
- (void) requestSucceeded: (NSString *) requestIdentifier {
    [UIAlertView removeMessage];
    [UIAlertView displayMessage:NSLocalizedString(@"Request succeeded", @"")];
    
    //    UIAlertView *av = [[[UIAlertView alloc] initWithTitle:@"Article has been posted!" 
    //												  message:@"Check out your Facebook to see!"
    //												 delegate:nil 
    //										cancelButtonTitle:@"OK"
    //										otherButtonTitles:nil] autorelease];
    //	[av show];
	NSLog(@"Request %@ succeeded", requestIdentifier);
}

- (void) requestFailed: (NSString *) requestIdentifier withError: (NSError *) error {
    [UIAlertView removeMessage];
    [UIAlertView displayMessage:[NSString stringWithFormat:NSLocalizedString(@"Request failed with error: %@", @""),error]];
	NSLog(@"Request %@ failed with error: %@", requestIdentifier, error);
}

- (IBAction)postToTwitterWall:(id)sender{
	if (_engine) return;
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate: self];
	_engine.consumerKey = kOAuthConsumerKey;
	_engine.consumerSecret = kOAuthConsumerSecret;
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller) {
        [self showAuthController:controller];
    }
	else {
        [UIAlertView showLoadingViewWithMwssage:NSLocalizedString(@"Posting To Twitter...", @"")];
        if ([delegate respondsToSelector:@selector(twitterMesageText)]) {
            NSString *messsage = [[NSString alloc] initWithFormat:@"%@",[delegate twitterMesageText]];
            [_engine sendUpdate:[messsage autorelease]];
        }else {
            [_engine sendUpdate:[self twitterMesageText]];
        }
	}
    
}

- (NSString*)twitterMesageText{
    NSString *message = [[NSString alloc] initWithFormat:@"%@\nДержи ссылку и радуйся %@",APP_DESCRIPTION_FOR_POSTING,APP_WEB_URL];
    return [message autorelease];
}

//Facebook posting

- (void)refresh {
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
    } else if (_loginState == LoginStateLoggingIn) {
    } else if (_loginState == LoginStateLoggedIn) {
        [self postToWall];
    }   
}

#pragma mark FBFunLoginDialogDelegate

- (void)accessTokenFound:(NSString *)accessToken {
    NSLog(@"Access token found: %@", accessToken);
    self.accessToken = accessToken;
    _loginState = LoginStateLoggedIn;
 
    //    [self showLikeButton];
    [self refresh];
}

- (void)closeTapped {
    [self authControllerDidCancelled];
    [self refresh];
}

- (void)displayRequired {
    [self showAuthController:_loginDialog];
}

- (IBAction)postToFacebookWall:(id)sender {
    if (_loginState == LoginStateStartup || _loginState == LoginStateLoggedOut) {
        [self loginButtonTapped:nil];
    } else if (_loginState == LoginStateLoggingIn) {
    } else if (_loginState == LoginStateLoggedIn) {
        //        [self rateTapped:nil];
        [self postToWall];
        
    }   
	// Otherwise, we don't have a name yet, just wait for that to come through.
}


#pragma mark FBSessionDelegate methods

- (void)session:(FBSession*)session didLogin:(FBUID)uid {
	[self getFacebookName];
}

- (void)session:(FBSession*)session willLogout:(FBUID)uid {
	_facebookName = nil;
}

#pragma mark Get Facebook Name Helper

- (void)getFacebookName {
	NSString* fql = [NSString stringWithFormat:
					 @"select uid,name from user where uid == %lld", _session.uid];
	NSDictionary* params = [NSDictionary dictionaryWithObject:fql forKey:@"query"];
	[[FBRequest requestWithDelegate:self] call:@"facebook.fql.query" params:params];
}

#pragma mark FBRequestDelegate methods

- (void)request:(FBRequest*)request didLoad:(id)result {
	if ([request.method isEqualToString:@"facebook.fql.query"]) {
		NSArray* users = result;
		NSDictionary* user = [users objectAtIndex:0];
		NSString* name = [user objectForKey:@"name"];
		if (_posting) {
			[self postToWall];
			_posting = NO;
		}
	}
}

#pragma mark Post to Wall Helper

- (void)postToWall{
    [UIAlertView showLoadingViewWithMwssage:NSLocalizedString(@"Posting To Facebook...", @"")];
    NSDictionary *infoDict = nil;
    if ([self respondsToSelector:@selector(facebookMesageText)]) {
        infoDict = [self facebookMesageText];
    }
    if (!infoDict) {
        return;
    }
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/me/feed?access_token=%@", [_accessToken stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    ASIFormDataRequest *newRequest = [ASIFormDataRequest requestWithURL:url];
    //    [newRequest setPostValue:@"I'm learning how to post to Facebook from an iPhone app!" forKey:@"message"];
    [newRequest setPostValue:([infoDict objectForKey:@"title"])?[infoDict objectForKey:@"title"]:[NSString stringWithFormat:@""] forKey:@"name"];
    [newRequest setPostValue:([infoDict objectForKey:@"title"])?[infoDict objectForKey:@"description"]:[NSString stringWithFormat:@""] forKey:@"description"];
    [newRequest setPostValue:([infoDict objectForKey:@"actionLinks"])?
     [infoDict objectForKey:@"actionLinks"]:@"http://www.osdn.nl" forKey:@"link"];
    if ([infoDict objectForKey:@"imageUrl"]) {
        [newRequest setPostValue:[infoDict objectForKey:@"imageUrl"] forKey:@"picture"];
    }else {
        [newRequest setPostValue:@"http://www.umbc.edu/studentlife/orgs/freedom/resources/news.jpg" forKey:@"picture"];
    }
    [newRequest setDidFinishSelector:@selector(postToWallFinished:)];
    
    [newRequest setDelegate:self];
    [newRequest startAsynchronous]; 
}

- (NSDictionary*)facebookMesageText{
    NSMutableDictionary   *infoDict = [[NSMutableDictionary alloc] init];
    [infoDict setValue:NSLocalizedString(@"iStudyWords", @"") forKey:@"title"];
    [infoDict setValue:APP_DESCRIPTION_FOR_POSTING forKey:@"description"];
    [infoDict setValue:APP_WEB_URL forKey:@"actionLinks"];
    return [infoDict autorelease];
}

@end
