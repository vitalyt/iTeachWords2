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
#import "QQQInAppStore.h"
#endif

@implementation WorldTableToolsController

- (void)dealloc
{
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
    }else{
        [table setAllowsSelectionDuringEditing:NO];
        [table setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem.enabled = YES;
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

- (void) clickGame{
#ifdef FREE_VERSION
    NSString *fullID = @"qqq.vitalyt.iteachwords.free.testGame";
    if (![MKStoreManager isCurrentItemPurchased:fullID]) {
        [[QQQInAppStore sharedStore].storeManager setDelegate:self];
        [self showLoadingView];
        [[QQQInAppStore sharedStore].storeManager buyFeature:fullID];
        return;
    }
#endif
    
    if ([self.data count] == 0) {
        [UIAlertView displayError:@"The list of words is blank."];
        return;
    }
	TestGameController *testController = [[TestGameController alloc] initWithNibName:@"TestGameController" bundle:nil];
    testController.wordType = wordType;
    UIBarButtonItem *newBackButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style: UIBarButtonItemStyleBordered target: nil action: nil] autorelease];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
	[self.navigationController pushViewController:testController animated:YES ];
	testController.data = [NSMutableArray arrayWithArray:self.data];
	[testController createWord];
	[testController release];
}


- (void) clickTestOneOfSix{
    if ([self.data count] == 0) {
        [UIAlertView displayError:@"The list of words is blank."];
        return;
    }
	TestOneOfSix *testController = [[TestOneOfSix alloc] initWithNibName:@"TestOneOfSix" bundle:nil];
    testController.wordType = wordType;
    testController.data = [NSMutableArray arrayWithArray:self.data];
    UIBarButtonItem *newBackButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style: UIBarButtonItemStyleBordered target: nil action: nil] autorelease];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
	[self.navigationController pushViewController:testController animated:YES ];
	[testController release];
}

- (void) clickTest1{
#ifdef FREE_VERSION
    NSString *fullID = @"qqq.vitalyt.iteachwords.free.test1";
    if (![MKStoreManager isCurrentItemPurchased:fullID]) {
        [[QQQInAppStore sharedStore].storeManager setDelegate:self];
        [self showLoadingView];
        [[QQQInAppStore sharedStore].storeManager buyFeature:fullID];
        return;
    }
#endif
    if ([self.data count] == 0) {
        [UIAlertView displayError:@"The list of words is blank."];
        return;
    }
	TestOrthography *testOrthographyView = [[TestOrthography alloc] initWithNibName:@"TestOrthography" bundle:nil];
    testOrthographyView.wordType = wordType;
	testOrthographyView.data = [NSMutableArray arrayWithArray:self.data];
	//testOrthographyView.lessonName = lessonName;
	//testOrthographyView.exerciseIndex = exerciseIndex;
    UIBarButtonItem *newBackButton = [[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style: UIBarButtonItemStyleBordered target: nil action: nil] autorelease];
    [[self navigationItem] setBackBarButtonItem: newBackButton];
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

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath  
{ 
    if (!tableView.isEditing){
        AddWord *myAddWordView = [[AddWord alloc] initWithNibName:@"AddWord" bundle:nil];
        [myAddWordView setWord:[self.data objectAtIndex:indexPath.row]];
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Menu" style: UIBarButtonItemStyleBordered target: myAddWordView action:@selector(back)];
        [[self navigationItem] setBackBarButtonItem: newBackButton];
        [self.navigationController pushViewController:myAddWordView animated:YES];
        [myAddWordView release]; 
        [newBackButton release];
    }
    return UITableViewCellEditingStyleNone;
}

- (void) reassignWord
{
    [self showMyPickerView];
}

- (void) selectAll{
    for (int i=0; i<[data count]; i++) {
        Words *word = [data objectAtIndex:i];
        [word setIsSelected:[NSNumber numberWithInt:(![word.isSelected boolValue])?1:0]];
    }
    [table reloadData];	
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
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Are you sure you want to delete the word?" 
                                                     message:nil 
                                                    delegate:self 
                                           cancelButtonTitle:@"No"
                                           otherButtonTitles:@"YES",nil] autorelease];
    alert.tag = EditingViewOptionDelete;
    alert.alpha = .20;
    [alert show];
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


#pragma mark showing view

- (void)showLoadingView{
    //    UIActivityIndicatorView *activityIndicatorView;
    if (!loadingView) {
        CGRect frame = self.view.frame;
        loadingView = [[UIView alloc] initWithFrame:frame];
        UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activityIndicatorView setFrame:CGRectMake(frame.size.width/2-10, frame.size.height/2-10, 20, 20)];
        [loadingView addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
        [activityIndicatorView release];
        [self.view addSubview:loadingView];
        [loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    }
    [loadingView setHidden:NO];
}

- (void)hideLoadingView{
    if (loadingView) {
        [loadingView setHidden:YES];
    }
}


#ifdef FREE_VERSION
#pragma mark MKStoreKitDelegate
- (void)productPurchased{
    NSLog(@"Purchased");
    [self hideLoadingView];
}

- (void)failed{
    NSLog(@"filed");
    [self hideLoadingView];
    
}
#endif

@end
