//
//  SocialSharingViewController.m
//  iTeachWords
//
//  Created by admin on 22.07.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "SocialSharingViewController.h"
#import "NSString+Gender.h"


@implementation SocialSharingViewController

@synthesize delegate;

- (void)dealloc {
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
// vkontekte allocation
    _vkontakte = [Vkontakte sharedInstance];
    _vkontakte.delegate = self;
//    [self refreshVkontakteState];

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

@end
