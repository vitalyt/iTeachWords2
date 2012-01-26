//
//  MyVocalizerViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/26/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "DMVocalizerViewController.h"

@protocol MyVocalizerDelegate
@required
-(void)didVocalizerPlayedText:(NSString*)text languageCode:(NSString*)textLanguageCode;
@end

@class MyUIViewClass;
@interface MyVocalizerViewController : DMVocalizerViewController{
    IBOutlet MyUIViewClass *majorView;
    IBOutlet UIView *toolsView;
    IBOutlet UIButton *helpBtn;
    IBOutlet UIButton *exitBtn;
    
    id<MyVocalizerDelegate> caller;
    
    bool    isToolsViewShowing;

}

@property(nonatomic, retain) id<MyVocalizerDelegate> caller;

- (id)initWithDelegate:(id)_caller;
- (IBAction)close:(id)sender;
- (IBAction)showToolsView:(id)sender;

- (void)showHideToolsView;
- (CGRect)getFrameForMajorView;
- (CGRect)getFrameForToolsView;


- (void)setText:(NSString*)_text withLanguageCode:(NSString*)_languageCode;
@end
