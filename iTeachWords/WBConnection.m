//
//  WBConnection.m
//  WebsiteBuilder
//
//  Created by Yuri Kotov on 20.10.09.
//  Copyright 2009 Yalantis. All rights reserved.
//

#import "WBConnection.h"
#import "WBRequest.h"


@implementation WBConnection

@synthesize data = _data;
@synthesize request = _request;

#pragma mark -
#pragma mark NSObject
- (void) dealloc
{
	[_request release];
	[_data release];
	[super dealloc];
}

#pragma mark -
#pragma mark NSURLConnection
- (id) initWithRequest: (WBRequest*)request delegate: (id)delegate
{
	if (self = [super initWithRequest:request delegate:delegate])
	{
		_data = [NSMutableData new];
		self.request = request;
	}

	return self;
}
#pragma mark -
- (void) appendData: (NSData*)data
{
	[_data appendData:data];
}

@end


