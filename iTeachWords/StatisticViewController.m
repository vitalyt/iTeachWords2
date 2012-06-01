//
//  StatisticViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/2/10.
//  Copyright (c) 2010 OSDN. All rights reserved.
//

#import "StatisticViewController.h"


@implementation StatisticViewController

@synthesize right,total,index,totalQuestions;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
        total = 0;
        index = 0;
        right = 0;
        totalQuestions = 0;
        //[self addObserver:self forKeyPath:@"total" options:NSKeyValueObservingOptionNew context:@selector(reloadStatisticView)];
        [self addObserver:self forKeyPath:@"index" options:NSKeyValueObservingOptionNew context:@selector(reloadStatisticView)];
       // [self addObserver:self forKeyPath:@"right" options:NSKeyValueObservingOptionNew context:@selector(reloadStatisticView)];
        [self addObserver:self forKeyPath:@"totalQuestions" options:NSKeyValueObservingOptionNew context:@selector(reloadStatisticView)];
    }
    return self;
}

- (void) viewDidLoad{
    [super viewDidLoad];
    [totalLbl setText:NSLocalizedString(@"total", @"")];
    [progressLbl setText:NSLocalizedString(@"progress", @"")];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    SEL selector = (SEL)context;
    [self performSelector:selector];
}

- (void) checking:(BOOL)_valid{
    if(_valid){
        right++;
    }
    index++;
    [self reloadStatisticView];
}

- (void) reloadStatisticView {
    if (total > 0) {
        progressTotal.progress = (float)(1.0 - (float)(total - totalQuestions)/total);
    }
    if (index > 0) {
        progress.progress = (float)(1.0 - (float)(index - right)/index);
    }
    progressTotalLabel.text = [NSString stringWithFormat:@"%d%%",(int)(progressTotal.progress*100)];
    progressLabel.text = [NSString stringWithFormat:@"%d%%",(int)(progress.progress*100)];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [progressLbl release];
    [totalLbl release];
    [super dealloc];
}


- (void)viewDidUnload {
    [progressLbl release];
    progressLbl = nil;
    [totalLbl release];
    totalLbl = nil;
    [super viewDidUnload];
}
@end
