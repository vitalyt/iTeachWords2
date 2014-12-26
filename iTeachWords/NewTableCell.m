//
//  NewTableCell.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/10/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "NewTableCell.h"


@implementation NewTableCell
@synthesize textLabel,detailLabel;

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

- (void)layoutSubviews
{
	[super layoutSubviews];
	if (((UITableView *)self.superview).isEditing)
	{
		CGRect contentFrame = detailLabel.frame;
		contentFrame.origin.x = 247 - EDITING_HORIZONTAL_OFFSET;
		detailLabel.frame = contentFrame;
	}
	else
	{
		CGRect contentFrame = detailLabel.frame;
		contentFrame.origin.x = 247;
		detailLabel.frame = contentFrame;
	}
}

- (NSString *) reuseIdentifier {
	return @"NewTableCell";
}

@end
