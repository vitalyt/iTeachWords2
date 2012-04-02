//
//  ExpandingBarViewController.h
//  iTeachWords
//
//  Created by admin on 02.04.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RNExpandingButtonBar.h"

@interface ExpandingBarViewController : UIViewController <RNExpandingButtonBarDelegate>{
    
    RNExpandingButtonBar *_bar;
    BOOL isExpandingBarShowed;
}
@property (nonatomic, strong) RNExpandingButtonBar *bar;

- (void) onNext;
- (void) onAlert;
- (void) onModal;

@end
