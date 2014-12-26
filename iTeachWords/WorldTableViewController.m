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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)loadView{
    [super loadView];
    self.playImg = [UIImage imageNamed:@"right.png"];
    self.LoadRecordImg = [UIImage imageNamed:@"Microphone.png"];
}

- (void)updateSelectedLabel{
    
}

- (void)showEditingViewForWord:(Words*)_word{
    
}

#pragma mark - my functions

- (void) loadData{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastTheme"]) {
        [self showMyPickerView:nil];
        return;
    }else if(!_wordType){
        NSString *lastTheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTheme"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",lastTheme];
        self.title = lastTheme;
        NSFetchedResultsController *fetches = [NSManagedObjectContext 
                                               getEntities:@"WordTypes" sortedBy:@"createDate" withPredicate:predicate];
        
        NSArray *types = [fetches fetchedObjects];
        if (types && [types count]>0) {
            self.wordType = [types objectAtIndex:0];
        }
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", [_wordType objectID]];
    NSError *error;
    NSFetchRequest * request = [[NSFetchRequest alloc] init] ;
    [request setEntity:[NSEntityDescription entityForName:@"Words" inManagedObjectContext:[iTeachWordsAppDelegate sharedContext]]];
    [request setFetchLimit:limit];  
    [request setFetchOffset:0]; 
    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"text",@"translate", nil]];
    [request setPredicate:predicate];

	NSSortDescriptor *name = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES 
                                                          selector:@selector(caseInsensitiveCompare:)];
	NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"changeDate" ascending:NO];
    self.data = [[[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error] sortedArrayUsingDescriptors:[NSArray arrayWithObjects:date, name, nil]];

    [table reloadData];
    [self showTableHeadView];
}

- (void) pickerDone:(WordTypes *)wordType{
    self.wordType = wordType;
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithString:wordType.name] forKey:@"lastTheme"];
    self.title = wordType.name;
    [self loadData];
}

# pragma mark alert table functions

- (void)checkDelayedThemes{
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
        if ([delayedElements count]>0) {
            [self showTableAlertViewWithElements:delayedElements];
        }
    }
}

- (void)showTableAlertViewWithElements:(NSArray *)elements{
    AlertTableView *alertTableView = [[AlertTableView alloc] initWithCaller:self data:elements title:NSLocalizedString(@"Please repeat the themes from the list", @"") andContext:@"context identificator"];
    [alertTableView show];
}

-(void)didSelectRowAtIndex:(NSInteger)row withContext:(id)context{
    if (context && row>=0) {
        WordTypes *wordType = [context objectForKey:@"wordType"];
        self.wordType = wordType;
        [[NSUserDefaults standardUserDefaults] setObject:_wordType.name forKey:@"lastTheme"];
        [self loadData];
        
        [UIAlertView displayGuideMessage:NSLocalizedString(@"To view studying Dictionary - Complete one of the exercises.", @"") title:NSLocalizedString(@"Suggestion", @"")];
    }
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [table setBackgroundColor:[UIColor clearColor]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
    NSDictionary *dict = [iTeachWordsAppDelegate sharedSettings];
    nativeCountry = [dict objectForKey:@"nativeCountry"];
    translateCountry = [dict objectForKey:@"translateCountry"];
    limit = 100;
    offset = 100;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bookmark.png"] style:UIBarButtonItemStylePlain target:self action:@selector(showMyPickerView:)];
    [self.navigationItem.rightBarButtonItem setTag:1];
    [self showToolsView];
    [table setAllowsSelectionDuringEditing:YES];
    self.showingType = 1;
    [self performSelector:@selector(checkDelayedThemes) withObject:nil afterDelay:.01];
    [self createBunnerView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:@"lastItem"];
    [super viewWillDisappear:animated];
    if (recordView) {
        [recordView saveSound:nil];
        recordView = nil;
    }
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [table setScrollEnabled:YES];
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
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
        switch (self.showingType) {
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
            [cell.btn setImage:self.playImg forState:UIControlStateNormal];
        }else{
            [cell.btn setImage:self.LoadRecordImg forState:UIControlStateNormal];
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
            TableCellController *cell = (TableCellController *) [table cellForRowAtIndexPath:indexPath];
            UIImageView *indicator = (UIImageView *)[cell.contentView viewWithTag:SELECTION_INDICATOR_TAG];
            if (![word.isSelected boolValue]){
                indicator.image = isSelectedImg;
                cell.selected = YES;
                [word setIsSelected:[NSNumber numberWithInt:1]];
                ++selectedWordsCount;
                
            }else{
                indicator.image = notSelectedImg;
                cell.selected = NO;
                [word setIsSelected:[NSNumber numberWithInt:0]];
                --selectedWordsCount;
            }
            [table deselectRowAtIndexPath:indexPath animated:YES];
            [table reloadData];	
            [self updateSelectedLabel];
        }
    }else{
        limit += offset;
        [self loadData];
    }
}

- (void) playSoundWithIndex:(NSIndexPath *)indexPath{
    if (self.multiPlayer) {
        [self.multiPlayer closePlayer];
    }
    self.currentSelectedWordPathIndex = indexPath;
    NSArray *sounds = [[NSArray alloc] initWithObjects:[self.data objectAtIndex:indexPath.row], nil];
    self.multiPlayer = [[MultiPlayer alloc] initWithNibName:@"SimpleMultiPlayer" bundle:nil];
	_multiPlayer.delegate = self;
	[_multiPlayer openViewWithAnimation:self.view];
	[_multiPlayer playList:sounds];
}

#pragma mark - player functions

- (void) playerDidStartPlayingSound:(int)soundIndex{
    if (soundIndex<0) {
        return;
    }
    [table setScrollEnabled:NO];
    NSInteger index;
    if ([_multiPlayer.words count] > 1) {
        NSIndexPath *scrollingIndex = [NSIndexPath indexPathForRow:(soundIndex>0)?soundIndex-1:0 inSection:0];
        [self performSelectorOnMainThread:@selector(scrollTableToIndexPath:) withObject:scrollingIndex waitUntilDone:YES];
        index = soundIndex+1;
    }else{
        index = _currentSelectedWordPathIndex.row;
    }

}

- (void)scrollTableToIndexPath:(NSIndexPath*)indexPath{
    [table scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void) playerDidFinishPlayingSound:(int)soundIndex{
    NSInteger index;
    if ([_multiPlayer.words count] > 1) {
        index = soundIndex;
    }else{
        index = _currentSelectedWordPathIndex.row;
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
    tableHeadView.titleLabel.text = _wordType.name;
    tableHeadView.subTitleLabel.text = [NSString stringWithFormat:@"%@: %ld",NSLocalizedString(@"total count", @""),[self.data count]];
}

#pragma  mark picker protokol

- (void) showRecordViewWithIndexPath:(NSIndexPath*)indexPath{
    //[sender setHidden:YES];
    if (recordView) {
        [recordView saveSound:nil];
        recordView = nil;
    }
    [table setUserInteractionEnabled:NO];
    [self.navigationItem.rightBarButtonItem setEnabled:NO];
    [toolsView.closeBtn setEnabled:NO];
    if (toolsView.isShowingView) {
        [toolsView showToolsView:nil];
    }
//    toolsView.view.frame.origin.y += 50;
    
    self.currentSelectedWordPathIndex = indexPath;
    recordView = [[RecordingWordViewController alloc] initWithNibName:@"RecordFullView" bundle:nil] ;
    recordView.delegate = self;
    [self.navigationController.view addSubview:recordView.view];
    
    TableCellController *_cell = (TableCellController*)[table cellForRowAtIndexPath:_currentSelectedWordPathIndex];
    CGRect cellFrame = _cell.btn.frame;
    float yOffset = [table rectForRowAtIndexPath:_currentSelectedWordPathIndex].origin.y - table.contentOffset.y;
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
    [table deselectRowAtIndexPath:_currentSelectedWordPathIndex animated:YES];
    [table reloadRowsAtIndexPaths:[NSArray arrayWithObject:_currentSelectedWordPathIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

#pragma mark TableCellProtocol functions
- (void) showMyPickerView:(id)sender
{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view];
        return;
    }
    self.wordTypePicker = [[MyPickerViewContrller alloc] initWithNibName:@"MyPicker" bundle:nil];
	_wordTypePicker.delegate = self;
	[_wordTypePicker openViewWithAnimation:self.navigationController.view];
}

- (void)btnActionClickWithCell:(TableCellController*)_cell{
    if (IS_HELP_MODE && _cell && [usedObjects indexOfObject:_cell] == NSNotFound) {
        _currentSelectedObject = _cell;
        [_hint presentModalMessage:[self helpMessageForButton:_cell] where:self.view];
        return;
    }
    NSIndexPath *_indexPath = [table indexPathForCell:_cell];
    self.currentSelectedWordPathIndex = _indexPath;
    if (recordView) {
        [recordView saveSound:nil];
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
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height/4, frame.size.width-20, frame.size.height/4)];
    l.numberOfLines = 4;
    [l setTextAlignment:NSTextAlignmentCenter];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:[self helpMessageForButton:_currentSelectedObject]];
    return l;
}

- (NSString*)helpMessageForButton:(id)_button{
    NSString *message = nil;
    NSInteger index = ((UIBarButtonItem*)_button).tag+1;
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
    buttonView = [[UIView alloc] initWithFrame:frame];
    float yOffset = [table rectForRowAtIndexPath:indexPath].origin.y - table.contentOffset.y;
    [buttonView setFrame:CGRectMake(frame.origin.x, frame.origin.y+yOffset, frame.size.width, frame.size.height)];
    return buttonView;
}


ADBannerView *adView;

@end
