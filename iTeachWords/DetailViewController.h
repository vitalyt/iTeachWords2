//
//  DetailViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/16/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SimpleWebViewController.h"

@class MyUIViewClass;
@interface DetailViewController : SimpleWebViewController{
    @public
    IBOutlet MyUIViewClass *contentView;
    IBOutlet UIButton *closeBtn;
}

- (void)showWebView;
- (IBAction)close:(id)sender;

@end
