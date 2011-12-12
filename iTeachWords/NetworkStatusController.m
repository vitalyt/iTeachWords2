//
//  NetworkStatusController.m
//  ABN op reis
//
//  Created by Vitaly Todorovych on 3/23/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "NetworkStatusController.h"

@implementation NetworkStatusController

static id _delegate;
static SEL _selector;
static SEL _selector2;
static id _param;
static id _param2;

+ (void) loadSelector:(SEL)selector withObject:(id)object OR:(SEL)selector2 withObject:(id)object2 delegate:(id)delegate
{
     UIAlertView *alert;
    _delegate = delegate;
    _selector = selector;
    _param = object;
    _param2 = object2;
    _selector2 = selector2;
    alert = [[UIAlertView alloc] initWithTitle:@"" message:@"" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [alert show];
    //[alert release];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ((_delegate == nil)||(_selector == nil)||(_selector2 == nil)) {
        return;
    }
    if (buttonIndex == 1) {
        if (_delegate && [_delegate respondsToSelector:_selector]) {
            [_delegate performSelector:_selector];
        }
    }
    else
    {
        if (_delegate && [_delegate respondsToSelector:_selector2]) {
            [_delegate performSelector:_selector2 withObject:_param];
        }
    }
    _delegate = nil;
    _selector = nil;
    _selector2 = nil;
    _param = nil;
    _param2 = nil;
}

@end
