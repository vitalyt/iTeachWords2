//
//  WBRequest.m
//  WebsiteBuilder
//
//  Created by Yuri Kotov on 20.10.09.
//  Copyright 2009 Yalantis. All rights reserved.
//

#import "WBRequest.h"
#import "JSON.h"

@implementation WBRequest

@synthesize delegate = _delegate;
@synthesize tag;
@synthesize parserFile;

#pragma mark -
#pragma mark NSObject
- (void) dealloc
{
	[parserFile release];
	[_delegate release];
	[super dealloc];
}

#pragma mark -
+ (id) getRequestWithURL: (NSString*)url delegate: (id)delegate
{
	id request = [self requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
	if (request)
	{
		[request setDelegate:delegate];
	}
	return request;
}

+ (id) getRequestWithURL: (NSString*)url values: (NSDictionary*)values delegate: (id)delegate
{
	url = [url stringByAppendingString:@"?"];
	for (NSString *key in values)
	{
		NSString *value = [[values valueForKey:key] description];
		url = [url stringByAppendingFormat:@"%@=%@&",
			   [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
			   [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	}
	return [self getRequestWithURL:url delegate:delegate];
}

+ (id) postRequestWithURL: (NSString*)url values: (NSDictionary*)values delegate: (id)delegate
{
	id request = [self getRequestWithURL:url delegate:delegate];
	if (request)
	{
		[request setHTTPMethod:@"POST"];
		NSMutableString *string = [NSMutableString new];
		for (NSString *key in values)
		{
			NSString *value = [[values valueForKey:key] description];
			value = [value stringByAddingPercentEscapesUsingEncoding:
					 NSUTF8StringEncoding];
			[string appendFormat:@"%@=%@&", key, value];
		}
		NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
		[request setHTTPBody:data];
		[string release];
	}
	return request;
}

+ (id) postRequestWithURL: (NSString*)url dataString: (NSString*)dataString delegate: (id)delegate
{
	id request = [self getRequestWithURL:url delegate:delegate];
	if (request)
	{
		[request setHTTPMethod:@"POST"];
		NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
		[request setHTTPBody:data];
	}
	return request;
}

+ (id) jsonRequestWithURL: (NSString*)url values: (NSDictionary*)values delegate: (id)delegate
{
	id request = [self getRequestWithURL:url delegate:delegate];
	if (request)
	{
		[request setHTTPMethod:@"POST"];
		NSMutableString *string = [NSMutableString stringWithString:@"REQUEST={"];
		for (NSString *key in values)
		{
			NSString *value = [[values valueForKey:key] description];
			value = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			[string appendFormat:@"\"%@\":\"%@\",", key, value];
		}
		if ([string hasSuffix:@","]) {
			NSRange range = NSMakeRange([string length]-1, 1);
			[string deleteCharactersInRange:range];
		}
		[string appendFormat:@"}"];
		NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
		[request setHTTPBody:data];
		
		NSString *postLength = [NSString stringWithFormat:@"%d", [data length]];
		[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
		
	}
	return request;
}

+ (BOOL) allowsAnyHTTPSCertificateForHost:(NSString *) host {
    return YES;
}

@end

