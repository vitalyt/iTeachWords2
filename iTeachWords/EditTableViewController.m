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
			theCell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:@"default"] autorelease];
        }else{
            NSArray *items = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
            theCell = [items objectAtIndex:0];
        }
        indicator = [[[UIImageView alloc] initWithImage:notSelectedImg] autorelease];
        const NSInteger IMAGE_SIZE = 30;
        const NSInteger SIDE_PADDING = 5;
        
        indicator.tag = SELECTION_INDICATOR_TAG;
        indicator.frame = CGRectMake(-EDITING_HORIZONTAL_OFFSET + SIDE_PADDING, (0.5 * tableView.rowHeight) - (0.5 * IMAGE_SIZE), IMAGE_SIZE, IMAGE_SIZE);
        [theCell.contentView addSubview:indicator];
        theCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *bg = [[MenuView alloc] initWithFrame:theCell.frame];
        bg.backgroundColor = [UIColor clearColor]; // or any color
        theCell.backgroundView = bg;
        [bg release];
    }else {
        indicator = (UIImageView *)[theCell.contentView viewWithTag:SELECTION_INDICATOR_TAG];
	}
    
	[self configureCell:theCell forRowAtIndexPath:indexPath];
	return theCell;
}

@end
