//
//  Test15.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/22/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "Test7.h"
#import "MyData.h"

@implementation Test7

@synthesize optionArray,wordsArray,optionIndexArray;

- (IBAction) help{
	for(int i=0;i<[optionIndexArray count];i++){
		int indexOpt = [[[optionIndexArray objectAtIndex:i] objectForKey:@"indexOpt"] intValue];
		int indexWords = [[[optionIndexArray objectAtIndex:i] objectForKey:@"indexWords"] intValue];
		[self.wordsArray replaceObjectAtIndex:indexWords withObject:[optionArray objectAtIndex:indexOpt-1]];
		[self loadStrWithArray];
		//[self nextWord:indexOpt+1];
		return;
	}
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	optionArray = [[NSMutableArray alloc] initWithArray:(NSMutableArray *)[MyData getOptionWithString:[[words objectAtIndex:index] objectForKey:@"rusWord"]]];
}

- (IBAction) nextWord:(int)row{
	if ([self test:row]) {
        statisticView.right++;
		if (([optionIndexArray count] == 0)&&(index+1 >= [words count])) {
			[self back];
			return;
		}
		if ([optionIndexArray count] == 0) {
			index++;
            statisticView.totalQuestions++;
			[self createWord];	
		}
	}
    statisticView.index++;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self nextWord];
	return YES;
}

- (BOOL) test:(int)_tag {
	for(int i=0;i<[optionIndexArray count];i++){
		int indexOpt = [[[optionIndexArray objectAtIndex:i] objectForKey:@"indexOpt"] intValue];
		if (indexOpt == _tag) {
			int indexWords = [[[optionIndexArray objectAtIndex:i] objectForKey:@"indexWords"] intValue];
			[self.wordsArray replaceObjectAtIndex:indexWords withObject:[optionArray objectAtIndex:indexOpt-1]];
			[self loadStrWithArray];
			[optionIndexArray removeObjectAtIndex:i];
			return YES;
		}
	}
	return NO;
}
- (void) loadStrWithArray{
	NSMutableString *str = [[[NSMutableString alloc] init] autorelease];
	for (int i = 0; i<[wordsArray count]; i++) {
		[str appendFormat:@" %@",[wordsArray objectAtIndex:i]];
	}
	lblWordRus.text = str;
}
- (void) createWord{
	//[self playWord:[NSString stringWithFormat:@"R%d",index+1]];
	if (optionIndexArray == nil) {
		optionIndexArray = [[NSMutableArray alloc] init];
	}
	if (wordsArray == nil) {
		wordsArray = [[NSMutableArray alloc] init];
	}
	self.wordsArray = (NSMutableArray *)[MyData getWordWithString:[[words objectAtIndex:index] objectForKey:@"engWord"]]; 
	
	NSLog(@"%@",wordsArray);
	for (int i = 0; i<[wordsArray count]; i++) {
		NSString *_word = [wordsArray objectAtIndex:i];
		if (([_word length])&&[_word characterAtIndex:0] == '%') {
			NSString *strIndex = [[_word substringFromIndex: 1] substringToIndex: [_word length]-1];
			NSLog(@"%@",strIndex);
			NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:strIndex,@"indexOpt",[NSString stringWithFormat:@"%d",i],@"indexWords",nil];
			[optionIndexArray addObject:dict];
			[dict release];
			[wordsArray replaceObjectAtIndex:i withObject:@" ***"];
			continue;
		}
	}
	[self loadStrWithArray];
	if (index == 0) {
		self.lblWordEng.text = [[[[words objectAtIndex:index] objectForKey:@"rusWord"] componentsSeparatedByString: @"^"] objectAtIndex:0];
		return;
	}
	self.lblWordEng.text = [[words objectAtIndex:index] objectForKey:@"rusWord"];
	
}


-(int) randomFrom:(int)from to:(int)to{
	srandom((unsigned)(mach_absolute_time() & 0xFFFFFFFF));
    int randomValue = 0;
    if ((to - from) != 0) {
        randomValue = from+ (random() % (to - from));
    }
	return randomValue;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [optionArray count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.text =  [optionArray objectAtIndex:indexPath.row];
    // Configure the cell...
   
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
	[self nextWord:indexPath.row+1];
	
}

- (void)dealloc {
	[optionArray release];
	[wordsArray release];
	[optionIndexArray release];
    [super dealloc];
}

@end
