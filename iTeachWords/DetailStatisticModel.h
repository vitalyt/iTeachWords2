//
//  DetailStatisticModel.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/31/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DetailStatisticModel : NSObject {
@private
    int totalResponse;
    int successful;
}

@property (nonatomic) int totalResponse;
@property (nonatomic) int successful;

@end
