//
//  WorldTableToolsController.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/20/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "WorldTableToolsController.h"
#import "Words.h"
#import "WordTypes.h"
#import "MultiPlayer.h"
#import "TestGameController.h"
#import "TestOneOfSix.h"
#import "TestOrthography.h"
#import "AddWord.h"
#import "HeadViewController.h"
#import "Statistic.h"
#import "DetailStatisticViewController.h"
#import "ToolsViewController.h"
#import "TableCellController.h"

#ifdef FREE_VERSION
#import "PurchasesDetailViewController.h"
#import "QQQInAppStore.h"
#endif

@implementation WorldTableToolsController

- (void)dealloc
{
    [loadingView release];
    [super dealloc];
}

#pragma mark - basic tools delegate

- (void) mixArray{
	NSMutableArray *newArray = [[NSMutableArray alloc] init];
	NSMutableArray *oldArray = [[NSMutableArray alloc] initWithArray:self.data];
    int count = [oldArray count];
	for (int i=0; i< count; i++) {
		int randomIndex = [NSNumber randomFrom:0 to:[oldArray count]];
		[newArray addObject:[oldArray objectAtIndex:randomIndex]];
		[oldArray removeObjectAtIndex:randomIndex];
	}
    self.data = [NSArray arrayWithArray:newArray];
    [newArray release];
    [oldArray release];
    
}

- (void) toolsViewDidShow{
    if (toolsView.isShowingView) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, toolsView.view.frame.origin.y, self.view.frame.size.width, toolsView.view.frame.size.height)];
        [table setTableFooterView:footerView];
    }else{
        [table setTableFooterView:nil];
    }
}

- (void) clickEdit{	
    if (![table isEditing]) {
        [table setAllowsSelectionDuringEditing:YES];
        [table setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self deselectAllWords];
        tableHeadView.subTitleLabel.text = [NSString stringWithFormat:@"%@: %d",NSLocalizedString(@"total selected", @""),0];
    }else{
        [table setAllowsSelectionDuringEditing:NO];
        [table setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        tableHeadView.subTitleLabel.text = [NSString stringWithFormat:@"%@: %d",NSLocalizedString(@"total count", @""),[self.data count]];
    }
    [table reloadData];
}

- (void) showPlayerView{
	if (multiPlayer) {
        [multiPlayer closePlayer];
        [multiPlayer release];
    }
    multiPlayer = [[MultiPlayer alloc] initWithNibName:@"MultiPlayer" bundle:nil];
	multiPlayer.delegate = self;
	[multiPlayer openViewWithAnimation:self.view];
	[multiPlayer playList:self.data];
}

#pragma mark exercise funktions

- (void) clickStatistic{
    isStatisticShowing = !isStatisticShowing;
    [self showTableHeadView];
    [table reloadData];
}

- (void)optionsSubViewDidClose:(id)sender{
    if (isStatisticShowing) {
        isStatisticShowing = !isStatisticShowing;
        [self showTableHeadView];
        [table reloadData];
    }
}

- (void) clickGame{
#ifdef FREE_VERSION
    if (![MKStoreManager isCurrentItemPurchased:[QQQInAppStore purchaseIDByType:TESTGAME]]) {
        PurchasesDetailViewController *infoView = [[PurchasesDetailViewController alloc] initWithPurchaseType:TESTGAME];
        [self.navigationController presentModalViewController:infoView animated:YES];
        [infoView release];
        return;
    }
#endif
    
    if ([self.data count] == 0) {
        [UIAlertView displayError:@"The list of words is blank"];
        return;
    }
	TestGameController *testController = [[TestGameController alloc] initWithNibName:@"TestGameController" bundle:nil];
    testController.wordType = wordType;
    UIBarButtonItem *newBackButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style: UIBarButtonItemStyleBordered target: nil action: nil] autorelease];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
//    [self.navigationController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self performTransition];
	[self.navigationController pushViewController:testController animated:YES];
	testController.data = [NSMutableArray arrayWithArray:self.data];
	[testController createWord];
	[testController release];
}


- (void) clickTestOneOfSix{
    if ([self.data count] < 3) {
        [UIAlertView displayError:NSLocalizedString(@"The list of words is blank", @"")];
        return;
    }
	TestOneOfSix *testController = [[TestOneOfSix alloc] initWithNibName:@"TestOneOfSix" bundle:nil];
    testController.wordType = wordType;
    testController.data = [NSMutableArray arrayWithArray:self.data];
    [self performTransition];
	[self.navigationController pushViewController:testController animated:YES ];
	[testController release];
}

- (void) clickTest1{
#ifdef FREE_VERSION
    if (![MKStoreManager isCurrentItemPurchased:[QQQInAppStore purchaseIDByType:TEST1]]) {
        PurchasesDetailViewController *infoView = [[PurchasesDetailViewController alloc] initWithPurchaseType:TEST1];
        [self.navigationController presentModalViewController:infoView animated:YES];
        [infoView release];
        return;
    }
#endif
    if ([self.data count] == 0) {
        [UIAlertView displayError:NSLocalizedString(@"The list of words is blank", @"")];
        return;
    }
	TestOrthography *testOrthographyView = [[TestOrthography alloc] initWithNibName:@"TestOrthography" bundle:nil];
    testOrthographyView.wordType = wordType;
	testOrthographyView.data = [NSMutableArray arrayWithArray:self.data];
	//testOrthographyView.lessonName = lessonName;
	//testOrthographyView.exerciseIndex = exerciseIndex;
    UIBarButtonItem *newBackButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style: UIBarButtonItemStyleBordered target: nil action: nil] autorelease];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    [self performTransition];
    [self.navigationController pushViewController:testOrthographyView animated:YES ];
	[testOrthographyView release];
}

#pragma mark - Alert view delegate 

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case EditingViewOptionDelete:{
            switch (buttonIndex) {
                case 1:{
                    [self deleteSelectedWords];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
    [self loadData];
}

#pragma mark editing methods
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPat{
    return YES;
}


- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma matk Editing word

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath  
{ 
    if (!tableView.isEditing){
        [self showEditingViewForWord:[self.data objectAtIndex:indexPath.row]];
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [self showEditingViewForWord:[self.data objectAtIndex:indexPath.row]];
}

- (void)showEditingViewForWord:(Words*)_word{
    AddWord *myAddWordView = [[AddWord alloc] initWithNibName:@"AddWord" bundle:nil];
    [myAddWordView setWord:_word];
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Back" style: UIBarButtonItemStyleBordered target: myAddWordView action:@selector(back)];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
    [self.navigationController pushViewController:myAddWordView animated:YES];
    [myAddWordView release]; 
    [newBackButton release];
}

- (void) reassignWord
{
    int selectedCount = [self getSelectedWordsCount];
    if (selectedCount==0) {
        [UIAlertView displayError:NSLocalizedString(@"There is not selected words.", @"")];
        return;
    }else {
        [UIAlertView displayGuideMessage:NSLocalizedString(@"Select the dictionary to which you want to move the marked words.", @"") title:NSLocalizedString(@"Suggestion", @"")];        
    }
    [self showMyPickerView:nil];
}

- (void)deselectAllWords{
    for (int i=0; i<[data count]; i++) {
        Words *word = [data objectAtIndex:i];
        [word setIsSelected:[NSNumber numberWithInt:0]];
        selectedWordsCount = 0;
        [self updateSelectedLabel];
    }
}

- (void) selectAll{
    selectedWordsCount = 0;
    for (int i=0; i<[data count]; i++) {
        Words *word = [data objectAtIndex:i];
        [word setIsSelected:[NSNumber numberWithInt:(![word.isSelected boolValue])?1:0]];
        if ([word.isSelected boolValue]) {
            ++selectedWordsCount;
        }
    }
    [self updateSelectedLabel];
    [table reloadData];	
}

- (void)updateSelectedLabel{
    tableHeadView.subTitleLabel.text = [NSString stringWithFormat:@"%@: %d",NSLocalizedString(@"total selected", @""),selectedWordsCount];
}

- (void) deleteSelectedWords{
    NSMutableSet *ar = [[NSMutableSet alloc] init];
    for(Words *word in self.data) {
        if ([word.isSelected boolValue]) {
            [ar addObject:word];
            [word setIsSelected:[NSNumber numberWithInt:0]];
        }
    }
    [wordType removeWords:ar];
    [ar release];
    [iTeachWordsAppDelegate saveDB];
    [wordType release];
    wordType = nil;  
    [self loadData];
}


- (void) deleteWord
{
    int selectedCount = [self getSelectedWordsCount];
    if (selectedCount == 0) {
        [UIAlertView displayError:NSLocalizedString(@"There is not selected words.", @"")];
        return;
    }
    UIActionSheet *actionSheet = [[[UIActionSheet alloc]initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Are you sure you want to delete the (%d) word?", @""),selectedCount] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete words", @"") otherButtonTitles: nil] autorelease];
    [actionSheet showInView:self.view];
}

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:{
            [self deleteSelectedWords];
        }
            break;
        default:
            break;
    }
}

- (int)getSelectedWordsCount{
    int selectedCount = 0;
    for(Words *word in self.data) {
        if ([word.isSelected boolValue]) {
            selectedCount++;
        }
    }
    return selectedCount;
}

- (void) reassignSelectedWordsToTheme:(WordTypes *)_wordType{
    [_wordType retain];
    NSMutableSet *ar = [[NSMutableSet alloc] init];
    for(Words *word in wordType.words) {
        if ([word.isSelected boolValue]) {
            [ar addObject:word];
            [word setIsSelected:[NSNumber numberWithInt:0]];
        }
    }
    [_wordType addWords:ar];
    [wordType removeWords:ar];
    [ar release];
    [_wordType release];
    [iTeachWordsAppDelegate saveDB];
}

#pragma mark - piker delegate
- (void) pickerDone:(WordTypes *)_wordType{
    if ([table isEditing]) {
        [self reassignSelectedWordsToTheme:_wordType];
    }else{
        wordType = [_wordType retain];
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithString:wordType.name] forKey:@"lastTheme"];
        self.title = wordType.name;
    }
    [self loadData];
    if ([data count]>0) {
        [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Manager delegate
- (void) mixingWords{
	[self mixArray];
	[table reloadData];
}
- (IBAction)selectedLanguage:(id)sender{
    UISegmentedControl *segment = (UISegmentedControl*)sender;
    showingType = segment.selectedSegmentIndex;
    [table reloadData];
}


- (void) showTableHeadView{
    [super showTableHeadView];
    if (isStatisticShowing) {
        [tableHeadView generateStatisticViewWithWords:wordType.words];
    }else{
        [tableHeadView removeStatisticView];
    }
}

- (void)generateThemeStatistic{
    
}

-(void)performTransition  {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
}

@end
