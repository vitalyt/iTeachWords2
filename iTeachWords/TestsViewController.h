//
//  TestsViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/21/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestsViewProtocol.h"

@interface TestsViewController : UIViewController {
@private
    id	<TestsViewProtocol> toolsViewDelegate;
    id	<TestsViewProtocol> testsViewDelegate;
}
@property (nonatomic,retain) id <TestsViewProtocol>  toolsViewDelegate;
@property (nonatomic,retain) id <TestsViewProtocol>  testsViewDelegate;

- (IBAction)close:(id)sender;

@end
