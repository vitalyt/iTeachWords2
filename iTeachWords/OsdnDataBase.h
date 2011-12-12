//
//  OsdnDataBase.h
//  VEH
//
//  Created by Edwin Zuydendorp on 8/30/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSDNHash.h"

@interface OsdnDataBase : OSDNHash {

}
+ (NSData *) loadBaseWithURL:(NSString *)_url;
+ (NSString *) loadWebBaseWithURL:(NSString *)_url;
+ (void)addBaseWithURL:(NSString *)_url data:(NSData *)_data;
+ (void)addWebBaseWithURL:(NSString *)_url data:(NSURL *)_dataString;

@end
