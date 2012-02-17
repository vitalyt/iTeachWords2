//
//  PagesScrolView.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/26/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

//#import <UIKit/UIKit.h>

@interface BaseScrollView : UIScrollView <UIScrollViewDelegate>{
    UIView      *contentView;
    NSInteger   index;
}

@property (assign) NSInteger index;

@end
