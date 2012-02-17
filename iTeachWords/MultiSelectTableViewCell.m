//
//  MultiSelectTableViewCell.m
//  CortexMobile
//
//  Created by Matt Gallagher on 11/01/09.
//  Copyright 2008 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import "MultiSelectTableViewCell.h"

@implementation MultiSelectTableViewCell

const NSInteger EDITING_HORIZONTAL_OFFSET = 35;
@synthesize selected;

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
	[self setNeedsLayout];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	if (((UITableView *)self.superview).isEditing)
	{
		CGRect contentFrame = self.contentView.frame;
		contentFrame.origin.x = EDITING_HORIZONTAL_OFFSET;
		self.contentView.frame = contentFrame;
	}
	else
	{
		CGRect contentFrame = self.contentView.frame;
		contentFrame.origin.x = 0;
		self.contentView.frame = contentFrame;
	}
}

@end
