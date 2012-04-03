//
//  ThemeDetailView.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 28.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "ThemeDetailView.h"
#import "DetailStatisticViewController.h"
#import "WordTypes.h"
#import "Words.h"

@interface ThemeDetailView ()

@end

@implementation ThemeDetailView
@synthesize name,createDate,changeDate,wordsCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fillData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [nameLbl release];
    nameLbl = nil;
    [createDateLdl release];
    createDateLdl = nil;
    [changeDateLbl release];
    changeDateLbl = nil;
    [wordsCountLbl release];
    wordsCountLbl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)fillData{
    nameLbl.text = name;
    createDateLdl.text = createDate;
    changeDateLbl.text = changeDate;
    wordsCountLbl.text = wordsCount;
}

- (void)dealloc {
    [nameLbl release];
    [createDateLdl release];
    [changeDateLbl release];
    [wordsCountLbl release];
    [name release];
    [createDate release];
    [changeDate release];
    [wordsCount release];
    [statisticViewController.view removeFromSuperview];
    [statisticViewController release];
    statisticViewController = nil;
    [super dealloc];
}

- (void)setTheme:(WordTypes*)_wordTheme{
    if (_wordTheme) {
        self.name = _wordTheme.name;
        self.createDate = [_wordTheme.createDate stringWithFormat:@"dd.MM.YYYY"];
        self.changeDate = [_wordTheme.changeDate stringWithFormat:@"dd.MM.YYYY"];
        self.wordsCount = [NSString stringWithFormat:@"%d",[_wordTheme.words count]];
        [self fillData];
//        [self generateStatisticView];
//        [statisticViewController generateStatisticByWords:_wordTheme.words];
    }
}

- (void) generateStatisticView{
    if(statisticViewController == nil){
        statisticViewController = [[DetailStatisticViewController alloc] initWithNibName:@"DetailStatisticViewController" bundle:nil];
        [self.view addSubview:statisticViewController.view];
        [statisticViewController.view setFrame:CGRectMake(20, 110, 280, 25)];
    }
}

@end
