//
//  TableViewController.m
//  TweetBeacon
//
//  Created by Talisman on 28.07.09.
//  Copyright 2009 Halcyon Innovation, LLC. All rights reserved.
//

#import "TableViewController.h"
//#import "InputCell.h"
#import "MenuView.h"

@implementation TableViewController

@synthesize table;
@synthesize data;

#pragma mark -
#pragma mark NSObject
- (void) dealloc
{
	[data release];
	[table release];
	[super dealloc];
}

#pragma mark -
#pragma mark UIViewController
- (void) viewDidUnload
{
	self.table = nil;
	[super viewDidUnload];
}

- (void) didReceiveMemoryWarning
{
	//self.data = nil;
	[super didReceiveMemoryWarning];
}

-(void)viewDidLoad {
	[super viewDidLoad];
	cellStyle = UITableViewCellStyleDefault;
    [table setBackgroundColor:[UIColor clearColor]];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	//[table setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"grnd.png"]]];
//    UIView *bg = [[MenuView alloc] initWithFrame:table.frame];
//    bg.backgroundColor = [UIColor groupTableViewBackgroundColor]; // or any color
//    table.backgroundView = bg;
//    [bg release];
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:YES];
	[self loadData];
	[table reloadData];
}

-(void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView: (UITableView*)tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView*)tableView numberOfRowsInSection: (NSInteger)section {
    return data ? [data count] : 0;
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
        theCell.backgroundView = [self cellBackgroundViewWithFrame:theCell.frame];
        theCell.selectedBackgroundView = [self cellSelectedBackgroundViewWithIndexPath:indexPath];
	}
	[self configureCell:theCell forRowAtIndexPath:indexPath];
	return theCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath {
	return nil;
}

- (void) configureCell: (UITableViewCell*)theCell forRowAtIndexPath: (NSIndexPath*)indexPath {
	// Overrided by subclasses
}

- (void)loadData {
	// Overrided by subclasses
}

-(void)reload {
	[self loadData];
	[table reloadData];
}

- (id)cellBackgroundViewWithFrame:(CGRect)frame{
    UIView *bg = [[MenuView alloc] initWithFrame:frame];
    bg.backgroundColor = [UIColor clearColor]; // or any color
    return [bg autorelease];
}

- (id)cellSelectedBackgroundViewWithIndexPath:(NSIndexPath*)indexPath{
    OSDNUITableCellView *v = [[[OSDNUITableCellView alloc] initWithRountRect:5] autorelease];
//    70.0f/255.0f, 70.0f/255.0f, 70.0f/255.0f, 1.0f
    v.fillColor = [UIColor colorWithRed:22/255.0f green:22/255.0f blue:22/255.0f alpha:.5f];
    v.borderColor = [UIColor darkGrayColor];
    [v setPositionCredentialsRow: indexPath.row count:[self tableView:table numberOfRowsInSection:indexPath.section]];
    return v;
}



@end
