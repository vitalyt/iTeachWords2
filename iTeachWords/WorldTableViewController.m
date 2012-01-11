//
//  WorldTableViewController.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/19/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "WorldTableViewController.h"
#import "EditTableViewController.h"
#import "MyPickerViewContrller.h"
#import "WordTypes.h"
#import "ToolsViewController.h"
#import "Words.h"
#import "Sounds.h"
#import "TableCellController.h"
#import "MultiPlayer.h"
#import "MenuView.h"
#import "DetailStatisticViewController.h"
#import "HeadViewController.h"

@implementation WorldTableViewController

#define SELECTION_INDICATOR_TAG 54321
#define TEXT_LABEL_TAG 54322

@synthesize wordType,showingType;

- (void)dealloc
{
    if (tableHeadView) {
        [tableHeadView release];
    }
    if (wordTypePicker) {
        [wordTypePicker release];
    }
    if (toolsView) {
        [toolsView release];
    }
    if (multiPlayer) {
        [multiPlayer closePlayer];
        [multiPlayer release];
    }
    [wordType release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - my functions

- (void) loadData{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastTheme"]) {
        [self showMyPickerView];
        return;
    }else if(!wordType){
        NSString *lastTheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTheme"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",lastTheme];
        self.title = lastTheme;
        NSFetchedResultsController *fetches = [NSManagedObjectContext 
                                               getEntities:@"WordTypes" sortedBy:@"createDate" withPredicate:predicate];
        
        NSArray *types = [fetches fetchedObjects];
        if (types && [types count]>0) {
            wordType = [[types objectAtIndex:0] retain];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", [wordType objectID]];
    NSError *error;
    NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:[NSEntityDescription entityForName:@"Words" inManagedObjectContext:[iTeachWordsAppDelegate sharedContext]]];
    [request setFetchLimit:limit];  
    [request setFetchOffset:0]; 
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"text",@"translate", nil]];
    [request setPredicate:predicate];

	NSSortDescriptor *name = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES 
                                                          selector:@selector(caseInsensitiveCompare:)];
	NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"changeDate" ascending:NO];
    self.data = [[[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:date, name, nil]];
//    suonds = [[NSMutableArray alloc]init];
//    for(Words *word in data){
//        [suonds addObject:word.text];
//    }
//    if ([suonds count] > 0) {
//        predicate = [NSPredicate predicateWithFormat:@"descriptionStr IN %@", suonds];
//        NSFetchedResultsController *fetches = [NSManagedObjectContext 
//                                               getEntities:@"Sounds" sortedBy:@"changeDate" withPredicate:predicate];
//        
//        suonds = [fetches fetchedObjects];
//    }
//    NSLog(@"%@",suonds);
    [table reloadData];
    [self showTableHeadView];
}

- (void) showMyPickerView
{
    if (wordTypePicker) {
        [wordTypePicker release];
        wordTypePicker = nil;
    }
    wordTypePicker = [[MyPickerViewContrller alloc] initWithNibName:@"MyPicker" bundle:nil];
	wordTypePicker.delegate = self;
	[wordTypePicker openViewWithAnimation:self.navigationController.view];
}

- (void) pickerDone:(WordTypes *)_wordType{
    wordType = [_wordType retain];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithString:wordType.name] forKey:@"lastTheme"];
    self.title = wordType.name;
    [self loadData];
}

# pragma mark alert table functions

- (void)checkDelayedThemes{
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"isNotShowRepeatList"] boolValue] && IS_REPEAT_OPTION_ON) {
        NSMutableArray *delayedElements = [[NSMutableArray alloc] init];
        NSArray *_repeatDelayedThemes = [[NSArray alloc] initWithArray:[[iTeachWordsAppDelegate sharedDelegate] loadRepeatDelayedTheme]];
        if ([_repeatDelayedThemes count]>0) {
            for (int i=0;i<[_repeatDelayedThemes count];i++){
                NSDictionary *dict = [_repeatDelayedThemes objectAtIndex:i];
                int interval = [[dict objectForKey:@"intervalToNexLearning"] intValue];
                if (interval < 0) {
                    [delayedElements addObject:dict];
                }
            }
        }
        [_repeatDelayedThemes release];
        if ([delayedElements count]>0) {
            [self showTableAlertViewWithElements:[delayedElements autorelease]];
        }
    }
}

- (void)showTableAlertViewWithElements:(NSArray *)elements{
    AlertTableView *alertTableView = [[AlertTableView alloc] initWithCaller:self data:elements title:@"Please repeat the themes from thelist" andContext:@"context identificator"];
    [alertTableView show];
    [alertTableView autorelease];
}

-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context{
    NSLog(@"Alert view index is ->%d",row);    
    if (context && row>=0) {
        WordTypes *_wordType = [context objectForKey:@"wordType"];
        wordType = [_wordType retain];
        [self loadData];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *dict = [iTeachWordsAppDelegate sharedSettings];
    nativeCountry = [dict objectForKey:NATIVE_COUNTRY];
    translateCountry = [dict objectForKey:TRANSLATE_COUNTRY];
    limit = 50;
    offset = 50;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMyPickerView)] autorelease];
    UIImage *image = [UIImage imageNamed:@"bookmark.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );    
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showMyPickerView) forControlEvents:UIControlEventTouchUpInside];    
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    [self showToolsView];
    [table setAllowsSelectionDuringEditing:YES];
    showingType = 1;
    
    [self performSelector:@selector(checkDelayedThemes) withObject:nil afterDelay:.5];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"lastItem"];
    [super viewWillDisappear:animated];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([self.data count]>limit) {
        return limit;
    }
    return [self.data count];
}

- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath {
    if (indexPath.row == limit-1) {
        return nil;
    }
	return @"TableCell";
}

- (float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < limit - 1) {
        return 105;
    }
    return 44;
}

- (void) configureCell:(TableCellController *)cell forRowAtIndexPath: (NSIndexPath*)indexPath {    
    if (indexPath.row < limit-1) {
        Words *word = [self.data objectAtIndex:indexPath.row];
        cell.lblEng.text = word.text;
        cell.lblRus.text = word.translate;
        cell.lblEngH.text = translateCountry;
        cell.lblRusH.text = nativeCountry;
        [cell.lblEng setFont:FONT_TEXT];
        [cell.lblRus setFont:FONT_TEXT];
        switch (showingType) {
            case 0:
                cell.lblRus.text = @"";
                break;
            case 2:
                cell.lblEng.text = @"";
                break;
            default:
                break;
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        UIImageView *indicator = (UIImageView *)[cell.contentView viewWithTag:SELECTION_INDICATOR_TAG];
        if ([word.isSelected boolValue])
        {
            indicator.image = isSelectedImg;
            [cell setSelected:YES];
        }else{
            indicator.image = notSelectedImg;
            [cell setSelected:NO];
        }
        if(isStatisticShowing){
            [((TableCellController *)cell) generateStatisticView];
            [((TableCellController *)cell).statisticViewController setWord:word];
        }
        else{
            [((TableCellController *)cell) removeStatisticView];
        }
    }else{
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        cell.textLabel.text = [NSString stringWithFormat:@"next %d words",offset];
    }
}


#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < limit - 1) {
        Words *word = [data objectAtIndex:indexPath.row];
        if (tableView.isEditing)
        {
            //[(TableCellController *)tableView.delegate updateSelectionCount];
            TableCellController *cell = (TableCellController *) [table cellForRowAtIndexPath:indexPath];
            UIImageView *indicator = (UIImageView *)[cell.contentView viewWithTag:SELECTION_INDICATOR_TAG];
            if (![word.isSelected boolValue]){
                indicator.image = isSelectedImg;
                cell.selected = YES;
                [word setIsSelected:[NSNumber numberWithInt:1]];
            }else{
                indicator.image = notSelectedImg;
                cell.selected = NO;
                [word setIsSelected:[NSNumber numberWithInt:0]];
            }
            [table deselectRowAtIndexPath:indexPath animated:YES];
            [table reloadData];	
        }else{
            [self playSoundWithIndex:indexPath];
            //[table deselectRowAtIndexPath:indexPath animated:YES];
        }
    }else{
        limit += offset;
        [self loadData];
    }
}

- (void) playSoundWithIndex:(NSIndexPath *)indexPath{
    if (multiPlayer) {
        [multiPlayer closePlayer];
        [multiPlayer release];
    }
    currentWordPlayingIndex = indexPath.row;
    NSArray *sounds = [[NSArray alloc] initWithObjects:[self.data objectAtIndex:indexPath.row], nil];
    multiPlayer = [[MultiPlayer alloc] initWithNibName:@"MultiPlayer" bundle:nil];
	multiPlayer.delegate = self;
	[multiPlayer openViewWithAnimation:self.view];
	[multiPlayer playList:sounds];
    [sounds release];
}

#pragma mark - player functions

- (void) playerDidStartPlayingSound:(int)soundIndex{
    int index;
    if ([multiPlayer.words count] > 1 && soundIndex>0) {
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:soundIndex inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        index = soundIndex+1;
    }else{
        index = currentWordPlayingIndex;
    }
    UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] ];
    [cell setSelected:YES animated:YES];
}

- (void) playerDidFinishPlayingSound:(int)soundIndex{
    int index;
    if ([multiPlayer.words count] > 1) {    
        index = soundIndex;
    }else{
        index = currentWordPlayingIndex;
    }
    
    UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] ];
    [cell setSelected:NO animated:YES];
}

#pragma mark - showing functions
- (void) showToolsView{
    toolsView = [[ToolsViewController alloc] initWithNibName:@"ToolsView" bundle:nil];
    toolsView.delegate = self;
    [toolsView openViewWithAnimation:self.view];
}

- (void) showTableHeadView{
    if (!tableHeadView) {
        tableHeadView = [[HeadViewController alloc] initWithNibName:@"HeadViewController" bundle:nil];
    }
    self.navigationItem.titleView = tableHeadView.view;
    tableHeadView.titleLabel.text = wordType.name;
    tableHeadView.subTitleLabel.text = [NSString stringWithFormat:@"total: %d",[self.data count]];
}

@end
