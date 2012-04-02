//
//  ManagerViewController.m
//  iTeachWords
//
//  Created by  user on 03.07.11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "ManagerViewController.h"
#import "ToolsViewProtocol.h"
#import "ToolsViewController.h"

@implementation ManagerViewController

@synthesize managerViewDelegate,toolsViewDelegate,segmentControll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [segmentControll release];
    [super dealloc];
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
    [segmentControll setTitle:TRANSLATE_LANGUAGE_CODE forSegmentAtIndex:0];
    [segmentControll setTitle:NATIVE_LANGUAGE_CODE forSegmentAtIndex:2];
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


- (IBAction)close:(id)sender {
    SEL selector = @selector(managerSubViewDidClose:);
    if ((self.toolsViewDelegate)&&([(id)toolsViewDelegate respondsToSelector:selector])) {
		[(id)self.toolsViewDelegate performSelector:selector withObject:self afterDelay:0.01];
	}
}

- (IBAction) mixingWords:(id)sender{
    if (IS_HELP_MODE && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)managerViewDelegate).view];
        return;
    }
    SEL selector = @selector(mixingWords);
    if ((self.managerViewDelegate)&&([self.managerViewDelegate respondsToSelector:selector])) {
		[(id)self.managerViewDelegate performSelector:selector withObject:nil afterDelay:0.01];
	}
}

- (IBAction)selectedLanguage:(id)sender {
    if (IS_HELP_MODE && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)managerViewDelegate).view];
        return;
    }
    SEL selector = @selector(selectedLanguage:);
    //UISegmentedControl *segment = (UISegmentedControl*)sender;
    if ((self.managerViewDelegate)&&([self.managerViewDelegate respondsToSelector:selector])) {
		[(id)self.managerViewDelegate performSelector:selector withObject:sender afterDelay:0.01];
	}
}

-(UIView*)hintStateViewForDialog:(id)hintState
{
    CGRect frame = ((UIViewController*)managerViewDelegate).view.frame;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height/4, frame.size.width-20, frame.size.height/2)];
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
            message = NSLocalizedString(@"Перемешать", @"");
            break;
        case 2:
            message = NSLocalizedString(@"Упражнения и статистика", @"");
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
