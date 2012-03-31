//
//  AlertTableCell.m
//  iTeachWords
//
//  Created by admin on 31.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "AlertTableCell.h"

@implementation AlertTableCell
@synthesize titleLbl;
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
    [super dealloc];
}
@end
