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

#define kOAuthConsumerKey				@"DJ8d2jw1EAzOAmKBSN8C0g"		//REPLACE ME
#define kOAuthConsumerSecret			@"bPFqYtJJ7YpZFbdsvQ1Mv2vcIHkcsUNqPQx9ExZDoU"		//REPLACE ME

@implementation SocialSharingViewController

@synthesize delegate;

- (void)dealloc {
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
//        [_loginB setTitle:@"Login" forState:UIControlStateNormal];
        [self hideControls:YES];
    } 
    else 
    {
//        [_loginB setTitle:@"Logout" forState:UIControlStateNormal];
        [self hideControls:NO];
        [_vkontakte getUserInfo];
    }
}


- (IBAction)postVkontakte:(id)sender
{
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
    [_vkontakte postMessageToWall:@"Vkontakte iOS SDK"];
}

- (IBAction)postImagePressed:(id)sender
{
    [_vkontakte postImageToWall:[UIImage imageNamed:@"iTunesArtwork"]];
}

- (IBAction)postMessageWithLinkPressed:(id)sender
{
    [_vkontakte postMessageToWall:@"Vkontakte iOS SDK" 
                             link:[NSURL URLWithString:@"https://github.com/StonerHawk/Vkontakte-iOS-SDK"]];
}

- (IBAction)postImageWithTextPressed:(id)sender
{
    [_vkontakte postImageToWall:[UIImage imageNamed:@"iTunesArtwork"] 
                           text:@"Vkontakte iOS SDK"];
}

- (IBAction)postImageWithTextAndLinkPressed:(id)sender
{
    [_vkontakte postImageToWall:[UIImage imageNamed:@"iTunesArtwork"] 
                           text:@"Vkontakte iOS SDK" 
                           link:[NSURL URLWithString:@"https://github.com/StonerHawk/Vkontakte-iOS-SDK"]];
}

#pragma mark - VkontakteDelegate

- (void)vkontakteDidFailedWithError:(NSError *)error
{
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
    if ([delegate respondsToSelector:@selector(presentingViewController)]) {
        [((UIViewController*)delegate).presentingViewController dismissModalViewControllerAnimated:YES]; // for IOS 5+
    } else {
        [((UIViewController*)delegate).parentViewController dismissModalViewControllerAnimated:YES]; // for pre IOS 5
    }
}

- (void)authControllerDidCancelled
{
    if ([delegate respondsToSelector:@selector(presentingViewController)]) {
        [((UIViewController*)delegate).presentingViewController dismissModalViewControllerAnimated:YES]; // for IOS 5+
    } else {
        [((UIViewController*)delegate).parentViewController dismissModalViewControllerAnimated:YES]; // for pre IOS 5
    }
}

- (void)vkontakteDidFinishLogin:(Vkontakte *)vkontakte
{
    [self dismissModalViewControllerAnimated:YES];
    [self refreshVkontakteState];
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
    return [NSString stringWithFormat: @"Already Updated. %@", [NSDate date]];
}

@end
