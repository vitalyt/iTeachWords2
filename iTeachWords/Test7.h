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
	NSMutableArray		*optionArray;
	NSMutableArray		*optionIndexArray;

	NSMutableArray		*wordsArray;
	int					indexRight;
}

@property (nonatomic,retain) NSMutableArray *optionArray,*wordsArray,*optionIndexArray;

- (IBAction)	help;
- (IBAction)	nextWord:(int)row;
- (void)		createWord;
- (BOOL)		test:(int)_tag;
- (void)		loadStrWithArray;
@end
