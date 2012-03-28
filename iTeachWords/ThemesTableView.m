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
#import "ThemeEditingViewController.h"

@interface ThemesTableView ()
@end

@implementation ThemesTableView
@synthesize delegate;

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
    [self createNavigationButtons];
    // Do any additional setup after loading the view from its nib.
}

- (void)createNavigationButtons{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit:)] autorelease];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(back:)] autorelease];
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
    
	NSSortDescriptor *createDate = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
    
    NSArray *context = [[[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:createDate, nil]];
    if (!content) {
        content = [[NSMutableArray alloc] initWithCapacity:[context count]];
    }
    [content release];
    content = [[NSMutableArray arrayWithArray:context] retain];
//    self.data = [NSMutableArray arrayWithArray:context];
    [pool release];
}

#pragma mark search bar funktions
- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [content count];
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
        WordTypes *wordTypes = [content objectAtIndex:indexPath.row];
        
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerDone:)]) {
		[self.delegate pickerDone:[content objectAtIndex:indexPath.row]];
	}
    [self performSelector:@selector(back:) withObject:nil afterDelay:.3];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self showThemeEditingView];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete ) {
        [CONTEXT deleteObject:[content objectAtIndex:indexPath.row]];
        [content removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:YES];
//        [self loadData];
    }

}


- (IBAction)back:(id)sender {
    if (isEditingMode) {
        [iTeachWordsAppDelegate remoneUndoBranch];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)edit:(id)sender {
    if (isEditingMode) {
        [iTeachWordsAppDelegate saveUndoBranch];
    }else {
        [iTeachWordsAppDelegate createUndoBranch];
    }
    isEditingMode = !isEditingMode;
    [table setEditing:isEditingMode];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:(isEditingMode)?UIBarButtonSystemItemDone:UIBarButtonSystemItemEdit target:self action:@selector(edit:)]  autorelease];
    [table reloadData];
}

- (void)showThemeEditingView{
    ThemeEditingViewController *themeEditingView = [[ThemeEditingViewController alloc] initWithNibName:@"ThemeEditingViewController" bundle:nil];
    [self.navigationController pushViewController:themeEditingView animated:YES];
    [themeEditingView release];
}

- (void)dealloc {
    delegate = nil;
    [super dealloc];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
