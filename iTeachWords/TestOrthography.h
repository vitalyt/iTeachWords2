//
//  Test1.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/6/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TestControllerProtocol.h"
#import "ExersiceBasicClass.h"

@interface TestOrthography : ExersiceBasicClass <UITextFieldDelegate> {
    NSMutableArray  *words;
	int             index;
}

- (IBAction) nextWord;
- (void) createWord;
- (BOOL) test;
@end
