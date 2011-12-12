//
//  EditingViewProtocol.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 2/22/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	EditingViewOptionDelete		,
	EditingViewOptionEdit		,
	EditingViewOptionReassign	
} EditingViewOption;

@protocol EditingViewProtocol <NSObject>

@required
- (void) deleteWord;
- (void) editWord;
- (void) reassignWord;
- (void) selectAll;

@end
