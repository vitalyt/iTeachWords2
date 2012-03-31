//
//  AlertTableView.h
//  Demo
//
//  Created by Edwin Zuydendorp on 1/5/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomAlertView.h"
@protocol AlertTableViewDelegate

-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context;

@end

@class MyUIViewWhiteClass;
@interface AlertTableView : CustomAlertView <UITableViewDelegate, UITableViewDataSource>{
    UITableView *myTableView;
    MyUIViewWhiteClass *baseCornerRadiusView;
    id<AlertTableViewDelegate> caller;
    id context;
    NSArray *data;
	int tableHeight;
}
-(id)initWithCaller:(id<AlertTableViewDelegate>)_caller data:(NSArray*)_data title:(NSString*)_title andContext:(id)_context;
@property(nonatomic, retain) id<AlertTableViewDelegate> caller;
@property(nonatomic, retain) id context;
@property(nonatomic, retain) NSArray *data;
@end

@interface AlertTableView(HIDDEN)
-(void)prepare;
-(float)cellHeight;
@end
