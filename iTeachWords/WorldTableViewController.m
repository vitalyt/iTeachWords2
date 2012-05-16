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
#import "RecordingWordViewController.h"

@implementation WorldTableViewController

#define SELECTION_INDICATOR_TAG 54321
#define TEXT_LABEL_TAG 54322
#define CELL_HIGHT 120

@synthesize wordType,showingType;

- (void)dealloc
{
    [recordView release];
    if (tableHeadView) {
        [tableHeadView release];
        tableHeadView = nil;
    }
    if (wordTypePicker) {
        [wordTypePicker release];
        wordTypePicker = nil;
    }
    if (toolsView) {
        [toolsView release];
        toolsView = nil;
    }
    if (multiPlayer) {
        [multiPlayer closePlayer];
        [multiPlayer release];
        multiPlayer = nil;
    }
    [currentSelectedWordPathIndex release];
    [playImg release];
    [wordType release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)loadView{
    [super loadView];
    playImg = [[UIImage imageNamed:@"right.png"] retain];
    LoadRecordImg = [[UIImage imageNamed:@"Microphone.png"] retain];
}

#pragma mark - my functions

- (void) loadData{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastTheme"]) {
        [self showMyPickerView:nil];
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
    [name release];
    [date release];
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
//    [self performSelector:@selector(showHelpCellView) withObject:nil afterDelay:1.0];
}

- (void) pickerDone:(WordTypes *)_wordType{
    wordType = [_wordType retain];
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithString:wordType.name] forKey:@"lastTheme"];
    self.title = wordType.name;
    [self loadData];
}

# pragma mark alert table functions

- (void)checkDelayedThemes{
    NSLog(@"%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"isNotShowRepeatList"]);
    NSLog(@"%d",IS_REPEAT_OPTION_ON);
    if (IS_REPEAT_OPTION_ON && (![[NSUserDefaults standardUserDefaults] boolForKey:@"isNotShowRepeatList"])) {
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
    AlertTableView *alertTableView = [[AlertTableView alloc] initWithCaller:self data:elements title:@"Please repeat the themes from the list" andContext:@"context identificator"];
    [alertTableView show];
    [alertTableView autorelease];
}

-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context{
    NSLog(@"Alert view index is ->%d",row);    
    if (context && row>=0) {
        WordTypes *_wordType = [context objectForKey:@"wordType"];
        wordType = [_wordType retain];
        [[NSUserDefaults standardUserDefaults] setObject:_wordType.name forKey:@"lastTheme"];
        [self loadData];
    }
}

#pragma mark - View lifecycle

- (void)viewDidUnload{
    [tableHeadView release];
    tableHeadView = nil;
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [table setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
    NSDictionary *dict = [iTeachWordsAppDelegate sharedSettings];
    nativeCountry = [dict objectForKey:@"nativeCountry"];
    translateCountry = [dict objectForKey:@"translateCountry"];
    limit = 50;
    offset = 50;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMyPickerView:)] autorelease];
    [self.navigationItem.rightBarButtonItem setTag:1];
//    UIImage *image = [UIImage imageNamed:@"bookmark.png"];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake( 0, 0, image.size.width, image.size.height );    
//    [button setImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(showMyPickerView:) forControlEvents:UIControlEventTouchUpInside];    
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    
    [self showToolsView];
    [table setAllowsSelectionDuringEditing:YES];
    showingType = 1;
    
    [self performSelector:@selector(checkDelayedThemes) withObject:nil afterDelay:.01];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"lastItem"];
    [super viewWillDisappear:animated];
    if (recordView) {
        [recordView saveSound:nil];
        [recordView release];
        recordView = nil;
    }
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
        return CELL_HIGHT;
    }
    return 44;
}

- (void) configureCell:(TableCellController *)cell forRowAtIndexPath: (NSIndexPath*)indexPath {    
    if (indexPath.row < limit-1) {
        cell.delegate = self;
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UIImageView *indicator = (UIImageView *)[cell.contentView viewWithTag:SELECTION_INDICATOR_TAG];
        
        //changing image of playing button 
        if ([word.sounds count]>0) {
            [cell.btn setImage:playImg forState:UIControlStateNormal];
        }else{
            [cell.btn setImage:LoadRecordImg forState:UIControlStateNormal];
        }
        
        if (table.isEditing)
        {
            //changing image of selecting button  
            if ([word.isSelected boolValue])
            {
                indicator.image = isSelectedImg;
                [cell setSelected:YES];
            }else{
                indicator.image = notSelectedImg;
                [cell setSelected:NO];
            }
            
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
            cell.btn.hidden = YES;
        }else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            cell.btn.hidden = NO;
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

//            [table deselectRowAtIndexPath:indexPath animated:YES];
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
    currentSelectedWordPathIndex = [indexPath retain];
    NSArray *sounds = [[NSArray alloc] initWithObjects:[self.data objectAtIndex:indexPath.row], nil];
    multiPlayer = [[MultiPlayer alloc] initWithNibName:@"SimpleMultiPlayer" bundle:nil];
	multiPlayer.delegate = self;
	[multiPlayer openViewWithAnimation:self.view];
	[multiPlayer playList:sounds];
    [sounds release];
}

#pragma mark - player functions

- (void) playerDidStartPlayingSound:(int)soundIndex{
    if (soundIndex<0) {
        return;
    }
    [table setScrollEnabled:NO];
    int index;
    if ([multiPlayer.words count] > 1) {
        NSIndexPath *scrollingIndex = [NSIndexPath indexPathForRow:(soundIndex>0)?soundIndex-1:0 inSection:0];
        [self performSelectorOnMainThread:@selector(scrollTableToIndexPath:) withObject:scrollingIndex waitUntilDone:YES];
        index = soundIndex+1;
    }else{
        index = currentSelectedWordPathIndex.row;
    }

}

- (void)scrollTableToIndexPath:(NSIndexPath*)indexPath{
    [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void) playerDidFinishPlayingSound:(int)soundIndex{
    int index;
    if ([multiPlayer.words count] > 1) {    
        index = soundIndex;
    }else{
        index = currentSelectedWordPathIndex.row;
    }
}

- (void)playerDidFinishPlaying:(id)sender{
    table.scrollEnabled = YES;
}

- (void)playerDidClose:(id)sender{
    table.scrollEnabled = YES;
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

#pragma  mark picker protokol

- (void) showRecordViewWithIndexPath:(NSIndexPath*)indexPath{
    //[sender setHidden:YES];
    if (recordView) {
        [recordView saveSound:nil];
        [recordView release];
        recordView = nil;
    }
    [table setUserInteractionEnabled:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [toolsView.closeBtn setEnabled:NO];
    if (toolsView.isShowingView) {
        [toolsView showToolsView:nil];
    }
//    toolsView.view.frame.origin.y += 50;
    
    currentSelectedWordPathIndex = [indexPath retain];
    recordView = [[RecordingWordViewController alloc] initWithNibName:@"RecordFullView" bundle:nil] ;
    recordView.delegate = self;
    [self.navigationController.view addSubview:recordView.view];
    
    TableCellController *_cell = (TableCellController*)[table cellForRowAtIndexPath:currentSelectedWordPathIndex];
    CGRect cellFrame = _cell.btn.frame;
    float yOffset = [table rectForRowAtIndexPath:currentSelectedWordPathIndex].origin.y - table.contentOffset.y;
    [recordView.view setFrame:CGRectMake(cellFrame.origin.x+cellFrame.size.width/2, _cell.btn.frame.origin.y+_cell.btn.frame.size.height/2+yOffset, 10, 10)];
    recordView.soundType = TEXT;
    Words *_word = [data objectAtIndex:indexPath.row];
    [recordView setWord:_word withType:TEXT];
    [UIView beginAnimations:@"ShowOptionsView" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [recordView.view setFrame:CGRectMake(self.view.superview.center.x-105/2, self.view.superview.center.y-105/2, 105, 105)];
    [UIView commitAnimations];
}

- (void) recordViewDidClose:(id)sender{
//    [self playSoundWithIndex:currentSelectedWordPathIndex];
    [table setUserInteractionEnabled:YES];
    [self.navigationItem.rightBarButtonItem setEnabled:YES];
    [toolsView.closeBtn setEnabled:YES];
    if (!toolsView.isShowingView) {
        [toolsView showToolsView:nil];
    }
    [table deselectRowAtIndexPath:currentSelectedWordPathIndex animated:YES];
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:currentSelectedWordPathIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark TableCellProtocol functions
- (void) showMyPickerView:(id)sender
{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view];
        return;
    }
    if (wordTypePicker) {
        [wordTypePicker release];
        wordTypePicker = nil;
    }
    wordTypePicker = [[MyPickerViewContrller alloc] initWithNibName:@"MyPicker" bundle:nil];
	wordTypePicker.delegate = self;
	[wordTypePicker openViewWithAnimation:self.navigationController.view];
}

- (void)btnActionClickWithCell:(TableCellController*)_cell{
    if (IS_HELP_MODE && _cell && [usedObjects indexOfObject:_cell] == NSNotFound) {
        _currentSelectedObject = _cell;
        [_hint presentModalMessage:[self helpMessageForButton:_cell] where:self.view];
        return;
    }
    NSIndexPath *_indexPath = [table indexPathForCell:_cell];
    currentSelectedWordPathIndex = [_indexPath retain];
    if (recordView) {
        [recordView saveSound:nil];
        [recordView release];
        recordView = nil;
    }
    Words *_word = [data objectAtIndex:_indexPath.row];
    if ([_word.sounds count]==0) {    
        [self showRecordViewWithIndexPath:_indexPath];
    }else{
        [self playSoundWithIndex:_indexPath];
    }
}


-(UIView*)hintStateViewForDialog:(id)hintState
{
    CGRect frame = self.view.superview.frame;
    UILabel *l = [[[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height/4, frame.size.width-20, frame.size.height/4)] autorelease];
    l.numberOfLines = 4;
    [l setTextAlignment:UITextAlignmentCenter];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:[self helpMessageForButton:_currentSelectedObject]];
    return l;
}

- (NSString*)helpMessageForButton:(id)_button{
    NSString *message = nil;
    int index = ((UIBarButtonItem*)_button).tag+1;
    switch (index) {
        case 1:
            message = NSLocalizedString(@"Запись/воспроизведение слова", @"");
            break;
        case 2:
            message = NSLocalizedString(@"Выбор словаря", @"");
            break;
        default:
            break;
    }
    return message;
}


-(UIView*)hintStateViewToHint:(id)hintState
{
    NSIndexPath *indexPath = [table indexPathForCell:(TableCellController *)_currentSelectedObject];
    [usedObjects addObject:_currentSelectedObject];
    UIView *buttonView = nil;
    UIView *view = (UIView *)_currentSelectedObject;
    if (view.tag == 1) {
        @try {
            view = ([_currentSelectedObject valueForKey:@"view"])?[_currentSelectedObject valueForKey:@"view"]:nil;
        }
        @catch (NSException *exception) {
        }
        @finally {
            
        }
        return view;
    }
    view = ((TableCellController *)_currentSelectedObject).btn;
    CGRect frame = view.frame;
    buttonView = [[[UIView alloc] initWithFrame:frame] autorelease];
    float yOffset = [table rectForRowAtIndexPath:indexPath].origin.y - table.contentOffset.y;
    [buttonView setFrame:CGRectMake(frame.origin.x, frame.origin.y+yOffset, frame.size.width, frame.size.height)];
    return buttonView;
}

@end
