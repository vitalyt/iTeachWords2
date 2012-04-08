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

- (void)dealloc {
    [button release];
    [super dealloc];
}

- (IBAction)buttonAction:(id)sender {
    
    SEL selector = @selector(buttonDidClick: withIndex:);
    if ([delegate respondsToSelector:selector]) {
        [delegate performSelector:selector withObject:sender withObject:[NSNumber numberWithInteger:type]];
    }
}

- (void)viewDidUnload
{
    [button release];
    button = nil;
    delegate = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)changeButtonImage:(UIImage*)_image{
    [button setImage:_image forState:UIControlStateNormal];
    [button setTag:index];
//    [button.layer setNeedsDisplay];
}

@end
