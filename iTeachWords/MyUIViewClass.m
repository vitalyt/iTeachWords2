//
//  ViewContainer.m
//  VEH
//
//  Created by Admin on 22.04.10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "MyUIViewClass.h"

//#define radius 10

@implementation MyUIViewClass

- (void)drawRect:(CGRect)rect {
    
	[super drawRect:rect];
	self.layer.borderWidth = 1.5;
	self.layer.borderColor = UIColorFromRGB(0x888888).CGColor; 
	self.layer.cornerRadius = 10;
	self.layer.masksToBounds = YES;
	
   /* 
	UIColor *topColor = UIColorFromRGB(0x424242);
	UIColor *bottomColor = UIColorFromRGB(0x2f2f2f);	
	
	CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
	gradient.frame = self.bounds;
	gradient.colors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)bottomColor.CGColor, nil];
	[self.layer insertSublayer:gradient atIndex:0];
	[gradient release];
    */
}

@end
