//
//  WBConnection.h
//  WebsiteBuilder
//
//  Created by Yuri Kotov on 20.10.09.
//  Copyright 2009 Yalantis. All rights reserved.
//

@class WBRequest;

@interface WBConnection : NSURLConnection
{
	NSMutableData *_data;
	WBRequest *_request;
}

@property (nonatomic, readonly) NSMutableData *data;
@property (nonatomic, retain) WBRequest *request;

- (void) appendData: (NSData*)data;

@end


