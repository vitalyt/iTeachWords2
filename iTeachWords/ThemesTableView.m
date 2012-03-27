//
//  ThemesTableView.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 27.03.12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "ThemesTableView.h"
#import "WordTypes.h"
#import "ThemesCell.h"
#import "Words.h"
#import "Statistic.h"


@interface ThemesTableView ()

@end

@implementation ThemesTableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData { 
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSError *error;
    NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"WordTypes" inManagedObjectContext:[iTeachWordsAppDelegate sharedContext]]];
    //    [request setFetchLimit:limit];  
    //    [request setFetchOffset:0];
    //[request setFetchBatchSize:10];
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"name",@"createDate",@"descriptionStr", nil]];
    
	NSSortDescriptor *createDate = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:YES 
                                                          selector:@selector(caseInsensitiveCompare:)];
    
    NSArray *context = [[[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:createDate, nil]];
    self.data = [NSMutableArray arrayWithArray:context];
	[table reloadData];
    [pool release];
}

#pragma mark search bar funktions
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath {
    return @"ThemesCell";
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

#pragma mark - Table view delegate

- (void) configureCell:(UITableViewCell *)cell forRowAtIndexPath: (NSIndexPath*)indexPath { 
    if ([cell isKindOfClass:[ThemesCell class]]) {
        WordTypes *wordTypes = [data objectAtIndex:indexPath.row];
        
        ThemesCell *_cell = (ThemesCell*)cell;
        [_cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
//        [_cell setEditingAccessoryType:(isEditingMode)?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone];
        [_cell.textLabel setFont:FONT_TEXT];
        [_cell.detailTextLabel setFont:FONT_TEXT];
        _cell.nameLbl.text = wordTypes.name;
        _cell.subtitleLbl.text = [wordTypes.createDate stringWithFormat:@"dd.MM.YYYY  HH:mm"];
        [_cell generateStatisticView];
        [_cell.statisticViewController performSelector:@selector(generateStatisticByWords:) withObject:wordTypes.words afterDelay:.1];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
}

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)edit:(id)sender {
    isEditingMode = !isEditingMode;
    [table setEditing:isEditingMode];
    [table reloadData];
}
@end
