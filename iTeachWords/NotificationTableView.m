//
//  NotificationTableView.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/16/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "NotificationTableView.h"
#import "SwitchingCell.h"
#import "DetailViewController.h"
#import "RepeatModel.h"
#import "CustomAlertView.h"

#define FONT_OF_HEAD_LABEL [UIFont fontWithName:@"Helvetica-Bold" size:16]

@implementation NotificationTableView

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
}

#pragma mark loading funktions

- (void) loadData{    
    titles = [[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"The repeat notification system", @""), nil];
    NSArray *elements = [[NSArray alloc] initWithObjects:NSLocalizedString(@"20 min",@""),NSLocalizedString(@"1 day",@""),NSLocalizedString(@"1 month",@""),NSLocalizedString(@"3 month",@""), nil];
    self.data = [NSArray arrayWithObjects:elements, nil];
    [elements release];
    for (int i=0;i<[elements count];i++){
        NSString *_key = [self keyForIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        bool boolValue = ([[NSUserDefaults standardUserDefaults] objectForKey:_key])?[[NSUserDefaults standardUserDefaults] boolForKey:_key]:YES;
        [self.values setObject:[NSNumber numberWithBool:boolValue] forKey:_key];
        [[NSUserDefaults standardUserDefaults] setBool:boolValue forKey:_key];
    }
    [self.table reloadData];
}

- (NSString*)keyForIndexPath:(NSIndexPath*)indexPath{
    NSString *key = @"";
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                key = @"repeatTimeIntervalAvailable1";
                break;
            case 1:
                key = @"repeatTimeIntervalAvailable2";
                break;
            case 2:
                key = @"repeatTimeIntervalAvailable3";
                break;
            case 3:
                key = @"repeatTimeIntervalAvailable4";
                break;
                
            default:
                break;
        }
    }
    return key;
}

#pragma mark table view delegate
- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath {
    return @"SwitchingCell";   
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView: (UITableView*)tableView {
    return [titles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        NSString *key = @"isRepeatOptionOn";
        bool _value;
        if([[NSUserDefaults standardUserDefaults] objectForKey:key]){
            _value = [[NSUserDefaults standardUserDefaults] boolForKey:key];
        }else{
            _value = YES;
            [[NSUserDefaults standardUserDefaults] setBool:_value forKey:key];
        }
        if (!_value) {
                return 0;
        }
    }
    return [[data objectAtIndex:section] count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [titles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    if (section == 1) {
    UIView *v=[[[UIView alloc] init] autorelease];
    v.backgroundColor = [UIColor clearColor];
    NSString *tite = [titles objectAtIndex:section];
    float width ;
    width = tableView.frame.size.width - 40 - 79;

    CGSize detailSize = [tite sizeWithFont:FONT_OF_HEAD_LABEL constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *header = [[UILabel alloc] initWithFrame: CGRectMake(20, 10.0, width, detailSize.height)];
    header.numberOfLines = 3;
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor whiteColor];
    header.font = FONT_OF_HEAD_LABEL; 
    header.text = tite;
    
    if (!onOffSwitcher) {
        onOffSwitcher = [[UISwitch alloc] initWithFrame: CGRectZero];
        [onOffSwitcher addTarget: self action: @selector(changedNotification) forControlEvents: UIControlEventValueChanged];
        [onOffSwitcher setOn:IS_REPEAT_OPTION_ON];
    }
    
    CGRect SwicherFrame = CGRectMake( tableView.frame.size.width - 30 - 79, 10+header.frame.size.height/2-14, 79, 27);
    [onOffSwitcher setFrame:SwicherFrame];
    
    // Set the desired frame location of onoff here
    [v addSubview: onOffSwitcher];
    
    [v addSubview:header];
    [header release];
    return v;
    //    }
    //    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	NSString *tite = [titles objectAtIndex:section];
    float width = tableView.frame.size.width - 40 - 79;

	CGSize detailSize = [tite sizeWithFont:FONT_OF_HEAD_LABEL constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
	return detailSize.height + 15;//+titleSize.height;
}

- (void) configureCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    NSString *titleText = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if([cell isKindOfClass:[SwitchingCell class]]){
        SwitchingCell* _cell = (SwitchingCell *)cell; 
        NSString *key = [self keyForIndexPath:indexPath];
        bool _value = [[self.values objectForKey:key] boolValue];
        _cell.titleLabel.text = titleText;
        [_cell setDelegate:self];
        [_cell.switcher setOn:_value];
        //[self.values setValue:[NSNumber numberWithInt:value] forKey:key];
    }else if([cell isMemberOfClass:[UITableViewCell class]]){
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = titleText;
    }
}

-(void)cellChanged:(UITableViewCell *)cell {
	NSIndexPath *indexPath = [table indexPathForCell:cell];
	if (nil == indexPath) {
		return;
	}
    NSString *key;
    key = [self keyForIndexPath:indexPath];
    if([cell isKindOfClass:[SwitchingCell class]]){
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        SwitchingCell* _cell = (SwitchingCell *)cell; 
        _cell.titleLabel.text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [_cell setDelegate:self];
        bool _value = _cell.switcher.on;
        [values setObject:[NSNumber numberWithBool:_value] forKey:key];
        [[NSUserDefaults standardUserDefaults] setBool:_value forKey:key]; 
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[iTeachWordsAppDelegate sharedDelegate] activateNotification];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}   

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)changedNotification{
    NSString *key = @"isRepeatOptionOn";
    bool _value = onOffSwitcher.on;
    if (!_value) {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure?", @"") message:NSLocalizedString(@"The closes of this funtionality is not recomended", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Show detail info", @""), nil];
        [alert show];
        [alert autorelease];
    }
    [[NSUserDefaults standardUserDefaults] setBool:_value forKey:key]; 
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[iTeachWordsAppDelegate sharedDelegate] activateNotification];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [table reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 1:
            [self showInfoView];
            break;
            
        default:
            break;
    }
}

- (void)showInfoView{
    DetailViewController *infoView = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController presentModalViewController:infoView animated:YES];
    [infoView setUrl:NSLocalizedString(@"http://en.wikipedia.org/wiki/Forgetting_curve", @"")];
    //    [self.navigationController pushViewController:infoView animated:YES];
    [infoView release];
}

- (void)dealloc {
    [onOffSwitcher release];
    [super dealloc];
}
@end
