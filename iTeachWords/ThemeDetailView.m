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
#import "RepeatModel.h"

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

- (void)setTheme:(WordTypes*)_wordTheme{
    if (_wordTheme) {
        self.name = _wordTheme.name;
        self.createDate = [_wordTheme.createDate stringWithFormat:@"dd.MM.YYYY"];
        self.changeDate = [_wordTheme.changeDate stringWithFormat:@"dd.MM.YYYY"];
        self.wordsCount = [NSString stringWithFormat:@"%d",[_wordTheme.words count]];
        [self fillData];
        
        if (IS_REPEAT_OPTION_ON) {
            [self setUpRightAlignedRateViewWith:_wordTheme];
        }
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


- (void)setUpRightAlignedRateViewWith:(WordTypes*)_wordTheme {
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 220, 120, 20)];
//    label.text = @"Right aligned:";
//    [self.view addSubview:label];
//    [label release];
    
    NSArray *_statisticsLearningArray = [RepeatModel loadAllStatisticsLearningWithWordType:_wordTheme];
    int intervalToNexLearning = [RepeatModel getTimeIntervalToNexLearning:_statisticsLearningArray];
    int _repeatStatus = [RepeatModel getRepeatStatusByIntervalSeconds:intervalToNexLearning];
    
    DYRateView *rateView = [[DYRateView alloc] initWithFrame:CGRectMake(45, 30, 160, 14)];
    rateView.rate = (_repeatStatus==0)?_repeatStatus:_repeatStatus - 1;
    rateView.alignment = RateViewAlignmentRight;
    [self.view addSubview:rateView];
}

@end
