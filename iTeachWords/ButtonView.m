//
//  ButtonView.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/26/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "ButtonView.h"

@implementation ButtonView

@synthesize delegate,index,type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self performInitializations];
    }
    return self;
}

- (void)performInitializations {
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [scrollImage setHidden:YES];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"scrollImageWasShowed"]) {
        [scrollImage setHidden:NO];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [scrollImage setHidden:YES];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"scrollImageWasShowed"]) {
        [scrollImage setHidden:NO];
    }
}

- (IBAction)buttonAction:(id)sender {
    SEL selector = @selector(buttonDidClick: withIndex:);
    if ([delegate respondsToSelector:selector]) {
        [delegate performSelector:selector withObject:sender withObject:[NSNumber numberWithInteger:type]];
    }
}

- (void)changeButtonImage:(UIImage*)_image{
    [button setImage:_image forState:UIControlStateNormal];
    [button setTag:index];
//    [button.layer setNeedsDisplay];
}

@end
