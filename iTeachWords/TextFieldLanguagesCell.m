//
//  TextFieldDataCell.m
//  hrmobile.efis
//
//  Created by Vitaly Todorovych on 6/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "TextFieldLanguagesCell.h"

@implementation TextFieldLanguagesCell

- (void) didChangedPickerData{
  	SEL selector = @selector(cellChanged:);
	if ([self.delegate respondsToSelector:selector]) {
		[self.delegate performSelector:selector withObject:self afterDelay:0.01f];
	}
    
}

- (void)    didClosePicker{
    SEL selector = @selector(cellDidEndEditing:);
	if ([self.delegate respondsToSelector:selector]) {
		[self.delegate performSelector:selector withObject:self afterDelay:0.01f];
	}
}

- (void)    didCanselPicker{
    SEL selector = @selector(cellDidEndEditing:);
	if ([self.delegate respondsToSelector:selector]) {
		[self.delegate performSelector:selector withObject:self afterDelay:0.01f];
	}  
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    SEL selector = @selector(cellDidBeginEditing:);
	if ([self.delegate respondsToSelector:selector]) {
		[self.delegate performSelector:selector withObject:self];
	}
    return NO;
}

- (BOOL)textFieldDidBeginEditing:(UITextField *)field {
	SEL selector = @selector(cellDidBeginEditing:);
	if ([self.delegate respondsToSelector:selector]) {
		[self.delegate performSelector:selector withObject:self];
	}
	return YES;
}
@end
