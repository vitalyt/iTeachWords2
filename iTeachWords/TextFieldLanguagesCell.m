//
//  TextFieldDataCell.m
//  hrmobile.efis
//
//  Created by Vitaly Todorovych on 6/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "TextFieldLanguagesCell.h"

@implementation TextFieldLanguagesCell

@synthesize textField2;
@synthesize titleLabel2;

- (void) dealloc{
	[textField2 release];
    [titleLabel2 release];
    [super dealloc];
}

- (void) didChangedPickerData{
  	SEL selector = @selector(cellChanged:);
	if ([delegate respondsToSelector:selector]) {
		[delegate performSelector:selector withObject:self afterDelay:0.01f];
	}
    
}

- (void)    didClosePicker{
    SEL selector = @selector(cellDidEndEditing:);
	if ([delegate respondsToSelector:selector]) {
		[delegate performSelector:selector withObject:self afterDelay:0.01f];
	}
}

- (void)    didCanselPicker{
    SEL selector = @selector(cellDidEndEditing:);
	if ([delegate respondsToSelector:selector]) {
		[delegate performSelector:selector withObject:self afterDelay:0.01f];
	}  
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    SEL selector = @selector(cellDidBeginEditing:);
	if ([delegate respondsToSelector:selector]) {
		[delegate performSelector:selector withObject:self];
	}
    return NO;
}

- (BOOL)textFieldDidBeginEditing:(UITextField *)field {
	SEL selector = @selector(cellDidBeginEditing:);
	if ([delegate respondsToSelector:selector]) {
		[delegate performSelector:selector withObject:self];
	}
	return YES;
}
@end
