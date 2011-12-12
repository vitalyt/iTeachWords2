//
//  ManagerViewController.h
//  iTeachWords
//
//  Created by  user on 03.07.11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ManagerViewProtocol.h"
#import "ToolsViewProtocol.h"

@interface ManagerViewController : UIViewController {
    id	<ToolsViewProtocol> toolsViewDelegate;
    id	<ManagerViewProtocol> managerViewDelegate;
    IBOutlet UIToolbar      *toolbar; 
    IBOutlet UISegmentedControl *segmentControll;
}

@property (nonatomic,retain) id <ManagerViewProtocol>  managerViewDelegate;
@property (nonatomic,retain) id <ToolsViewProtocol>  toolsViewDelegate;
@property (nonatomic,retain) UISegmentedControl  *segmentControll;

- (IBAction)close:(id)sender;
- (IBAction) mixingWords;
- (IBAction)selectedLanguage:(id)sender;

@end
