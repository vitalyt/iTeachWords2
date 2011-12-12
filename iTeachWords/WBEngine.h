//
//  WBEngine.h
//  WebsiteBuilder
//
//  Created by Yuri Kotov on 19.10.09.
//  Copyright 2009 Yalantis. All rights reserved.
//

@class WBRequest;
//@class WBConnection;
#import "LoadingViewController.h"

@interface WBEngine : NSObject
{
    
    LoadingViewController *loadingView;
    NSString *errorMessage;
    bool        errorFlag;
}

@property (nonatomic,retain) NSString *errorMessage;

- (BOOL) performRequest: (WBRequest*)request;
-(void) showLoadingViewIn:(UIView *)superView loadingText:(NSString *)text;
-(void) closeLoadingView;
@end