//
//  RecognizerAlertTableCell.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 19.06.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "RecognizerAlertTableCell.h"

@implementation RecognizerAlertTableCell
@synthesize detailText;

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
    [detailText release];
    [super dealloc];
}
@end

