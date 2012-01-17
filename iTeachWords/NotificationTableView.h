//
//  NotificationTableView.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/16/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputTableController.h"

@interface NotificationTableView : InputTableController<UIAlertViewDelegate>{
    UISwitch *onOffSwitcher;
}

- (NSString*)keyForIndexPath:(NSIndexPath*)indexPath;

- (void)changedNotification;
- (void)showInfoView;

@end
