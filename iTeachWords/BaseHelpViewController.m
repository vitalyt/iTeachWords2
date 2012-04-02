//
//  BaseHelpViewController.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 02.04.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "BaseHelpViewController.h"

@implementation BaseHelpViewController
#pragma mark ---------------------------------->> 
#pragma mark -------------->>hint deleage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _hint = [[EMHint alloc] init];
        [_hint setHintDelegate:self];
        usedObjects = [[NSMutableArray alloc] init];
        unUsedObjects = [[NSMutableArray alloc] init];
    }
    return self;
}

-(UIView*)hintStateViewToHint:(id)hintState
{
    [usedObjects addObject:_currentSelectedObject];
    return _currentSelectedObject;
}
-(UIView*)hintStateViewForDialog:(id)hintState
{
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(50, 50, 200, 50)];
    l.numberOfLines = 4;
    
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:@"I am the info button!"];
    return l;
}
#pragma mark ---------------------------------->> 
#pragma mark -------------->>private
-(void)_onTap:(id)sender
{
    _currentSelectedObject = sender;
    [_hint presentModalMessage:@"One last hint for ya." where:self.view];
}
#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!_hint) {
        _hint = [[EMHint alloc] init];
        [_hint setHintDelegate:self];
    }
}

- (void)dealloc{
    [unUsedObjects release];
    unUsedObjects = nil;
    [usedObjects release];
    usedObjects = nil;
    [super dealloc];
}

@end
