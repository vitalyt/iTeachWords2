//
//  WBEngine.m
//  WebsiteBuilder
//
//  Created by Yuri Kotov on 19.10.09.
//  Copyright 2009 Yalantis. All rights reserved.
//

#import "WBEngine.h"
#import "WBRequest.h"
#import "WBConnection.h"

#import <SystemConfiguration/SystemConfiguration.h>
#import <Foundation/Foundation.h>
#import <netinet/in.h>
#import <netdb.h>

@implementation WBEngine

@synthesize errorMessage;
#pragma mark -
#pragma mark NSURLConnectionDelegate


- (void)connection:(WBConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	WBRequest *request = connection.request;
	
	id delegate = request.delegate;
	SEL selector = @selector(connection:didReceiveResponse:);
	if (delegate && [delegate respondsToSelector:selector])
	{
		[delegate performSelector:selector withObject:connection];
	}
    if (loadingView) {
        [loadingView.view removeFromSuperview];
    }
}

- (void) connection: (WBConnection*)connection didReceiveData: (NSData*)data
{
	[connection appendData:data];
}

- (void) connectionDidFinishLoading: (WBConnection*)connection
{
	#ifndef __OPTIMIZE__
		NSString *response = [[NSString alloc] initWithData:connection.data
												   encoding:NSUTF8StringEncoding];
		NSLog(@"Received: \n%@", response);
		[response release];
	#endif
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

	WBRequest *request = connection.request;

	id delegate = request.delegate;
	SEL selector = @selector(connectionDidFinishLoading:);
	if (delegate && [delegate respondsToSelector:selector])
	{
		[delegate performSelector:selector withObject:connection];
	}
    if (loadingView) {
        [loadingView.view removeFromSuperview];
    }
}

-(void) showLoadingViewIn:(UIView *)superView loadingText:(NSString *)text{
    if (!loadingView) {
        loadingView = [[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil];
    }
    [superView addSubview:loadingView.view];
    loadingView.titleLabel.text = text;
}

-(void) closeLoadingView{
    [loadingView.view removeFromSuperview];
}

- (void) connection: (WBConnection*)connection didFailWithError: (NSError*)error
{
    [UIAlertView removeMessage];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	
	NSLog(@"NSURLConnection error: %@ with code:%i", [error localizedDescription], [error code]);
    if (!errorFlag) {
        errorFlag = YES;
        if ([errorMessage length] > 0) {
            [UIAlertView displayMessage:errorMessage];
        }else{
            [UIAlertView displayMessage:NSLocalizedString(@"Er is op dit moment geen verbinding mogelijk. Probeer het later opnieuw.", @"Er is op dit moment geen verbinding mogelijk. Probeer het later opnieuw.")];
        }
    }

	WBRequest *request = connection.request;
	id delegate = request.delegate;
	SEL selector = @selector(connection:didFailWithError:);
	if (delegate && [delegate respondsToSelector:selector])
	{
		[delegate performSelector:selector withObject:connection withObject:error];
	}
    if (loadingView) {
        [loadingView.view removeFromSuperview];
    }
}

#pragma mark -
- (BOOL) performRequest: (WBRequest*)request
{

	BOOL success = NO;
    errorFlag = NO;
	#ifndef __OPTIMIZE__
		NSString *body = [[NSString alloc] initWithData:[request HTTPBody]
											   encoding:NSUTF8StringEncoding];
		NSLog(@"Sent: %@\n\n%@", [request URL], body);
		[body release];
	#endif

	success = YES;
	WBConnection *connection = [[WBConnection alloc] initWithRequest:request
															delegate:self];
	[connection start];
	[connection autorelease];
	
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	return success;
}

-(void)dealloc
{
	//[information release];
	//[url release];
    if (loadingView) {
        [loadingView release];
    }
    [errorMessage release];
	[super dealloc];
}

@end



