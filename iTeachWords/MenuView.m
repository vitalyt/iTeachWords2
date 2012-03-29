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
	
//	UIColor *topColor = [UIColor colorWithRed:0.35f green:0.35f blue:0.35f alpha:1.0f];//UIColorFromRGB(0x424242);
//    UIColor *middleColor = [UIColor colorWithRed:0.33f green:0.33f blue:0.33f alpha:1.0f];
//	UIColor *bottomColor = [UIColor colorWithRed:0.3125f green:0.3125f blue:0.3125f alpha:1.0f];//UIColorFromRGB(0x424242);//UIColorFromRGB(0x2f2f2f);	
//	
//	CAGradientLayer *gradient = [[CAGradientLayer alloc] init];
//	gradient.frame = self.bounds;
//	gradient.colors = [NSArray arrayWithObjects:(id)topColor.CGColor, (id)middleColor.CGColor, (id)bottomColor.CGColor, nil];
//	[self.layer insertSublayer:gradient atIndex:0];
//	[gradient release];
    
	//////////////GET REFERENCE TO CURRENT GRAPHICS CONTEXT
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    //////////////CREATE BASE SHAPE WITH ROUNDED CORNERS FROM BOUNDS
	CGRect activeBounds = self.bounds;
	CGFloat cornerRadius = 5.0f;	
	CGFloat inset = 0.5f;	
	CGFloat originX = activeBounds.origin.x + inset;
	CGFloat originY = activeBounds.origin.y + inset;
	CGFloat width = activeBounds.size.width - (inset*2.0f);
	CGFloat height = activeBounds.size.height - (inset*2.0f);
    
	CGRect bPathFrame = CGRectMake(originX, originY, width, height);
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:bPathFrame cornerRadius:cornerRadius].CGPath;
	
	//////////////CREATE BASE SHAPE WITH FILL AND SHADOW
	CGContextAddPath(context, path);
	CGContextSetFillColorWithColor(context, [UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f].CGColor);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 6.0f, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f].CGColor);
    CGContextDrawPath(context, kCGPathFill);
	
	//////////////CLIP STATE
	CGContextSaveGState(context); //Save Context State Before Clipping To "path"
	CGContextAddPath(context, path);
	CGContextClip(context);
	
	//////////////DRAW GRADIENT
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	size_t count = 3;
	CGFloat locations[3] = {0.0f, 0.57f, 1.0f}; 
	CGFloat components[12] = 
	{	70.0f/255.0f, 70.0f/255.0f, 70.0f/255.0f, 1.0f,     //1
		55.0f/255.0f, 55.0f/255.0f, 55.0f/255.0f, 1.0f,     //2
		40.0f/255.0f, 40.0f/255.0f, 40.0f/255.0f, 1.0f};	//3
	CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, components, locations, count);
    
	CGPoint startPoint = CGPointMake(activeBounds.size.width * 0.5f, 0.0f);
	CGPoint endPoint = CGPointMake(activeBounds.size.width * 0.5f, activeBounds.size.height);
    
	CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
	CGColorSpaceRelease(colorSpace);
	CGGradientRelease(gradient);
	
	//////////////HATCHED BACKGROUND
    CGFloat buttonOffset = self.frame.size.height/2; //Offset buttonOffset by half point for crisp lines
	CGContextSaveGState(context); //Save Context State Before Clipping "hatchPath"
	CGRect hatchFrame = CGRectMake(0.0f, buttonOffset, activeBounds.size.width, (activeBounds.size.height - buttonOffset+1.0f));
	CGContextClipToRect(context, hatchFrame);
	
	CGFloat spacer = 6.0f;
	int rows = (activeBounds.size.width + activeBounds.size.height/spacer);
	CGFloat padding = 0.0f;
	CGMutablePathRef hatchPath = CGPathCreateMutable();
	for(int i=1; i<=rows; i++) {
		CGPathMoveToPoint(hatchPath, NULL, spacer * i, padding);
		CGPathAddLineToPoint(hatchPath, NULL, padding, spacer * i);
	}
	CGContextAddPath(context, hatchPath);
	CGPathRelease(hatchPath);
	CGContextSetLineWidth(context, 1.0f);
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.15f].CGColor);
	CGContextDrawPath(context, kCGPathStroke);
	CGContextRestoreGState(context); //Restore Last Context State Before Clipping "hatchPath"
    
    //////////////DRAW LINE
	CGMutablePathRef linePath = CGPathCreateMutable(); 
	CGFloat linePathY = buttonOffset;
	CGPathMoveToPoint(linePath, NULL, 20, linePathY);
	CGPathAddLineToPoint(linePath, NULL, activeBounds.size.width/4+activeBounds.size.width/2, linePathY);
	CGContextAddPath(context, linePath);
	CGPathRelease(linePath);
	CGContextSetLineWidth(context, 1.0f);
	CGContextSaveGState(context); //Save Context State Before Drawing "linePath" Shadow
	CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.6f].CGColor);
	CGContextSetShadowWithColor(context, CGSizeMake(0.0f, 1.0f), 0.0f, [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.2f].CGColor);
	CGContextDrawPath(context, kCGPathStroke);
	CGContextRestoreGState(context); //Restore Context State After Drawing "linePath" Shadow
    
}

@end
