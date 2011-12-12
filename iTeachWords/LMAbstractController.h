//
//  LMAbstractController.h
//  MenuItemTesting
//
//  Created by Vitaly Todorovych on 3/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMModel;
@interface LMAbstractController : UIViewController {
      LMModel *model;  
}

@property (nonatomic, retain)   LMModel *model;

@end
