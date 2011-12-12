//
//  WBRequest.h
//  WebsiteBuilder
//
//  Created by Yuri Kotov on 20.10.09.
//  Copyright 2009 Yalantis. All rights reserved.
//

//@class WBRequest;

@interface WBRequest : NSMutableURLRequest {
	id _delegate;
	NSInteger tag;
	NSString *parserFile;
}

@property (nonatomic, retain) id delegate;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, copy) NSString *parserFile;

+ (id) getRequestWithURL: (NSString*)url delegate: (id)delegate;
+ (id) getRequestWithURL: (NSString*)url values: (NSDictionary*)values delegate: (id)delegate;
+ (id) postRequestWithURL: (NSString*)url values: (NSDictionary*)values delegate: (id)delegate;
+ (id) postRequestWithURL: (NSString*)url dataString: (NSString*)dataString delegate: (id)delegate;

+ (id) jsonRequestWithURL: (NSString*)url values: (NSDictionary*)values delegate: (id)delegate;

@end

