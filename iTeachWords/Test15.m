//
//  Test7.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/22/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "Test15.h"
#import "MyData.h"

@implementation Test15
@synthesize flg16;
- (IBAction) help{
	textBox.text = [[words objectAtIndex:index] objectForKey:@"engWord"];
	//[words addObject:word];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction) nextWord{
	if (index+1 >= [words count]) {
		[self back];
		return;
	}
	if ([self test]) {
		index++;
        statisticView.right++;
        statisticView.totalQuestions++;
		flgPlay = YES;
		//[self playWord:[NSString stringWithFormat:@"E%d",index]];
		[self createWord];
	}
    statisticView.index++;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self nextWord];
	return YES;
}

- (void) soundDidPlaying{
	[self closePlayer];
	if (flgPlay) {
		flgPlay = NO;
		[self createWord];
	}
	
}

- (void) createWord{
    NSMutableArray	*wordsArray,*optionArray;
    NSLog(@"lblWordRus->%@",[[words objectAtIndex:index] objectForKey:@"rusWord"]);
    NSLog(@"lblWordEng->%@",[[words objectAtIndex:index] objectForKey:@"engWord"]);
	if (!flg16) {
		lblWordRus.text = [[words objectAtIndex:index] objectForKey:@"engWord"];
        wordsArray = (NSMutableArray *)[MyData getWordWithString:[[words objectAtIndex:index] objectForKey:@"rusWord"]];
        optionArray = (NSMutableArray *)[MyData getOptionWithString:[[words objectAtIndex:index] objectForKey:@"rusWord"]];
	}
	else {
		lblWordRus.text = [[words objectAtIndex:index] objectForKey:@"rusWord"];
        wordsArray = (NSMutableArray *)[MyData getWordWithString:[[words objectAtIndex:index] objectForKey:@"engWord"]];
        optionArray = (NSMutableArray *)[MyData getOptionWithString:[[words objectAtIndex:index] objectForKey:@"engWord"]];
	}
	//[self playWord:[NSString stringWithFormat:@"R%d",index+1]];
    
	NSMutableString *_str = [[NSMutableString alloc] initWithFormat:@""];
	for (int i = 0; i < [wordsArray count]; i++) {
		if ([optionArray containsObject:[NSString stringWithFormat:@"%d", (i + 1)]]) {
			if ([_str length] == 0)
				[_str appendFormat:@"***"]	;
			else
				[_str appendFormat:@" ***"]	;	
		}
		else {
			if ([_str length] == 0)
				[_str appendFormat:@"%@",[wordsArray objectAtIndex:i]]	;
			else
				[_str appendFormat:@" %@",[wordsArray objectAtIndex:i]]	;	
		}
	}
	textBox.text = _str;
	NSString *obj = [NSString stringWithFormat:@"%@",[[[[words objectAtIndex:index] objectForKey:@"rusWord"] componentsSeparatedByString: @"^"] objectAtIndex:0]];
	[[words objectAtIndex:index] setValue:obj forKey:@"engWord"];
	[_str release];
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	[self.view setBackgroundColor:[UIColor blackColor]];
	return  !(toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [super dealloc];
}
@end
