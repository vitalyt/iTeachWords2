//
//  SocialSharingViewController.h
//  iTeachWords
//
//  Created by admin on 22.07.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Vkontakte.h"

@interface SocialSharingViewController : UIViewController <VkontakteDelegate>{
    id delegate; 
    
    Vkontakte *_vkontakte; 
    UIViewController *vkontakteRegistrationView; 
}

@property (nonatomic, assign) id delegate;

//vkontakte mode functions
- (IBAction)postVkontakte:(id)sender;
- (IBAction)loginPressed:(id)sender;

- (IBAction)postMessagePressed:(id)sender;
- (IBAction)postImagePressed:(id)sender;
- (IBAction)postMessageWithLinkPressed:(id)sender;
- (IBAction)postImageWithTextPressed:(id)sender;
- (IBAction)postImageWithTextAndLinkPressed:(id)sender;

- (void)refreshVkontakteState;
- (void)hideControls:(BOOL)hide;
@end
