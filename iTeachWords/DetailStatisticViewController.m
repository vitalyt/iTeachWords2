//
//  DetailStatisticViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/28/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "DetailStatisticViewController.h"
#import "Words.h"
#import "Statistic.h"

#define IS_STATISTIC_AVALABLE (word && [[word.statistics allObjects] count]>0)?YES:NO

@implementation DetailStatisticViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    SEL selector = (SEL)context;
    [self performSelector:selector];
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadStatisticView];
}

- (Statistic *) getStatisticByWord:(Words *)word{
    return nil;
}

- (void) reloadStatisticView{
    if (IS_STATISTIC_AVALABLE) {
        Statistic *statistic = [[word.statistics allObjects] objectAtIndex:0];
        int requestCount = [statistic.requestCount intValue];
        int successfulCount = [statistic.successfulCount intValue];
        totalLbl.text = [NSString stringWithFormat:@"%d",requestCount];
        successLbl.text = [NSString stringWithFormat:@"%d",successfulCount];
        if (index > 0) {
            progress.progress = (float)(1.0 - (float)(requestCount - successfulCount)/requestCount);
        }
    }else{
        totalLbl.text = @"0";
        successLbl.text = @"0";
        progress.progress = 0.0;
    }
    [progressLabel setText:[NSString stringWithFormat:@"%d%%",(int)(progress.progress*100)]];
}

- (void) generateStatisticByWords:(NSSet *)words{
    float _progress = 0.0;
    for (Words *_word in words) {
        if ([[_word.statistics allObjects] count] == 0) {
            continue;
        }
        Statistic *statistic = [[_word.statistics allObjects] objectAtIndex:0];
        int requestCount = [statistic.requestCount intValue];
        int successfulCount = [statistic.successfulCount intValue];
        _progress += (float)(1.0 - (float)(requestCount - successfulCount)/requestCount);
    }
    progress.progress = _progress/[words count];
    progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(progress.progress*100)];
}

- (void) setWord:(Words *)_word{
    if (word == _word) {
        [self reloadStatisticView];
        return;
    }
    if (word) {
        [word release];
    }
    word = [_word retain];
    [self reloadStatisticView];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [progressLbl setText:NSLocalizedString(@"progress", @"")];
}

- (void)dealloc
{
    if (word) {
        [word release];
    }
    
    [progressLbl release];
    [super dealloc];
}

- (void)viewDidUnload {
    [successLbl release];
    [totalLbl release];
    [progressLbl release];
    progressLbl = nil;
    [super viewDidUnload];
}
@end
