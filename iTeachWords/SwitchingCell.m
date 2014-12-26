//
//  SwitchingCell.m
//  hrmobile.efis
//
//  Created by Vitaly Todorovych on 6/17/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "SwitchingCell.h"


@implementation SwitchingCell
@synthesize switcher;
@synthesize delegate;
@synthesize titleLabel;

- (IBAction)changing:(id)sender {
    SEL selector = @selector(cellChanged:);
	if ([delegate respondsToSelector:selector]) {
		[delegate performSelector:selector withObject:self afterDelay:0.01f];
	}
}
@end
