//
//  InfoViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 11/10/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface InfoViewController : UIViewController <MFMailComposeViewControllerDelegate>{
    NSString *sendingResult;
}

- (void)addInfoButton;
- (void)sendMessageView;
-(void)displayComposerSheet;
-(void)launchMailAppOnDevice;
- (void)addMailButton;

@end
