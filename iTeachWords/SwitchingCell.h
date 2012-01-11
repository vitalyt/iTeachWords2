//
//  SwitchingCell.h
//  hrmobile.efis
//
//  Created by Vitaly Todorovych on 6/17/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SwitchingCell : UITableViewCell {
	IBOutlet UISwitch *switcher;
	id delegate;
    IBOutlet UILabel *titleLabel;
    
}

@property (nonatomic, retain) UISwitch *switcher;
@property (nonatomic, assign) id delegate;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;

- (IBAction)changing:(id)sender;

@end
