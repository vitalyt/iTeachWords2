//
//  TestsViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/21/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "TestsViewController.h"
#import "ToolsViewController.h"

@implementation TestsViewController

@synthesize toolsViewDelegate,testsViewDelegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


//-----------------------------------------------------------------------------------

- (IBAction)close:(id)sender {
    SEL selector = @selector(optionsSubViewDidClose:);
    if ((self.toolsViewDelegate)&&([self.toolsViewDelegate respondsToSelector:selector])) {
		[(id)self.toolsViewDelegate performSelector:selector withObject:self afterDelay:0.01];
	}
}


- (IBAction) clickGame:(id)sender{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)testsViewDelegate).view];
        return;
    }
    SEL selector = @selector(clickGame);
	if ((self.testsViewDelegate)&&([self.testsViewDelegate respondsToSelector:selector])) {
		[(id)self.testsViewDelegate performSelector:selector withObject:nil afterDelay:0.01];
		return;
	}
}

- (IBAction) clickTestOneOfSix:(id)sender{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)testsViewDelegate).view];
        return;
    }
    SEL selector = @selector(clickTestOneOfSix);
	if ((self.testsViewDelegate)&&([self.testsViewDelegate respondsToSelector:selector])) {
		[(id)self.testsViewDelegate performSelector:selector withObject:nil afterDelay:0.01];
		return;
	}
}

- (IBAction) clickTest1:(id)sender{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)testsViewDelegate).view];
        return;
    }
    SEL selector = @selector(clickTest1);
	if ((self.testsViewDelegate)&&([self.testsViewDelegate respondsToSelector:selector])) {
		[(id)self.testsViewDelegate performSelector:selector withObject:nil afterDelay:0.01];
		return;
	}
}

- (IBAction) clickStatistic:(id)sender{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)testsViewDelegate).view];
        return;
    }
    
    SEL selector = @selector(clickStatistic);
	if ((self.testsViewDelegate)&&([self.testsViewDelegate respondsToSelector:selector])) {
		[(id)self.testsViewDelegate performSelector:selector withObject:nil afterDelay:0.01];
		return;
	}
}

-(UIView*)hintStateViewForDialog:(id)hintState
{
    CGRect frame = ((UIViewController*)testsViewDelegate).view.frame;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height/4, frame.size.width-20, frame.size.height/2)];
    l.numberOfLines = 4;
    [l setTextAlignment:NSTextAlignmentCenter];
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
            message = NSLocalizedString(@"Упражнение \"Выбор слова\"", @"");
            break;
        case 2:
            message = NSLocalizedString(@"Упражнение \"Буквы\"", @"");
            break;
        case 3:
            message = NSLocalizedString(@"Упражнение \"Написание\"", @"");
            break;
        case 4:
            message = NSLocalizedString(@"Статистика успеваемости", @"");
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
    buttonView = [[UIView alloc] initWithFrame:frame];
    [buttonView setFrame:CGRectMake(frame.origin.x+self.view.frame.origin.x-toolsView.scrollView.contentOffset.x, frame.origin.y+((UIViewController*)toolsViewDelegate).view.frame.origin.y, frame.size.width, frame.size.height)];
    return buttonView;
}

@end
