    //
//  TestControllerProtocol.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/21/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "TestControllerProtocol.h"
#import "StatisticViewController.h"
#import "DetailStatisticModel.h"
#import "MyPlayer.h"

@implementation TestControllerProtocol
@synthesize textBox;
@synthesize words;
@synthesize lblWordEng,lblWordRus;
@synthesize progress,progressTotal;
@synthesize lessonName,exerciseIndex;
@synthesize statisticView;


- (IBAction) back{
    [self closePlayer];
	/*if (index > 0) {
		[self saveProgress];
	}*/
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) help{
	textBox.text = [[words objectAtIndex:index] objectForKey:@"engWord"];
	
	//[words addObject:word];
}

- (void) saveProgress
{
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]];
    path = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"Progress"]  ];
	NSString *lessKey = [NSString stringWithFormat:@"%@",lessonName];
	NSString *exerKey = [NSString stringWithFormat:@"%d",exerciseIndex];
	NSNumber *num = [[NSNumber alloc] initWithFloat:(float)(100.0/statisticView.index)*statisticView.right];
	
	NSMutableDictionary *lesson = nil;
	NSMutableDictionary *progressArray = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	if (progressArray == nil) {
		progressArray = [[NSMutableDictionary alloc] init];
	}
	else {
		lesson = [progressArray objectForKey:lessKey];
	}
	
	if (lesson == nil) {
		lesson = [[NSMutableDictionary alloc] init];
	}
	[lesson setObject:num  forKey:exerKey];
	
	[progressArray setObject:lesson forKey:lessKey];
	[progressArray writeToFile:path atomically:YES];
}

- (IBAction) nextWord{
	if (index+1 >= [words count]) {
		[self back];
		return;
	}
	if ([self test]) {
		statisticView.right++;
		index++;
		[self createWord];
	}
	else {
		
		[words addObject:[words objectAtIndex:index]];
	}
	//statisticView.index;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self nextWord];
	return YES;
}

- (BOOL) test {
	//NSLog(@"<%@==%@>",[[words objectAtIndex:index] objectForKey:@"engWord"],textBox.text);
	if ([[[words objectAtIndex:index] objectForKey:@"engWord"] isEqualToString:textBox.text]) {
		return YES;
	}
	return NO;
}

- (void) createWord{
	lblWordRus.text = [[words objectAtIndex:index] objectForKey:@"rusWord"];
	textBox.text = @"";
}

//- (void) playWord:(NSString *)_name{
//	if (myPlayer == nil) {
//		myPlayer = [[MyPlayer alloc] initWithNibName:@"MyPlayer" bundle:nil];
//	}
//	[myPlayer setDelegate:self path:@""];
//	NSMutableArray *_array = [[NSMutableArray alloc] init];
//	
//	NSString *_path = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]];
//	_path = [_path stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@/%d/",lessonName,exerciseIndex]];
//	
//	if (index == 0) {
//		NSString *compres = [NSString stringWithFormat:@"%@/COMEXERS.WAV",_path];
//		[_array addObject:compres];	
//	}
//	NSString *wordNama = [NSString stringWithFormat:@"%@/%@.WAV",_path,_name];
//	[_array addObject:wordNama];	
//	
//	if ([_array count]>0) {
//		[myPlayer openViewWithAnimation:self.view];
//		[myPlayer setDelegate:self path:@""];
//		myPlayer.arrayPath = _array;
//		[myPlayer startPlay];
//	}
//	[_array release];
//}

- (void) soundDidPlaying{
	[self closePlayer ];
}
- (void) closePlayer{
	[myPlayer closePlayer];
	//[myPlayer release];
	//[myPlayer release];
	myPlayer = nil;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(back)] autorelease];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"?" style:UIBarButtonItemStyleDone target:self action:@selector(help)];
    statisticView = [[StatisticViewController alloc] initWithNibName:@"StatisticViewController" bundle:NULL];
    statisticView.total = [words count];
    self.navigationItem.titleView = statisticView.view;
	[self createWord];
}

@end
