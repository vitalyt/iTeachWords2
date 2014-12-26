//
//  TextFieldCell.m
//  SOS
//
//  Created by Yalantis on 17.06.10.
//  Copyright 2010 Yalantis Software. All rights reserved.
//

#import "TextFieldCell.h"


@implementation TextFieldCell

- (BOOL)textFieldDidEndEditing:(UITextField *)field {
	SEL selector = @selector(cellDidEndEditing:);
	if ([_delegate respondsToSelector:selector]) {
		[_delegate performSelector:selector withObject:self];
	}
	return NO;
}   
 
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	SEL selector = @selector(cellChanged:);
	if ([_delegate respondsToSelector:selector]) {
		[_delegate performSelector:selector withObject:self afterDelay:0.01f];
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)field {
	[field resignFirstResponder];
	SEL selector = @selector(textFieldShouldReturn:);
	if ([_delegate respondsToSelector:selector]) {
		[_delegate performSelector:selector withObject:field];
	}
	return YES;
}

- (BOOL)textFieldDidBeginEditing:(UITextField *)field {
	SEL selector = @selector(cellDidBeginEditing:);
	if ([_delegate respondsToSelector:selector]) {
		[_delegate performSelector:selector withObject:self];
	}
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
	SEL selector = @selector(cellShouldClear:);
	if ([_delegate respondsToSelector:selector]) {
		[_delegate performSelector:selector withObject:self];
	}
	return YES;
}


@end
