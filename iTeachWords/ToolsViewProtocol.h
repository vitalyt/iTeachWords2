//
//  ToolsViewProtocol.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 10/8/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ToolsViewProtocol

- (IBAction) clickEdit;
 
@optional
- (void) toolsViewDidShow;
- (void) optionsSubViewDidClose:(id)sender;
- (void) editingSubViewDidClose:(id)sender;
- (void) managerSubViewDidClose:(id)sender;
- (IBAction) showThemesView;
- (IBAction) changeSlider:(id) sender;
- (IBAction) showPlayerView;
- (IBAction) showRecordingView;
- (IBAction) showTestsView;
@end
