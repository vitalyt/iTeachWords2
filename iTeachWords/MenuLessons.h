//
//  MenuLessons.h
//  iTeachWords
//
//  Created by  user on 03.07.11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"

@interface MenuLessons : TableViewController {
    
}

- (void) addLesson;
- (NSMutableArray *)loadLesson:(NSString *)lessonName;
@end

