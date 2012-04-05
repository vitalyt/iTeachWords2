//
//  TableViewController.h
//  TweetBeacon
//
//  Created by Talisman on 28.07.09.
//  Copyright 2009 Halcyon Innovation, LLC. All rights reserved.
//
#import "BaseHelpViewController.h"

@interface TableViewController : BaseHelpViewController
<
	UITableViewDataSource,
	UITableViewDelegate
>
{
	UITableView *table;
	NSArray *data;
	NSInteger cellStyle;
	
    int                     limit;
    int                     offset;
}


@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) NSArray *data;

- (void)loadData;
- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath;
- (void) configureCell: (UITableViewCell*)theCell forRowAtIndexPath: (NSIndexPath*)indexPath;
- (id)cellBackgroundViewWithFrame:(CGRect)frame;

@end
