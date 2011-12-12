//
//  MenuView.m
//  
//
//  Created by Vitaly Todorovych on 4/14/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "MenuView.h"


@implementation MenuView

- (void)drawRect:(CGRect)rect {
    
	[super drawRect:rect];
	
	
	
//	self.layer.borderWidth = 1.5;
//	self.layer.borderColor = UIColorFromRGB(0x888888).CGColor; 
//	self.layer.cornerRadius = 7;
//	self.layer.masksToBounds = YES;
	
	UIColor *topColor = [UIColor colorWithRed:0.9921f green:0.7529f blue:0.2470f alpha:1.0f];//UIColorFromRGB(0x424242);
	UIColor *bottomColor = [UIColor colorWithRed:0.99f green:0.6666f blue:0.2313f alpha:1.0f];//UIColorFromRGB(0x424242);//UIColorFromRGB(0x2f2f2f);	
	
	CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
	gradient.frame = self.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
	[self.layer insertSublayer:gradient atIndex:0];
	[gradient release];
}

@end
