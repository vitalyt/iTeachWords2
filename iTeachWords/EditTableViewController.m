//
//  EditTableViewController.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/20/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "EditTableViewController.h"
#import "MultiSelectTableViewCell.h"
#import "MenuView.h"

@implementation EditTableViewController

#define SELECTION_INDICATOR_TAG 54321
#define TEXT_LABEL_TAG 54322

- (UITableViewCell*) tableView: (UITableView*)tableView cellForRowAtIndexPath: (NSIndexPath*)indexPath {
    NSString *cellIdentifier = [self tableView:tableView cellIdentifierForRowAtIndexPath:indexPath];
    static UIImageView *indicator; 
    if (!isSelectedImg) {
        isSelectedImg = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/IsSelected.png", [[NSBundle mainBundle] bundlePath]]];
    }
    if (!notSelectedImg) {
        notSelectedImg = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/NotSelected.png", [[NSBundle mainBundle] bundlePath]]];
    }
    
    UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == theCell) {
		if (nil == cellIdentifier){
			theCell = [[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:@"default"];
        }else{
            NSArray *items = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            theCell = [items objectAtIndex:0];
        }
        indicator = [[UIImageView alloc] initWithImage:notSelectedImg];
        const NSInteger IMAGE_SIZE = 30;
        const NSInteger SIDE_PADDING = 5;
        
        indicator.tag = SELECTION_INDICATOR_TAG;
        indicator.frame = CGRectMake(-EDITING_HORIZONTAL_OFFSET + SIDE_PADDING, (0.5 * tableView.rowHeight) - (0.5 * IMAGE_SIZE), IMAGE_SIZE, IMAGE_SIZE);
        [theCell.contentView addSubview:indicator];
        theCell.selectionStyle = UITableViewCellSelectionStyleNone;
        theCell.backgroundView = [self cellBackgroundViewWithFrame:theCell.frame];
        theCell.selectedBackgroundView = [self cellSelectedBackgroundViewWithIndexPath:indexPath];
    }else {
        indicator = (UIImageView *)[theCell.contentView viewWithTag:SELECTION_INDICATOR_TAG];
	}
    
	[self configureCell:theCell forRowAtIndexPath:indexPath];
	return theCell;
}

- (id)cellSelectedBackgroundViewWithIndexPath:(NSIndexPath*)indexPath{
    OSDNUITableCellView *v = [[OSDNUITableCellView alloc] initWithRountRect:5];
    
    v.fillColor = [UIColor colorWithRed:0.25f green:0.47f blue:0.44f alpha:1.0f];
    v.borderColor = [UIColor darkGrayColor];
    [v setPositionCredentialsRow: indexPath.row count:[self tableView:table numberOfRowsInSection:indexPath.section]];
    return v;
}

@end
