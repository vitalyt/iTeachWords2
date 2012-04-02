//
//  BaseHelpViewController.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 02.04.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMHint.h"

@interface BaseHelpViewController : UIViewController<EMHintDelegate>{
    EMHint *_hint;
    id _currentSelectedObject;
    NSMutableArray *usedObjects;
    NSMutableArray *unUsedObjects;
}

- (NSString*)helpMessageForButton:(id)_button;

@end
