//
//  EditingView.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 2/22/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHelpViewController.h"
#import "EditingViewProtocol.h"
#import "TestsViewProtocol.h"

@interface EditingView : BaseHelpViewController {
    id	<TestsViewProtocol> toolsViewDelegate;
    id	<EditingViewProtocol> editingViewDelegate;
    IBOutlet UIToolbar      *toolbar; 
}
@property (nonatomic,retain) id <TestsViewProtocol>  toolsViewDelegate;
@property (nonatomic,retain) id <EditingViewProtocol>  editingViewDelegate;

- (IBAction) close:(id)sender;
- (IBAction) deleteWord:(id)sender;
- (IBAction) editWord;
- (IBAction) reassignWord:(id)sender;
- (IBAction) selectAll:(id)sender;

@end
