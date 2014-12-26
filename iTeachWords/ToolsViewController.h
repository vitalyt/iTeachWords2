//
//  ToolsViewController.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/20/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHelpViewController.h"
#import "ToolsViewProtocol.h"
#import "QuartzCore/QuartzCore.h"
#import "TestsViewProtocol.h"
#import "RecordingViewController.h"

@class  TestsViewController,
        EditingView,
        ManagerViewController;
@interface ToolsViewController : BaseHelpViewController <RecordingViewProtocol,TestsViewProtocol,ToolsViewProtocol> {
	IBOutlet UISlider       *mySlider;
    IBOutlet UIScrollView   *scrollView;
    IBOutlet UIToolbar      *toolbar; 
	BOOL                    visible;
    IBOutlet UIBarButtonItem *testItemsButton;
    RecordingViewController  *recordingView;
    TestsViewController      *testsView;
    EditingView              *editingView;
    ManagerViewController    *managerView;
    bool                    isShowingView;
}

@property (nonatomic,assign) id  delegate;
@property (nonatomic,assign) IBOutlet UIBarButtonItem  *closeBtn;
@property (nonatomic) bool  isShowingView;
@property (nonatomic,retain) IBOutlet UISlider *mySlider;
@property (nonatomic) BOOL visible;
@property (nonatomic,readonly) IBOutlet UIScrollView   *scrollView;

- (IBAction)toolBarButtonClick:(id)sender;
- (IBAction) clickManaging:(id)sender;
- (IBAction) clickEdit:(id)sender;
- (IBAction) showPlayerView:(id)sender;
- (IBAction) showToolsView:(id)sender;
- (IBAction) showRecordingView:(id)sender;

- (void) clickManaging:(id)sender;
- (void) clickEdit:(id)sender;
- (void) showToolsView:(id)sender;
- (void) showRecordingView:(id)sender;

- (void) toolbarAddSubView:(UIView *)_subView after:(id)sender;
- (void) toolbarRemoveSubView:(UIView *)_subView;

- (void)     openViewWithAnimation:(UIView *) superView;
- (void)     closeView;
- (void)    removeOptionWithIndex:(int)index;

- (void)addSubToolbarAfterButton:(id)_button;
- (UIView*)createBaseViewByIndexButton:(id)_button;
@end
