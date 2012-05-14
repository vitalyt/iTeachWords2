//
//  EditingView.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 2/22/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "EditingView.h"
#import "ToolsViewController.h"

@implementation EditingView

@synthesize editingViewDelegate,toolsViewDelegate;

- (void)dealloc
{
    [super dealloc];
}

- (IBAction)close:(id)sender {
    SEL selector = @selector(editingSubViewDidClose:);
    if ((self.toolsViewDelegate)&&([self.toolsViewDelegate respondsToSelector:selector])) {
		[(id)self.toolsViewDelegate performSelector:selector withObject:self afterDelay:0.01];
	}
}

- (IBAction) deleteWord:(id)sender{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)editingViewDelegate).view];
        return;
    }
    SEL selector = @selector(deleteWord);
    if ((self.editingViewDelegate)&&([self.editingViewDelegate respondsToSelector:selector])) {
		[(id)self.editingViewDelegate performSelector:selector withObject:nil afterDelay:0.01];
		return;
	}
}

- (IBAction) editWord{
    SEL selector = @selector(editWord);
    if ((self.editingViewDelegate)&&([self.editingViewDelegate respondsToSelector:selector])) {
		[(id)self.editingViewDelegate performSelector:selector withObject:nil afterDelay:0.01];
		return;
	} 
}

- (IBAction) reassignWord:(id)sender{    
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)editingViewDelegate).view];
        return;
    }
    SEL selector = @selector(reassignWord);
    if ((self.editingViewDelegate)&&([self.editingViewDelegate respondsToSelector:selector])) {
		[(id)self.editingViewDelegate performSelector:selector withObject:nil afterDelay:0.01];
		return;
	}
}

- (IBAction)selectAll:(id)sender {
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)editingViewDelegate).view];
        return;
    }
    SEL selector = @selector(selectAll);
    if ((self.editingViewDelegate)&&([self.editingViewDelegate respondsToSelector:selector])) {
		[(id)self.editingViewDelegate performSelector:selector withObject:nil afterDelay:0.01];
		return;
	}
}

-(UIView*)hintStateViewForDialog:(id)hintState
{
    CGRect frame = ((UIViewController*)editingViewDelegate).view.frame;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height/4, frame.size.width-20, frame.size.height/2)];
    l.numberOfLines = 4;
    [l setTextAlignment:UITextAlignmentCenter];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:[self helpMessageForButton:_currentSelectedObject]];
    return l;
}

- (NSString*)helpMessageForButton:(id)_button{
    NSString *message = nil;
    int index = ((UIBarButtonItem*)_button).tag+1;
    switch (index) {
        case 1:
            message = NSLocalizedString(@"Удаление отмеченных слов", @"");
            break;
        case 2:
            message = NSLocalizedString(@"Переназначение отмеченных слов в другой словарь", @"");
            break;
        case 3:
            message = NSLocalizedString(@"Отметить все слова", @"");
            break;
            
        default:
            break;
    }
    return message;
}

-(UIView*)hintStateViewToHint:(id)hintState
{
    [usedObjects addObject:_currentSelectedObject];
    UIView *buttonView = nil;
    UIView *view = _currentSelectedObject;
    if (![view respondsToSelector:@selector(frame)]) {
        @try {
            view = ([_currentSelectedObject valueForKey:@"view"])?[_currentSelectedObject valueForKey:@"view"]:nil;
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
    }
    CGRect frame = view.frame;
    ToolsViewController *toolsView =  ((ToolsViewController*)toolsViewDelegate);
    buttonView = [[[UIView alloc] initWithFrame:frame] autorelease];
    [buttonView setFrame:CGRectMake(frame.origin.x+self.view.frame.origin.x-toolsView.scrollView.contentOffset.x, frame.origin.y+((UIViewController*)toolsViewDelegate).view.frame.origin.y, frame.size.width, frame.size.height)];
    return buttonView;
}

@end
