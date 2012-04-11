//
//  InputTableController.m
//  SOS
//
//  Created by Yalantis on 17.06.10.
//  Copyright 2010 Yalantis Software. All rights reserved.
//

#import "InputTableController.h"
#import "TextFieldCell.h"
#import "TextFieldCell.h"

@implementation InputTableController

@synthesize values,titles;
@synthesize responder;

- (void) dealloc
{
	[responder release];
	[self.values release];
    [titles release];
	[super dealloc];
}

#pragma mark -
#pragma mark InputCellDelegate

-(void)cellDidBeginEditing:(TextFieldCell *)cell {
	self.responder = [cell textField];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationDelegate:self];
	
	CGRect rect = cell.frame;
	if (rect.origin.y > 100.0f) {
		rect.origin.y -= 100.0f;
		[table setContentOffset:rect.origin];
	}
	
	UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, 280.0f, 0.0f);
	[table setContentInset:insets];
	[UIView commitAnimations];
	
}

- (UITableViewCell*) tableView: (UITableView*)tableView cellForRowAtIndexPath: (NSIndexPath*)indexPath {
    NSString *cellIdentifier = [self tableView:tableView cellIdentifierForRowAtIndexPath:indexPath];
    
    UITableViewCell *theCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == theCell) {
		if (nil == cellIdentifier)
			theCell = [[[UITableViewCell alloc] initWithStyle:cellStyle reuseIdentifier:@"default"] autorelease];
		else {
			NSArray *items = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
			theCell = [items objectAtIndex:0];
		}
	}
	[self configureCell:theCell forRowAtIndexPath:indexPath];
    theCell.selectedBackgroundView = [self cellSelectedBackgroundViewWithIndexPath:indexPath];
	return theCell;
}

- (id)cellSelectedBackgroundViewWithIndexPath:(NSIndexPath*)indexPath{
    OSDNUITableCellView *v = [[[OSDNUITableCellView alloc] init] autorelease];
    
    v.fillColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:.75f];
    v.borderColor = [UIColor darkGrayColor];
    [v setPositionCredentialsRow: indexPath.row count:[self tableView:table numberOfRowsInSection:indexPath.section]];
    return v;
}

-(void)cellDidEndEditing:(UITableViewCell *)cell {
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDuration:0.2f];
	[UIView setAnimationDelegate:self];
	[table setContentInset:UIEdgeInsetsZero];
	[UIView commitAnimations];
}

- (NSString *)getKeyByIndex:(NSIndexPath *)indexPath{
    NSString *key = @"";
    return key;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.values) {
        self.values = [NSMutableDictionary dictionary];
    }
    if (self.titles) {
        self.titles = [NSArray array];
    }
    // Do any additional setup after loading the view from its nib.
}

@end
