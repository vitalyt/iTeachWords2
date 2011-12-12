//
//  NetworkStatusController.h
//  ABN op reis
//
//  Created by Vitaly Todorovych on 3/23/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NetworkStatusController : NSObject <UIAlertViewDelegate> {

}

+ (void) loadSelector:(SEL)selector withObject:(id)object OR:(SEL)selector2 withObject:(id)object2 delegate:(id)delegate;

@end
