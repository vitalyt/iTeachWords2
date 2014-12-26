//
//  ThemesCell.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 27.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "ThemesCell.h"
#import "DetailStatisticViewController.h"

@implementation ThemesCell
@synthesize statisticViewController;
@synthesize nameLbl;
@synthesize subtitleLbl;

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

- (void) generateStatisticView{
    if(statisticViewController == nil){
        statisticViewController = [[DetailStatisticViewController alloc] initWithNibName:@"DetailStatisticViewController" bundle:nil];
        [self addSubview:statisticViewController.view];
        [statisticViewController.view setFrame:CGRectMake(78, 57, 165, 25)];
    }
}

- (void) removeStatisticView{
    if (statisticViewController) {
        [statisticViewController.view removeFromSuperview];
        self.statisticViewController = nil;
    }
}
@end
