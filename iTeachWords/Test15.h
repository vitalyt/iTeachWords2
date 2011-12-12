//
//  Test7.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/22/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TestControllerProtocol.h"

@interface Test15 : TestControllerProtocol  {
	BOOL flgPlay;
	BOOL flg16;
}

@property (nonatomic) BOOL flg16;
- (IBAction)	help;
//- (void)		playWord;
- (IBAction)	nextWord;
- (void)		createWord;
@end
