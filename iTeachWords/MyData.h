//
//  MyData.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/12/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyData : NSObject {
	NSMutableArray *options, *rusWords, *engWords, *rusTranscriptions, *engTranscriptions;
	
}
@property (nonatomic,retain) NSMutableArray *options, *rusWords, *engWords, *rusTranscriptions, *engTranscriptions;

- (id)initWithLesson:(NSString *)_lesson;
- (void) loadDataWithLesson:(NSString *)_lesson;
- (NSArray *) convertData;
+ (NSMutableArray *) getOptionWithString:(NSString *)_str;
+ (NSMutableArray *) getWordWithString:(NSString *)_str;
@end
