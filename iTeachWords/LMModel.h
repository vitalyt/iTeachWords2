//
//  LMModel.h
//  MenuItemTesting
//
//  Created by Vitaly Todorovych on 3/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LMModel : NSObject {
    NSMutableArray      *wordsStore;
}

@property (nonatomic, retain)   NSMutableArray  *wordsStore;

+ (LMModel *)sharedLMModel;

@end
