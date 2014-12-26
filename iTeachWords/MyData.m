//
//  MyData.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/12/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "MyData.h"


@implementation MyData

@synthesize options, rusWords, engWords, rusTranscriptions, engTranscriptions;

- (id)initWithLesson:(NSString *)_lesson{
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super init]) {
		[self loadDataWithLesson:_lesson];
    }
    return self;
}

- (NSArray *) convertData{
	
	NSMutableArray *_array = [[NSMutableArray alloc] init];
	for (int i = 0; i < [engWords count]; i++) {
		NSMutableDictionary *_dict = [[NSMutableDictionary alloc] init];
		if ([[engWords objectAtIndex:i] length] == 0) {
			break;
		}
		if (   [engWords count] > i) {
			[_dict setObject:[engWords objectAtIndex:i] forKey:@"engWord"];
		}
		else {
			break;
		}

		if (   [rusWords count] > i) {
			[_dict setObject:[rusWords objectAtIndex:i] forKey:@"rusWord"];
		}
		else {
			break;
		}
		if (   [engTranscriptions count] > i) {
			[_dict setObject:[engTranscriptions objectAtIndex:i] forKey:@"engTranscription"];
		}		
		if (   [rusTranscriptions count] > i) {
			[_dict setObject:[rusTranscriptions objectAtIndex:i] forKey:@"rusTranscription"];
		}		

		[_array addObject:_dict];
	}
	//NSLog(@"%@",_array);
	return _array;
}

- (void) loadDataWithLesson:(NSString *)_lesson{
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"LessonResouce"]];
	path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/",_lesson]];
	path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"1.TXT"]  ];
	NSString *str = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	NSLog(@"path->%@",path);
	NSLog(@"str->%@",str);
	NSArray *chapters = [str componentsSeparatedByString: @"<"];
	for (int i = 0; i < [chapters count]; i++) {
		if ([[chapters objectAtIndex:i] length] <= 0) {
			continue;
		}
		switch ([[chapters objectAtIndex:i] characterAtIndex:0]) {
			case 'B':
				options = (NSMutableArray *)[[chapters objectAtIndex:i] componentsSeparatedByString: @"\n"];
				[options removeObjectAtIndex:0];
				break;
			case 'A':
				NSLog(@"%@",[chapters objectAtIndex:i]);
				engWords = (NSMutableArray *)[[chapters objectAtIndex:i] componentsSeparatedByString: @"\n"];
				[engWords removeObjectAtIndex:0];
				
				for(int i=0;i<[engWords count];i++){
					NSMutableString *s = [[NSMutableString alloc] initWithFormat:@"%@",[engWords objectAtIndex:i]];
					if(([s length]>0)&&([s characterAtIndex:([s length]-1)] == '\r')){
						NSRange subRange;
						subRange.location = [s length]-1;
						subRange.length = 1;
						[s deleteCharactersInRange:subRange]; 
						//NSLog(@"engWords->%@",s);
						[engWords replaceObjectAtIndex:i withObject:s];
					}
				}
				
				break;
			case 'Q':
				rusWords = (NSMutableArray *)[[chapters objectAtIndex:i] componentsSeparatedByString: @"\n"];
				[rusWords removeObjectAtIndex:0];
				
				for(int i=0;i<[rusWords count];i++){
					NSMutableString *s = [[NSMutableString alloc] initWithFormat:@"%@",[rusWords objectAtIndex:i]];
					if(([s length]>0)&&([s characterAtIndex:([s length]-1)] == '\r')){
						NSRange subRange;
						subRange.location = [s length]-1;
						subRange.length = 1;
						[s deleteCharactersInRange:subRange]; 
						[rusWords replaceObjectAtIndex:i withObject:s];
					}
				}
				break;
			case 'I':
				engTranscriptions = (NSMutableArray *)[[chapters objectAtIndex:i] componentsSeparatedByString: @"\n"];
				[engTranscriptions removeObjectAtIndex:0];
				break;
			case 'T':
				rusTranscriptions = (NSMutableArray *)[[chapters objectAtIndex:i] componentsSeparatedByString: @"\n"];
				[rusTranscriptions removeObjectAtIndex:0];
				
				break;
			default:
				break;
		}
	}
}



+ (NSMutableArray *) getOptionWithString:(NSString *)_str{
	_str = [[_str componentsSeparatedByString: @"\r"] objectAtIndex:0];
	return (NSMutableArray *)[[[_str componentsSeparatedByString: @"^"] lastObject] componentsSeparatedByString:@","];
}

+ (NSMutableArray *) getWordWithString:(NSString *)_str{
	return (NSMutableArray *)[[[_str componentsSeparatedByString: @"^"] objectAtIndex:0] componentsSeparatedByString:@" "];
}
@end
