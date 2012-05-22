//
//  TestGameController.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/9/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "TestGameController.h"
#import "StatisticViewController.h"

@implementation TestGameController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                                   initWithTitle:@"?" style:UIBarButtonItemStyleBordered target:self action:@selector(help)] autorelease];
    }
    return self;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {	
	return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[textBox setClearButtonMode:UITextFieldViewModeWhileEditing];
    [textBox setOpaque:YES];	
    [textBox addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:textBox];
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(capitalizeText:) name:@"UITextFieldTextDidChangeNotification" object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(capitalizeText:) name:@"UITextViewTextDidChangeNotification" object:nil];
    [self createStatisticsView];
    statisticView.total = [data count];
}

- (void)viewDidUnload{
    [super viewDidUnload];
}

- (void) createWord{

	if(index<[self.data count]){
		lblWordEng.text = @"";
		word = [self.data objectAtIndex:index];
		const char *cWord = (const char *)[word.text UTF8String];
		for (int i=0; i<[word.text length]; i++) {
			if (cWord[i] == ' ') 
				lblWordEng.text = [NSString stringWithFormat:@"%@ ",lblWordEng.text];
			else 
				lblWordEng.text = [NSString stringWithFormat:@"%@*",lblWordEng.text];
		}
		lblWordRus.text = word.translate;
	}else{
        [self back];
    }
}

- (void) setText:(NSString *)str{
	textBox.text = str;
}

- (NSString *) QQQ:(NSString *) _word charIn:(const char)ch{
	char *cWord = (char *)[_word UTF8String];
	NSString *engWord = [word.text lowercaseString];
	BOOL flg = NO;
	for (int i=0; i<[_word length]; i++) {
		if (([engWord characterAtIndex:i] == (int)ch)) {
			cWord[i] = (int)ch;
			flg = YES;
		}
	}
	if (!flg) {
        [self checkingWord:word success:NO];
        [self showTestMessageResultat:NO];
		[self.data addObject:word];
        statisticView.total = [data count];
        statisticView.index++;
	}
	_word = [NSString stringWithCString:cWord encoding:NSUTF8StringEncoding];	
	return _word;
}

-(void) capitalizeText: (NSNotification*)notification{
	[[NSNotificationCenter defaultCenter]removeObserver: self name: [notification name] object: nil];
	UITextField *textItem = [notification object]; // textField or textView
	NSString *text = [textItem text];
	const char *ch = [[text lowercaseString] UTF8String];
	lblWordEng.text = [self QQQ:[lblWordEng.text lowercaseString] charIn:ch[0]];
	[textItem setText: @""];
	[self nextWord];
	[[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(capitalizeText:) name:[notification name] object:nil];
}

- (void) nextWord{
	const char *cWord = (char *)[lblWordEng.text UTF8String];
	BOOL flg = NO;
	for (int i = 0; i < [lblWordEng.text length]; i++) {
		if (cWord[i] == '*') {
			flg = YES;
		}
	}
	if (!flg) {
        [self checkingWord:word success:YES];
        statisticView.right++;
        statisticView.totalQuestions++;
        statisticView.index++;    
        [self showTestMessageResultat:YES];
//        [self playSoundWithIndex:index];
		index++;
        if ([multiPlayer isPlaying]) {
            return;
        }
        else {
            [self performSelector:@selector(createWord) withObject:nil afterDelay:1.5f];
        }
	}
}

- (IBAction) help{
	lblWordEng.text = word.text;
	[self.data addObject:word];
}

- (void)onHideKeyboard:(id)notification
{
	// то что ты хочешь сделать когда спрячется клавикатура
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"textFieldDidEndEditing called!");
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter]removeObserver: self name: @"UITextFieldTextDidChangeNotification" object: nil];
	[[NSNotificationCenter defaultCenter]removeObserver: self name: @"UITextViewTextDidChangeNotification" object: nil];
    [super dealloc];
}


@end
