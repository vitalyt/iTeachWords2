//
//  TestsViewProtocol.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/21/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol TestsViewProtocol <NSObject>
@optional
- (void) clickGame;
- (void) clickTestOneOfSix;
- (void) clickTest1;
- (void) clickStatistic;


@end
