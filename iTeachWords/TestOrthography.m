//
//  Test1.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/6/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "TestOrthography.h"
#import "Words.h"
#import "DetailStatisticModel.h"
#import "StatisticViewController.h"
#import "ExersiceBasicClass.h"

#define CURRENTWORD ((Words *)[words objectAtIndex:index])

@implementation TestOrthography



- (IBAction) help{
	textBox.text = CURRENTWORD.text;
}

- (IBAction) nextWord{
	if ([self test]) {
        statisticView.right++;
        statisticView.totalQuestions++;
//        [self playSoundWithIndex:index];
        index++;
		[self performSelector:@selector(createWord) withObject:nil afterDelay:1.5f];
	}
	else {
	}
    statisticView.total = [words count];
    statisticView.index++;
}
- (void) playSoundWithIndex:(int)_index{
    if (multiPlayer) {
        [multiPlayer closePlayer];
        [multiPlayer release];
    }
    NSArray *sounds = [[NSArray alloc] initWithObjects:[words objectAtIndex:_index], nil];
    multiPlayer = [[MultiPlayer alloc] initWithNibName:@"SimpleMultiPlayer" bundle:nil];
	multiPlayer.delegate = self;
	[multiPlayer openViewWithAnimation:self.view];
	[multiPlayer playList:sounds];
    [sounds release];
}


- (void)playerDidFinishPlayingList:(id)sender{
    [self createWord];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return  NO;
}

- (BOOL) test {
	if ([textBox.text isEqualToString:CURRENTWORD.text]) {
        [self checkingWord:CURRENTWORD success:YES];
        [self showTestMessageResultat:YES];
		return YES;
	}else{
        [self checkingWord:CURRENTWORD success:NO];
        [self showTestMessageResultat:NO];
    }
    if (index+1 >= [words count]) {
		[words addObject:CURRENTWORD];
    }else{
		[words insertObject:CURRENTWORD atIndex:index+2];
		[words addObject:CURRENTWORD];
    }
	return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    words = [[NSMutableArray alloc] initWithArray:self.data];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"?" style:UIBarButtonItemStyleBordered target:self action:@selector(help)] autorelease];
    [self createStatisticsView];
    statisticView.total = [words count];
	[self createWord];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (void) createWord{
    if ([multiPlayer isPlaying]) {
        return;
    }
    if (index >= [words count]) {
        [self back];
        return;
    }
    if(index < [words count]){
        lblWordRus.text = CURRENTWORD.translate; 
        textBox.text = @"";        
    }else {
        [self back];
    }
}

- (void)dealloc {
    [words release];
    [super dealloc];
}



@end
