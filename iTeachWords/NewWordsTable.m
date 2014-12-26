//
//  NewWordsTable.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 6/2/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "NewWordsTable.h"
#import "TableCellController.h"
#import "AddWord.h"
#import "WordTypes.h"
#import "Words.h"
#import "MyPickerViewContrller.h"
#import "LoadingViewController.h"
#import "ToolsViewController.h"
#import "NewTableCell.h"
#import "StringTools.h"
#import "Statistic.h"
#import "NSString+Interaction.h"
#import "QQQBaseTransparentView.h"

#define SELECTION_INDICATOR_TAG 54321
#define TEXT_LABEL_TAG 54322
#define IS_STATISTIC_AVALABLE (word && [[word.statistics allObjects] count]>0)?YES:NO

@implementation NewWordsTable

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cellStyle = UITableViewCellStyleValue1;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedString(@"iStudyWords", @"")];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
    limit = 100;
    offset = 100;
    cellStyle = UITableViewCellStyleValue1;
    [self showToolsView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) loadDataWithString:(NSString *)string{
    table.hidden = YES;
    if (!stringTools) {
        stringTools = [[StringTools alloc] init];
    }
	[stringTools printString:string];
	contentArray = stringTools.arrayWords;
    sortedKeys = [[NSMutableArray alloc] initWithArray:[contentArray keysSortedByValueUsingSelector:@selector(compare:)]];
    [table reloadData];
    table.hidden = NO;
//    [string release];
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
    if ([sortedKeys count] > limit) {
        return limit;
    }
    return [sortedKeys count];
}

- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath {
    if (indexPath.row == limit-1) {
        return nil;
    }
	return @"NewTableCell";
}

#pragma mark Table view functions

- (id)cellBackgroundViewWithFrame:(CGRect)frame{
    UIView *bg = [[QQQBaseTransparentView alloc] initWithFrame:frame];
    bg.backgroundColor = [UIColor clearColor]; // or any color
    return bg;
}

- (id)cellSelectedBackgroundViewWithIndexPath:(NSIndexPath*)indexPath{
    OSDNUITableCellView *v = [[OSDNUITableCellView alloc] initWithRountRect:10];
    
    v.fillColor = [UIColor colorWithRed:22/255.0f green:22/255.0f blue:22/255.0f alpha:.5f];
    v.borderColor = [UIColor darkGrayColor];
    [v setPositionCredentialsRow: indexPath.row count:[self tableView:table numberOfRowsInSection:indexPath.section]];
    return v;
}

- (void) configureCell: (NewTableCell *)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    if (indexPath.row < limit-1) {
        cell.accessoryType = [table isEditing]?UITableViewCellAccessoryNone:UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = [sortedKeys objectAtIndex:indexPath.row];
        [cell.textLabel setFont:FONT_TEXT];
        [cell.detailLabel setFont:FONT_TEXT];
        cell.detailLabel.text = [[contentArray objectForKey:[sortedKeys objectAtIndex:indexPath.row]] description];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        UIImageView *indicator = (UIImageView *)[cell.contentView viewWithTag:SELECTION_INDICATOR_TAG];
        if ([selectedWords containsObject:[sortedKeys objectAtIndex:indexPath.row]])
        {
            indicator.image = isSelectedImg;
            [cell setSelected:YES];
        }else{
            indicator.image = notSelectedImg;
            [cell setSelected:NO];
        }
        
    }else{
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
        cell.textLabel.text = [NSString stringWithFormat:@"next %d words",offset];
        [cell setSelected:NO];
        [cell setEditing:NO];
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < limit - 1) {
        if (tableView.isEditing)
        {
            TableCellController *cell = (TableCellController *) [table cellForRowAtIndexPath:indexPath];
            NSString *selectedOb = [sortedKeys objectAtIndex:indexPath.row];
            UIImageView *indicator = (UIImageView *)[cell.contentView viewWithTag:SELECTION_INDICATOR_TAG];
            if (![selectedWords containsObject:selectedOb]){
                indicator.image = isSelectedImg;
                cell.selected = YES;
                [selectedWords addObject:selectedOb];
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }else{
                indicator.image = notSelectedImg;
                cell.selected = NO;
                [selectedWords removeObject:selectedOb];
                if ([selectedWords count]<=0) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                }
            }
            [table deselectRowAtIndexPath:indexPath animated:YES];
            [table reloadData];	
        }else{
            AddWord *myAddWordView = [[AddWord alloc] initWithNibName:@"AddWord" bundle:nil]; 
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", @"") style: UIBarButtonItemStyleBordered target: myAddWordView action:@selector(back)];
            [[self navigationItem] setBackBarButtonItem: newBackButton];
            [self.navigationController pushViewController:myAddWordView animated:YES];
            [myAddWordView setText:[sortedKeys objectAtIndex:indexPath.row]];
        }
    }else{
        limit += offset;
        [table reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)stripDoubleSpaceFrom:(NSString *)str {
    //NSString *lastObj = [NSString stringWithFormat:@"%c",[str characterAtIndex:str]]];
    //NSLog(@"%@%d",lastObj,[str rangeOfString:lastObj].length);
    while ([str rangeOfString:@"\n"].length > 0) {
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    }
    return str;
}

- (void)save{
    NSError *_error;
    if (![CONTEXT save:&_error]) {
        [UIAlertView displayError:@"There is problem with saving data."];
    }else{
//        [iTeachWordsAppDelegate clearUdoManager];
    }
}

- (void) translateWords{
    if (!self.wordType) {
        [self showMyPickerView];
        return;
    }
    if ([iTeachWordsAppDelegate isNetwork]) {
        CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@""
                                                         message:NSLocalizedString(@"Where do you want to search translations?", @"")
                                                        delegate:self 
                                               cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                               otherButtonTitles:NSLocalizedString(@"In my database", @""),NSLocalizedString(@"In the network", @""), nil];
        [alert setTag:666];
        [alert show];
    }else{
        [self loadLocalTranslateWords:selectedWords];
    }

}



- (void)loadLocalTranslateWords:(NSArray*)wordsArray{
    NSMutableSet *ar = [[NSMutableSet alloc] init];
    [self performSelectorOnMainThread:@selector(showLoadingView) withObject:nil waitUntilDone:YES];
    NSInteger count = [selectedWords count];
    [loadingView setTotal:count];
    
    [iTeachWordsAppDelegate createUndoBranch];
    @try {
        for (int i = 0; i < count; i++) {
            if ((i%100) == 0) {
                [self.wordType addWords:ar];
                [ar removeAllObjects];
                [loadingView performSelectorOnMainThread:@selector(updateDataCurrentIndex:) withObject:[NSNumber numberWithInt:i] waitUntilDone:YES];
                
                [iTeachWordsAppDelegate saveUndoBranch];
                [iTeachWordsAppDelegate createUndoBranch];
            }
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text = %@", [[selectedWords objectAtIndex:i] lowercaseString]];
            NSError *error;
            NSFetchRequest * request = [[NSFetchRequest alloc] init];
            [request setEntity:[NSEntityDescription entityForName:@"Words" inManagedObjectContext:[iTeachWordsAppDelegate sharedContext]]];
            //[request setPropertiesToFetch:[NSArray arrayWithObjects:@"text", nil]];
            [request setPredicate:predicate];
            
            NSArray *_data = [[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error];
            
            if ([_data count] > 0) {
                Words *_word = ((Words*)[_data objectAtIndex:0]);  
                [_word setType:self.wordType];
                [ar addObject:_word];
                [sortedKeys removeObject:[selectedWords objectAtIndex:i]];
                [selectedWords removeObjectAtIndex:i];
                if ([selectedWords count]<=0) {
                    self.navigationItem.rightBarButtonItem.enabled = NO;
                }
                --count;
                --i;
            }
            [loadingView performSelectorOnMainThread:@selector(updateDataCurrentIndex:) withObject:[NSNumber numberWithInt:i] waitUntilDone:YES];
        }
        [self.wordType addWords:ar];
        [iTeachWordsAppDelegate saveUndoBranch];
    }
    @catch (NSException *exception) {
        [iTeachWordsAppDelegate remoneUndoBranch];
    }
    @finally {
        [loadingView closeLoadingView];
    }
    [table reloadData];
}

- (void)loadTranslateWords:(NSArray*)wordsArray{
    if (!self.wordType) {
        [self showMyPickerView];
        return;
    }
    if (!stringTools) {
        stringTools = [[StringTools alloc] init];
    }
    [stringTools loadTranslateForWords:selectedWords withDelegate:self];
}

-(void)didLoadTranslate:(NSArray*)translate{
    [self addWords:selectedWords withTranslate:translate toWordType:self.wordType];
}

- (void)addWords:(NSArray*)words withTranslate:(NSArray*)translates toWordType:(WordTypes*)_wordType{
    
    [UIAlertView showLoadingViewWithMwssage:NSLocalizedString(@"Loading...", @"")];
    NSMutableSet *ar = [[NSMutableSet alloc] init];
    [iTeachWordsAppDelegate createUndoBranch];
    @try {
        for (int i=0;i<[words count];i++){
            if ([translates count]>i) {
                NSString *text = [words objectAtIndex:i];
                NSString *translate = [NSString stringWithString:[translates objectAtIndex:i]];
                text = [text removeSpaces];
                text = [NSString removeSpaces:text];
                NSLog(@"%@",translate);
                translate = [NSString removeSpaces:translate];
                NSLog(@"%@",translate);
                Words *currentWord = [NSEntityDescription insertNewObjectForEntityForName:@"Words" 
                                                                   inManagedObjectContext:CONTEXT];
                [currentWord setCreateDate:[NSDate date]];
                [currentWord setType:self.wordType];
                [currentWord setTypeID:self.wordType.typeID];
                [currentWord setChangeDate:[NSDate date]];
                [currentWord setText:text];
                [currentWord setTranslate:translate];
                
                [ar addObject:currentWord];
            }
        }
        [self.wordType addWords:ar];
        [iTeachWordsAppDelegate saveUndoBranch];
    }
    @catch (NSException *exception) {
        [iTeachWordsAppDelegate remoneUndoBranch];
        
    }
    @finally {
        [UIAlertView removeMessage];
    }

}

-(void) filteringList{
    NSInteger count = [selectedWords count];
    for (int i = 0; i < count; i++) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text = %@", [[selectedWords objectAtIndex:i] lowercaseString]];
        NSError *error;
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Words" inManagedObjectContext:[iTeachWordsAppDelegate sharedContext]]];
        //[request setPropertiesToFetch:[NSArray arrayWithObjects:@"text", nil]];
        [request setPredicate:predicate];
        [loadingView performSelectorOnMainThread:@selector(updateDataCurrentIndex:) withObject:[NSNumber numberWithInt:i] waitUntilDone:YES];

        NSArray *_data = [[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error];
        
        if ([_data count] > 0) {
            Words *word = [_data objectAtIndex:0];
            NSLog(@"%@",word.text);
            if (IS_STATISTIC_AVALABLE) {
                Statistic *statistic = [[word.statistics allObjects] objectAtIndex:0];
                int requestCount = [statistic.requestCount intValue];
                int successfulCount = [statistic.successfulCount intValue];
                float result;
                if (index > 0) {
                    result = (float)(1.0 - (float)(requestCount - successfulCount)/requestCount);
                }
                
                NSLog(@"%f",result*100);
                if ((int)(result*100)>=85) {
                    continue;
                }
            }
            
        }
        [selectedWords removeObjectAtIndex:i];
        if ([selectedWords count]<=0) {
            self.navigationItem.rightBarButtonItem.enabled = NO;
        }
        --count;
        --i;
    }
}

#pragma mark tools view delegate

- (void) selectAll{
    if ([selectedWords count]>0) {
        [self deselectAllWords];
        return;
    }
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:NSLocalizedString(@"Select", @"")
                                                     message:@""
                                                    delegate:self 
                                           cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
                                           otherButtonTitles:NSLocalizedString(@"All words", @""),NSLocalizedString(@"Learned words", @""), nil];
    [alert setTag:555];
    [alert show];
}

- (void) deleteWord{
    for(int i=0; i < [selectedWords count]; i++) {
        [sortedKeys removeObject:[selectedWords objectAtIndex:i]];
        [selectedWords removeObjectAtIndex:i];
        --i;
    }
    if ([selectedWords count]<=0) {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
    [table reloadData];
}

- (void) showMyPickerView
{
    if (wordTypePicker) {
        wordTypePicker = nil;
    }
    wordTypePicker = [[MyPickerViewContrller alloc] initWithNibName:@"MyPicker" bundle:nil];
	wordTypePicker.delegate = self;
	[wordTypePicker openViewWithAnimation:self.navigationController.view];
}

#pragma mark allert funktions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //selecting words
    if (alertView.tag == 555) {
        switch (buttonIndex) {
            case 1:
                [self selectAllWords];
                break;
            case 2:
                [self selectAllWords];
                [self filteringList];
                break;           
            default:
                break;
        }
    }else if(alertView.tag == 666){//laoding translates
        switch (buttonIndex) {
            case 1:
                [self loadLocalTranslateWords:selectedWords];
                break;
            case 2:
                [self loadTranslateWords:selectedWords];
                break;           
            default:
                break;
        }
    }
}

-(void) selectAllWords{
    for(int i=0; i < [sortedKeys count]; i++) {
        NSString *selectedOb = [sortedKeys objectAtIndex:i];
        if ([selectedWords containsObject:selectedOb]) {
            [selectedWords removeObject:selectedOb];
            if ([selectedWords count] == 0) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
        }else{
            [selectedWords addObject:selectedOb];
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
    }
    [table reloadData];	
}

-(void) deselectAllWords{
    for(int i=0; i < [sortedKeys count]; i++) {
        NSString *selectedOb = [sortedKeys objectAtIndex:i];
        if ([selectedWords containsObject:selectedOb]) {
            [selectedWords removeObject:selectedOb];
            if ([selectedWords count] == 0) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            }
        }
    }
    [table reloadData];	
}

#pragma mark picker protocol

- (void) pickerDone:(WordTypes *)wordType{
    self.wordType = wordType;
    [self translateWords];
}

#pragma mark - showing functions
- (void)showLoadingView{
    if (!loadingView) {
        loadingView = [[LoadingViewController alloc]initWithNibName:@"LoadingViewController" bundle:nil];
        loadingView.total = [selectedWords count];
    }
    [loadingView showLoadingView];
}

- (void) clickEdit{	
    if (![table isEditing]) {
        if (!selectedWords) {
            selectedWords = [[NSMutableArray alloc] init];
        }
        [table setAllowsSelectionDuringEditing:YES];
        [table setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem =
        [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Use words", @"")
                                          style: UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(showMyPickerView)];
        self.navigationItem.rightBarButtonItem.enabled = ([selectedWords count]<=0)?NO:YES;
    }else{
        [table setAllowsSelectionDuringEditing:NO];
        [table setEditing:NO animated:YES];
        self.navigationItem.rightBarButtonItem = nil;
    }
    [table reloadData];
}

- (void) reassignWord
{
    [self showMyPickerView];
}

- (void) showToolsView{
    toolsView = [[ToolsViewController alloc] initWithNibName:@"ToolsView" bundle:nil];
    toolsView.delegate = self;
    [toolsView openViewWithAnimation:self.view];
    [toolsView removeOptionWithIndex:0];
    [toolsView removeOptionWithIndex:1];
    [toolsView removeOptionWithIndex:2];
    [toolsView removeOptionWithIndex:3];
}

@end
