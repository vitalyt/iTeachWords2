    //
//  ToolsViewController.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/20/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "ToolsViewController.h"
#import "RecordingViewController.h"
#import "TestsViewController.h"
#import "EditingView.h"
#import "ManagerViewController.h"
#import "WorldTableViewController.h"

@implementation ToolsViewController
@synthesize scrollView;
@synthesize delegate,visible,mySlider,isShowingView;
@synthesize closeBtn;

-(UIView*)hintStateViewForDialog:(id)hintState
{
    CGRect frame = ((UIViewController*)delegate).view.frame;
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
            message = NSLocalizedString(@"Управление списком", @"");
            break;
        case 2:
            message = NSLocalizedString(@"Упражнения и статистика", @"");
            break;
        case 3:
            message = NSLocalizedString(@"Фонограф", @"");
            break;
        case 4:
            message = NSLocalizedString(@"Плеер", @"");
            break;
        case 5:
            message = NSLocalizedString(@"Управление списком", @"");
            break;
            
        default:
            break;
    }
    return message;
}

- (IBAction)toolBarButtonClick:(id)sender{
    SEL selector = @selector(addSubToolbarAfterButton:);
    [self performSelector:selector withObject:sender afterDelay:0.01];
}

- (IBAction) clickManaging:(id)sender{
    if (!managerView) {
        managerView = [[ManagerViewController alloc] initWithNibName:@"ManagerViewController" bundle:nil];
    }
    managerView.toolsViewDelegate = self;
    managerView.managerViewDelegate = self.delegate;
    [self toolbarAddSubView:managerView.view after:sender];
    managerView.segmentControll.selectedSegmentIndex = ((WorldTableViewController*)delegate).showingType;
}

- (IBAction) clickEdit:(id)sender{
	if ([self.delegate respondsToSelector:@selector(clickEdit)]) {
		[self.delegate clickEdit];
	}
    if (!editingView) {
        editingView = [[EditingView alloc] initWithNibName:@"EditingView" bundle:nil];
    }
    editingView.toolsViewDelegate = self;
    editingView.editingViewDelegate = self.delegate;
    [self toolbarAddSubView:editingView.view after:sender];
//    [self performSelector:@selector(click:) withObject:sender afterDelay:.01];
}

- (IBAction) showRecordingView:(id)sender{
    // ((UIBarButtonItem *)sender).customView.hidden = YES;
	if ([(id)self.delegate respondsToSelector:@selector(showRecordingView)]) {
        [(id)self.delegate showRecordingView];
        //[self showToolsView:nil];
        return;
    }
    if (!recordingView) {
        recordingView = [[RecordingViewController alloc] initWithNibName:@"RecordingViewController" bundle:nil];
    }
    recordingView.toolsViewDelegate = self;
    recordingView.delegate = self.delegate;
    [self toolbarAddSubView:recordingView.view after:sender];
}


- (IBAction) showTestsView:(id)sender{
    // ((UIBarButtonItem *)sender).customView.hidden = YES;
	if ([(id)self.delegate respondsToSelector:@selector(showTestsView)]) {
        [(id)self.delegate showTestsView];
        
        return;
    }
    if (!testsView) {
        testsView = [[TestsViewController alloc] initWithNibName:@"TestsViewController" bundle:nil];
    }
    testsView.toolsViewDelegate = self;
    testsView.testsViewDelegate = self.delegate;
    [self toolbarAddSubView:testsView.view after:sender];
}

- (IBAction) showPlayerView:(id)sender{   
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:((UIViewController*)delegate).view];
        return;
    }
    SEL selector = @selector(showPlayerView);
	if ([(id)self.delegate respondsToSelector:selector]) {
		[(id)self.delegate performSelector:selector withObject:nil afterDelay:0.01];
		self.visible = NO;
		//[self.view removeFromSuperview];
		return;
	}
}

- (IBAction) showThemesView{
    SEL selector = @selector(showThemesView);
	if ([(id)self.delegate respondsToSelector:selector]) {
		[(id)self.delegate performSelector:selector withObject:nil afterDelay:0.01];
		return;
	}
}

- (IBAction) changeSlider:(id)sender{
    SEL selector = @selector(changeSlider:);
	if ([(id)self.delegate respondsToSelector:selector]) {
		[(id)self.delegate performSelector:selector withObject:sender afterDelay:0.01];
		return;
	}
}


- (void) optionsSubViewDidClose:(id)sender{
    [self toolbarRemoveSubView:((UIViewController *)sender).view];
    SEL selector = @selector(optionsSubViewDidClose:);
    if ((delegate)&&([(id)delegate respondsToSelector:selector])) {
		[(id)delegate performSelector:selector withObject:self afterDelay:0.01];
	}
}

- (void) editingSubViewDidClose:(id)sender{
    SEL selector = @selector(clickEdit);
    [self toolbarRemoveSubView:((UIViewController *)sender).view];
    if ([(id)self.delegate respondsToSelector:selector]) {
		[(id)self.delegate performSelector:selector withObject:nil afterDelay:0.01];
    }
   // [((TableWordController *)self.delegate) clickEdit];
}

- (void) managerSubViewDidClose:(id)sender{
    [self toolbarRemoveSubView:((UIViewController *)sender).view];
}


- (IBAction) showToolsView:(id)sender{
    CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionPush;  
    if(self.view.frame.origin.x < -10.0){
        isShowingView = YES;
        myTransition.subtype = kCATransitionFromLeft;
        [self.view.layer addAnimation:myTransition forKey:nil];
        [self.view setFrame:CGRectMake(-10.0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    }
    else{
        isShowingView = NO;
        myTransition.subtype = kCATransitionFromRight;
        [self.view.layer addAnimation:myTransition forKey:nil];
        [self.view setFrame:CGRectMake(-328.0, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    }
    if ([(id)self.delegate respondsToSelector:@selector(toolsViewDidShow)]) {
		[(id)self.delegate toolsViewDidShow];
		return;
	}
}

- (void) removeOptionWithIndex:(int)index{
    ((UIBarButtonItem*) [[toolbar items] objectAtIndex:index]).enabled = NO;
}

- (void) openViewWithAnimation:(UIView *) superView{
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionPush; 
	myTransition.subtype = kCATransitionFromLeft;
	[self.view setFrame:CGRectMake(self.view.frame.origin.x, superView.frame.size.height - self.view.frame.size.height+3, self.view.frame.size.width, self.view.frame.size.height)]; 
	[self.view.layer addAnimation:myTransition forKey:nil]; 
	[superView addSubview:self.view];
    isShowingView = YES;
    if ([(id)self.delegate respondsToSelector:@selector(toolsViewDidShow)]) {
		[(id)self.delegate toolsViewDidShow];
		return;
	}
}

- (void) closeView{
    CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionPush; 
	myTransition.subtype = kCATransitionFromRight;
    
	[self.view.layer addAnimation:myTransition forKey:nil];
	[self.view removeFromSuperview];
    isShowingView = NO;
    if ([(id)self.delegate respondsToSelector:@selector(toolsViewDidShow)]) {
		[(id)self.delegate toolsViewDidShow];
		return;
	}
}

- (void)addSubToolbarAfterButton:(id)_button{
    
    UIView *_subView = [self createBaseViewByIndexButton:_button];
    [self toolbarAddSubView:_subView after:_button];
}

- (UIView*)createBaseViewByIndexButton:(id)_button{
    UIView *baseView = nil;
    if (IS_HELP_MODE && _button && [usedObjects indexOfObject:_button] == NSNotFound) {
        _currentSelectedObject = _button;
        [_hint presentModalMessage:[self helpMessageForButton:_button] where:((UIViewController*)delegate).view];
        return nil;
    }
    int index = ((UIBarButtonItem*)_button).tag+1;
    switch (index) {
        case 1:{
            if (!managerView) {
                managerView = [[ManagerViewController alloc] initWithNibName:@"ManagerViewController" bundle:nil];
            }
            managerView.toolsViewDelegate = self;
            managerView.managerViewDelegate = self.delegate;
            baseView = managerView.view;
            managerView.segmentControll.selectedSegmentIndex = ((WorldTableViewController*)delegate).showingType;
        }
            break;
        case 2:{
            if ([(id)self.delegate respondsToSelector:@selector(showTestsView)]) {
                [(id)self.delegate showTestsView];
                
                return nil;
            }
            if (!testsView) {
                testsView = [[TestsViewController alloc] initWithNibName:@"TestsViewController" bundle:nil];
            }
            testsView.toolsViewDelegate = self;
            testsView.testsViewDelegate = self.delegate;
            baseView = testsView.view;
    }
            break;
        case 3:{
            if ([(id)self.delegate respondsToSelector:@selector(showRecordingView)]) {
                [(id)self.delegate showRecordingView];
                return nil;
            }
            if (!recordingView) {
                recordingView = [[RecordingViewController alloc] initWithNibName:@"RecordingViewController" bundle:nil];
            }
            recordingView.toolsViewDelegate = self;
            recordingView.delegate = self.delegate;
            baseView = recordingView.view;
        }
            break;
        case 4:{
        
        }
            break;
        case 5:{
            if ([self.delegate respondsToSelector:@selector(clickEdit)]) {
                [self.delegate clickEdit];
            }
            if (!editingView) {
                editingView = [[EditingView alloc] initWithNibName:@"EditingView" bundle:nil];
            }
            editingView.toolsViewDelegate = self;
            editingView.editingViewDelegate = self.delegate;
            baseView = editingView.view;
        }
            break;
            
        default:
            break;
    }
    return baseView;
}

-(UIView*)hintStateViewToHint:(id)hintState
{
    [usedObjects addObject:_currentSelectedObject];
    UIView *view = [_currentSelectedObject valueForKey:@"view"];
    CGRect frame = view.frame;
    UIView *buttonView = [[UIView alloc] initWithFrame:frame];
    [buttonView setFrame:CGRectMake(frame.origin.x, frame.origin.y+self.view.frame.origin.y, frame.size.width, frame.size.height)];
    return [buttonView autorelease];
}

- (void) toolbarAddSubView:(UIView *)_subView after:(id)sender{
    if (!_subView) {
        return;
    }
    NSMutableArray *items = [[toolbar items] mutableCopy];
    int index = [items indexOfObject:sender]+1;
    
    UIBarButtonItem *recordingButton = [[UIBarButtonItem alloc] initWithCustomView:_subView];
    [recordingButton setTag:index];
    [_subView setTag:index];
    NSLog(@"%d",[items indexOfObject:sender]+1);
    [items insertObject:recordingButton atIndex:[items indexOfObject:sender]+1];
    [recordingButton release];
    ((UIBarButtonItem *)sender).enabled = NO;
    [toolbar setItems:nil];
    
    [toolbar setFrame:CGRectMake(0.0, 0.0, 
                                 toolbar.frame.size.width + _subView.frame.size.width+5, 
                                 toolbar.frame.size.height)]; 
    
    [toolbar setItems:items animated:NO];
    CGSize size = CGSizeMake(toolbar.frame.size.width, scrollView.frame.size.height);
    [scrollView setContentSize:size];
    
    float offset = _subView.frame.origin.x+_subView.frame.size.width - scrollView.contentOffset.x - 320.0;
    if (offset > 0.0) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x + (_subView.frame.origin.x+_subView.frame.size.width - scrollView.contentOffset.x - 320.0)  , 0.0);
    }
    [items release];
}

- (void)changeSize{
    CGSize size = CGSizeMake(toolbar.frame.size.width, scrollView.frame.size.height);
    [scrollView setContentSize:size];
}

- (void) toolbarRemoveSubView:(UIView *)_subView{
    NSMutableArray *items = [[toolbar items] mutableCopy];
    
    for(int i=0;i<[items count]-1;i++){
        if((((UIBarButtonItem *)[items objectAtIndex:i]).enabled == NO) 
           && (((UIBarButtonItem *)[items objectAtIndex:i+1]).tag == _subView.tag)){
            ((UIBarButtonItem *)[items objectAtIndex:i]).enabled = YES;
            [items removeObjectAtIndex:i+1];
            [toolbar setItems:nil];
            [toolbar setFrame:CGRectMake(0.0, 0.0, 
                                         toolbar.frame.size.width - _subView.frame.size.width-5, 
                                         toolbar.frame.size.height)];    
            scrollView.contentSize	= CGSizeMake(toolbar.frame.size.width, scrollView.frame.size.height);
            //scrollView.contentOffset = CGPointMake(0.0, 0.0);
            
            break;
        }
    }
    [toolbar setItems:items animated:YES];
    [items release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.contentSize	= CGSizeMake(toolbar.frame.size.width, scrollView.frame.size.height);
   // [self createAllButtons];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [closeBtn release];
    closeBtn = nil;
    [super viewDidUnload];
    
    [recordingView release];
    recordingView = nil;
    [testsView release];
    testsView = nil;
    [editingView release];
    editingView = nil;
    [managerView release];
    managerView = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) clickStatistic{
    
}

- (IBAction) clickEdit{
    
}

- (void)dealloc {
    [recordingView release];
    [testsView release];
    [editingView release];
    [managerView release];
    if(recordingView != nil){
        [recordingView release];
    }
    if(testsView != nil){
        [testsView release];
    }
    [mySlider release];
    [closeBtn release];
    [super dealloc];
}


@end
