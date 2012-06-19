//
//  AlertTableCell.m
//  iTeachWords
//
//  Created by admin on 31.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "AlertTableCell.h"
#import "WordTypes.h"
#import "RepeatModel.h"

@implementation AlertTableCell
@synthesize titleLbl;

- (void)awakeFromNib{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    self.titleLbl = nil;
    [rateView release];
    rateView = nil;
    [subTitleLbl release];
    [super dealloc];
}

- (void)setTheme:(WordTypes*)_wordTheme{
    if (_wordTheme) {
    [self setUpRightAlignedRateViewWith:_wordTheme];
        //        [self generateStatisticView];
        //        [statisticViewController generateStatisticByWords:_wordTheme.words];
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
    
    if (!rateView) {
        rateView = [[DYRateView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 160 - 10, 30, 160, 14)];
    }
    rateView.rate = (_repeatStatus==0)?_repeatStatus:_repeatStatus - 1;
    rateView.alignment = RateViewAlignmentRight;
    [self.contentView addSubview:rateView];
}
@end
