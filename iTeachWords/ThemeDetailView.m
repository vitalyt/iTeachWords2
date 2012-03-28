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

- (void)dealloc {
    [nameLbl release];
    [createDateLdl release];
    [changeDateLbl release];
    [wordsCountLbl release];
    [statisticViewController.view removeFromSuperview];
    [statisticViewController release];
    statisticViewController = nil;
    [super dealloc];
}

- (void)setTheme:(WordTypes*)_wordTheme{
    if (_wordTheme) {
        nameLbl.text = _wordTheme.name;
        createDateLdl.text = [_wordTheme.createDate stringWithFormat:@"dd.MM.YYYY"];
        changeDateLbl.text = [_wordTheme.changeDate stringWithFormat:@"dd.MM.YYYY"];
        wordsCountLbl.text = [NSString stringWithFormat:@"%d",[_wordTheme.words count]];
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
