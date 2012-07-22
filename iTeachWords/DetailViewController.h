//
//  DetailViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/16/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleWebViewController.h"

@class MyUIViewClass,SocialSharingViewController;
@interface DetailViewController : SimpleWebViewController{
    SocialSharingViewController *socialSharingViewController;
    @public
    IBOutlet MyUIViewClass *contentView;
    IBOutlet UIButton *closeBtn;
}

- (void)showWebView;
- (void)showSocialSaringView;
- (IBAction)close:(id)sender;

@end
