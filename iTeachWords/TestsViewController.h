//
//  TestsViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/21/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHelpViewController.h"
#import "TestsViewProtocol.h"

@interface TestsViewController : BaseHelpViewController {
@private
    id	<TestsViewProtocol> toolsViewDelegate;
    id	<TestsViewProtocol> testsViewDelegate;
}
@property (nonatomic,retain) id <TestsViewProtocol>  toolsViewDelegate;
@property (nonatomic,retain) id <TestsViewProtocol>  testsViewDelegate;

- (IBAction)close:(id)sender;
- (IBAction) clickGame:(id)sender;
- (IBAction) clickTestOneOfSix:(id)sender;
- (IBAction) clickTest1:(id)sender;
- (IBAction) clickStatistic:(id)sender;
@end
