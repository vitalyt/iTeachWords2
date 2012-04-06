//
//  UIAlertView+Interaction.m
//  CountDown
//
//  Created by Yalantis on 14.01.10.
//  Copyright 2010 Yalantis. All rights reserved.
//

#import "UIAlertView+Interaction.h"
#import "CustomAlertView.h"

@implementation UIAlertView (Interaction)

+ (void)displayError:(NSString *)message {
	CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Error"
													message:message
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];	
}
+ (void)displayErrorWithResponce:(NSDictionary *)dict{
    NSString *message; 
    if (dict 
        && [dict objectForKey:@"messages"] 
        && [[[dict objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"message"]) {
        
        message = [[[dict objectForKey:@"messages"] objectAtIndex:0] objectForKey:@"message"];
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

+ (void)displayError:(NSString *)message title:(NSString *)title {
	CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:title
													message:message
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

+ (void)displayMessage:(NSString *)message {
	CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil
													message:message
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

+ (void)displayMessage:(NSString *)message withDelegate:(id)delegate {
	CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:nil
													message:message
												   delegate:delegate
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];	
}

+ (UIAlertView *)showAlert:(NSString *)message withActivity:(BOOL)activity {
	CustomAlertView *alertView = [[CustomAlertView alloc] initWithTitle: message
                                                        message: @"\n"
                                                       delegate: self
                                              cancelButtonTitle: nil
                                              otherButtonTitles: nil];
	
	if (activity) {
		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] 
                                                 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		activityView.frame = CGRectMake(139.0f-18.0f, 80.0f, 37.0f, 37.0f);
		[alertView addSubview:activityView];
		[activityView startAnimating];
		[activityView release];
	} else {
		UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
		[alertView addSubview:progressView];
		[progressView setProgressViewStyle: UIProgressViewStyleBar];
		[progressView release];
	}
	[alertView show];
	return [alertView autorelease];
}


+ (void) showMessage:(NSString *)message {
	[self showMessage:message withDuration:DEFAULT_DURATION andDelay:DEFAULT_DELAY];
}

+ (void) showMessage:(NSString *)message withColor:(UIColor *)color{	
    [self showMessage:message textAlignment:DEFAULT_TEXTALIGNMENT withDuration:DEFAULT_DURATION andDelay:DEFAULT_DELAY backgroundColor:color borderColor:nil shadowColor:nil massageOffsetSize:CGSizeMake(DEFAULT_HTEXTOFFSET, DEFAULT_VTEXTOFFSET) borderWidth:DEFAULT_BORDERWIDTH shadowRadius:DEFAULT_RADIUS cornerRadius:DEFAULT_RADIUS startScale:DEFAULT_STARTSCALE middleScale:DEFAULT_MIDDLESCALE endScale:DEFAULT_ENDSCALE];
}

+ (void) showMessage:(NSString *)message withDuration:(NSTimeInterval)duration andDelay:(NSTimeInterval)delay {
	[self showMessage:message textAlignment:DEFAULT_TEXTALIGNMENT withDuration:duration andDelay:delay backgroundColor:nil borderColor:nil shadowColor:nil massageOffsetSize:CGSizeMake(DEFAULT_HTEXTOFFSET, DEFAULT_VTEXTOFFSET) borderWidth:DEFAULT_BORDERWIDTH shadowRadius:DEFAULT_RADIUS cornerRadius:DEFAULT_RADIUS startScale:DEFAULT_STARTSCALE middleScale:DEFAULT_MIDDLESCALE endScale:DEFAULT_ENDSCALE];
}

+ (void) showMessage:(NSString *)message textAlignment:(UITextAlignment)textAlignment {
	[self showMessage:message textAlignment:textAlignment withDuration:DEFAULT_DURATION andDelay:DEFAULT_DELAY backgroundColor:nil borderColor:nil shadowColor:nil massageOffsetSize:CGSizeMake(DEFAULT_HTEXTOFFSET, DEFAULT_VTEXTOFFSET) borderWidth:DEFAULT_BORDERWIDTH shadowRadius:DEFAULT_RADIUS cornerRadius:DEFAULT_RADIUS startScale:DEFAULT_STARTSCALE middleScale:DEFAULT_MIDDLESCALE endScale:DEFAULT_ENDSCALE];
}

+ (void) showMessage:(NSString *)message startScale:(CGFloat)sScale middleScale:(CGFloat)mScale endScale:(CGFloat)eScale {
	[self showMessage:message textAlignment:DEFAULT_TEXTALIGNMENT withDuration:DEFAULT_DURATION andDelay:DEFAULT_DELAY backgroundColor:nil borderColor:nil shadowColor:nil massageOffsetSize:CGSizeMake(DEFAULT_HTEXTOFFSET, DEFAULT_VTEXTOFFSET) borderWidth:DEFAULT_BORDERWIDTH shadowRadius:DEFAULT_RADIUS cornerRadius:DEFAULT_RADIUS startScale:sScale middleScale:mScale endScale:eScale];
}

+ (void) showMessage:(NSString *)message
	   textAlignment:(UITextAlignment)textAlignment
		withDuration:(NSTimeInterval)duration
			andDelay:(NSTimeInterval)delay
	 backgroundColor:(UIColor *)backgroundColor
		 borderColor:(UIColor *)borderColor
		 shadowColor:(UIColor *)shadowColor
   massageOffsetSize:(CGSize)offsetSize
		 borderWidth:(CGFloat)borderWidth
		shadowRadius:(CGFloat)shadowRadius
		cornerRadius:(CGFloat)cornerRadius
		  startScale:(CGFloat)sScale 
		 middleScale:(CGFloat)mScale
			endScale:(CGFloat)eScale;
{
	//Message label
	if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:DEFAULT_VIEWTAG] != nil) {
		return;
	}
	UILabel *messageLabel = [[UILabel alloc] init];
	messageLabel.textAlignment = textAlignment;
	messageLabel.numberOfLines = 0;
	messageLabel.lineBreakMode = UILineBreakModeWordWrap;
	messageLabel.text = message;
	messageLabel.font = [UIFont fontWithName:DEFAULT_FONTNAME size:DEFAULT_FONTSIZE];
	messageLabel.textColor = [UIColor blackColor];
	messageLabel.backgroundColor = [UIColor clearColor];
	//Message size and rect
	CGSize messageSize = [message sizeWithFont:messageLabel.font
							 constrainedToSize:CGSizeMake(DEFAULT_MESSAGEWIDTH, 9999.0f)
								 lineBreakMode:UILineBreakModeWordWrap];
	CGRect messageRect = CGRectMake(offsetSize.width + borderWidth, 
									offsetSize.height + borderWidth, 
									messageSize.width, 
									messageSize.height);
	messageLabel.frame = messageRect;
	messageSize.width += offsetSize.width*2.0f + borderWidth;
	messageSize.height += offsetSize.height*2.0f + borderWidth;
	messageRect = CGRectMake(0.0f, -50.0f, messageSize.width, messageSize.height);
	//Message view
	UIView *content = [[UIView alloc] init];
	content.frame = messageRect;
	if (backgroundColor != nil) {
		content.backgroundColor = backgroundColor;
	} else {
		content.backgroundColor = [UIColor colorWithRed:(60.0f/255.0f) green:(60.0f/255.0f) blue:(60.0f/255.0f) alpha:1.0f];
	}
	content.alpha = 0.8f;
	content.layer.cornerRadius = cornerRadius;
	content.layer.shadowRadius = shadowRadius;
	content.layer.masksToBounds = NO;
	content.layer.shadowOffset = CGSizeMake(0.0f, shadowRadius/2.0f);
	content.layer.shadowOpacity = 1.0f;
	if (shadowColor != nil) {
		content.layer.shadowColor = [shadowColor CGColor];
	}
	content.layer.borderWidth = borderWidth;
	if (borderColor != nil) {
		content.layer.borderColor = [borderColor CGColor];
	} else {
		content.layer.borderColor = [[UIColor colorWithRed:(128.0f/255.0f) green:(128.0f/255.0f) blue:(128.0f/255.0f) alpha:1.0f] CGColor];
	}
	content.layer.shadowPath = [UIBezierPath bezierPathWithRect:messageRect].CGPath;
	//Root view
	UIView *rootView = [[UIView alloc] init];
	rootView.tag = DEFAULT_VIEWTAG;
	rootView.frame = messageRect;
	//Compose views
	messageLabel.center = CGPointMake(messageSize.width/2.0f, messageSize.height/2.0f);
	[content addSubview:messageLabel];
	[messageLabel release];
	[rootView addSubview:content];
	[content release];
	
	//Animation
	rootView.alpha = 0.0f;
	rootView.center = [[UIApplication sharedApplication] keyWindow].center;
	if (sScale <= 0.0f) {
		sScale = 0.01f;
	}
	if (mScale <= 0.0f) {
		mScale = 0.01f;
	}
	if (eScale <= 0.0f) {
		eScale = 0.01f;
	}
	rootView.transform = CGAffineTransformMakeScale(sScale, sScale);
	[[[UIApplication sharedApplication] keyWindow] addSubview:rootView];
    if ([[[UIDevice currentDevice] systemVersion] doubleValue] > 4.0) {
        [UIView animateWithDuration:duration*0.66 
                              delay:0.0 
                            options:UIViewAnimationCurveEaseOut
                         animations:^ {
                             rootView.alpha = 0.66f;
                             rootView.transform = CGAffineTransformMakeScale(mScale, mScale);
                         } 
                         completion:^(BOOL completed) {
                             [UIView animateWithDuration:duration*0.33 
                                                   delay:0.0 
                                                 options:UIViewAnimationCurveLinear 
                                              animations:^{
                                                  rootView.alpha = 1.0f;
                                                  rootView.transform = CGAffineTransformIdentity;
                                              } 
                                              completion:^(BOOL completed) {
                                                  [UIView animateWithDuration:duration
                                                                        delay:delay
                                                                      options:UIViewAnimationCurveEaseIn
                                                                   animations:^{
                                                                       rootView.alpha = 0.0f;
                                                                       rootView.transform = CGAffineTransformMakeScale(eScale, eScale);
                                                                   }
                                                                   completion:^(BOOL completed) {
                                                                       [rootView removeFromSuperview];
                                                                       [rootView release];
                                                                   }];
                                              }];
                         }];
    }
    
}

+ (void)showLoadingViewWithMwssage:(NSString*)message{
    [UIAlertView showMessage:message textAlignment:UITextAlignmentCenter withDuration:.0 andDelay:20 backgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:.75f] borderColor:[UIColor grayColor] shadowColor:[UIColor clearColor] massageOffsetSize:CGSizeMake(0, 0) borderWidth:2.0 shadowRadius:DEFAULT_RADIUS cornerRadius:DEFAULT_RADIUS startScale:DEFAULT_STARTSCALE middleScale:DEFAULT_MIDDLESCALE endScale:DEFAULT_ENDSCALE activityView:YES inView:nil];
}

+ (void) showMessage:(NSString *)message
	   textAlignment:(UITextAlignment)textAlignment
		withDuration:(NSTimeInterval)duration
			andDelay:(NSTimeInterval)delay
	 backgroundColor:(UIColor *)backgroundColor
		 borderColor:(UIColor *)borderColor
		 shadowColor:(UIColor *)shadowColor
   massageOffsetSize:(CGSize)offsetSize
		 borderWidth:(CGFloat)borderWidth
		shadowRadius:(CGFloat)shadowRadius
		cornerRadius:(CGFloat)cornerRadius
		  startScale:(CGFloat)sScale 
		 middleScale:(CGFloat)mScale
			endScale:(CGFloat)eScale
        activityView:(BOOL)isActivity 
              inView:(UIView*)baseView
{
    if (isActivity) {
        offsetSize.width = offsetSize.width+20+DEFAULT_ACTIVITYOFFSET;
    }
	//Message label
    UIView* _baseView = ((baseView)?baseView:[[UIApplication sharedApplication] keyWindow]);
	if ([_baseView viewWithTag:DEFAULT_VIEWTAG] != nil) {
		return;
	}
	UILabel *messageLabel = [[UILabel alloc] init];
	messageLabel.textAlignment = textAlignment;
	messageLabel.numberOfLines = 0;
	messageLabel.lineBreakMode = UILineBreakModeWordWrap;
	messageLabel.text = message;
	messageLabel.font = [UIFont fontWithName:DEFAULT_FONTNAME size:DEFAULT_FONTSIZE];
	messageLabel.textColor = [UIColor DEFAULT_TEXTCOLOR];
	messageLabel.backgroundColor = [UIColor clearColor];
	//Message size and rect
	CGSize messageSize = [message sizeWithFont:messageLabel.font
							 constrainedToSize:CGSizeMake(DEFAULT_MESSAGEWIDTH, 9999.0f)
								 lineBreakMode:UILineBreakModeWordWrap];
	CGRect messageRect = CGRectMake(offsetSize.width + borderWidth + (isActivity)?+25+DEFAULT_ACTIVITYOFFSET*2:0, 
									offsetSize.height + borderWidth+12, 
									messageSize.width, 
									messageSize.height);
	messageLabel.frame = messageRect;
	messageSize.width += offsetSize.width*2.0f + borderWidth;
	messageSize.height += offsetSize.height*2.0f + borderWidth;
	messageRect = CGRectMake(0.0f, 0.0f, messageSize.width, messageSize.height+30);
    
	//Message view
	UIView *content = [[UIView alloc] init];
	content.frame = messageRect;
	if (backgroundColor != nil) {
		content.backgroundColor = backgroundColor;
	} else {
		content.backgroundColor = [UIColor colorWithRed:(60.0f/255.0f) green:(60.0f/255.0f) blue:(60.0f/255.0f) alpha:1.0f];
	}
	//content.alpha = 0.8f;
	content.layer.cornerRadius = cornerRadius;
	content.layer.shadowRadius = shadowRadius;
	content.layer.masksToBounds = NO;
	content.layer.shadowOffset = CGSizeMake(0.0f, shadowRadius/2.0f);
	content.layer.shadowOpacity = 1.0f;
	if (shadowColor != nil) {
		content.layer.shadowColor = [shadowColor CGColor];
	}
	content.layer.borderWidth = borderWidth;
	if (borderColor != nil) {
		content.layer.borderColor = [borderColor CGColor];
	} else {
		content.layer.borderColor = [[UIColor colorWithRed:(128.0f/255.0f) green:(128.0f/255.0f) blue:(128.0f/255.0f) alpha:1.0f] CGColor];
	}
	content.layer.shadowPath = [UIBezierPath bezierPathWithRect:messageRect].CGPath;
	//Root view
	UIView *rootView = [[[UIView alloc] init] autorelease];
    [rootView setBackgroundColor:[UIColor clearColor]];
	rootView.tag = DEFAULT_VIEWTAG;
	rootView.frame = messageRect;
	//Compose views
	//messageLabel.center = CGPointMake(messageSize.width/2.0f, messageSize.height/2.0f);
	[content addSubview:messageLabel];
	[messageLabel release];
	[rootView addSubview:content];
	[content release];
	
    //ActivityView
    UIActivityIndicatorView *activityView;
    if (isActivity) {
        activityView = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(messageLabel.frame.origin.x-20-DEFAULT_ACTIVITYOFFSET, content.frame.size.height/2-10, 20, 20)] autorelease];
        [activityView setCenter:CGPointMake(activityView.center.x, activityView.center.y)];
        [activityView startAnimating];
        [content addSubview:activityView];
    }
    
	//Animation
	rootView.center = _baseView.center;
	[_baseView addSubview:rootView];
    [_baseView bringSubviewToFront:rootView];    
}

+ (void)removeMessage{
    if ([[[UIApplication sharedApplication] keyWindow] viewWithTag:DEFAULT_VIEWTAG] != nil) {
        [[[[UIApplication sharedApplication] keyWindow] viewWithTag:DEFAULT_VIEWTAG] removeFromSuperview];
    }
}



@end
