//
//  MyRecognizerViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/24/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "DMRecognizerViewController.h"
#import "MyUIViewClass.h"
#import "RecognizerAlertTableView.h"

@protocol MyRecognizerDelegate
@required
-(void)didRecognizeText:(NSString*)text;
@end

@interface MyRecognizerViewController : DMRecognizerViewController<AlertTableViewDelegate>{
    
    IBOutlet MyUIViewClass *majorView;
    IBOutlet UIView *toolsView;
    IBOutlet UILabel *recordingTypeLbl;
    IBOutlet UILabel *languageCodeLbl;
    IBOutlet UIButton *helpBtn;
    IBOutlet UIButton *exitBtn;
    
    id<MyRecognizerDelegate> caller;
    
    bool    isToolsViewShowing;
}

@property(nonatomic, retain) id<MyRecognizerDelegate> caller;

- (id)initWithDelegate:(id)_caller;

- (IBAction)close:(id)sender;
- (IBAction)showToolsView:(id)sender;

- (void)showHideToolsView;
- (CGRect)getFrameForMajorView;
- (CGRect)getFrameForToolsView;

- (void)showTableAlertViewWithElements:(NSArray *)elements;
@end
