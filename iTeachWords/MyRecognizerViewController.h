//
//  MyRecognizerViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/24/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "DMRecognizerViewController.h"
#import "MyUIViewClass.h"

@interface MyRecognizerViewController : DMRecognizerViewController{
    
    IBOutlet MyUIViewClass *majorView;
    IBOutlet UIView *toolsView;
    IBOutlet UILabel *recordingTypeLbl;
    IBOutlet UILabel *languageCodeLbl;
    
    bool    isToolsViewShowing;
}
- (IBAction)close:(id)sender;
- (IBAction)showToolsView:(id)sender;

- (void)showHideToolsView;

- (CGRect)getFrameForMajorView;
- (CGRect)getFrameForToolsView;
@end
