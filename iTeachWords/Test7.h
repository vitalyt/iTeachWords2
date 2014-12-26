//
//  Test7.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/22/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestControllerProtocol.h"


@interface Test7 : TestControllerProtocol <UITableViewDelegate> {
	NSInteger					indexRight;
}

@property (nonatomic,retain) NSMutableArray *optionArray,*wordsArray,*optionIndexArray;

- (IBAction)	help;
- (IBAction)	nextWord:(NSInteger)row;
- (void)		createWord;
- (BOOL)		test:(NSInteger)_tag;
- (void)		loadStrWithArray;
@end
