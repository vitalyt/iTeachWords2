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

#define SELECTION_INDICATOR_TAG 54321
#define TEXT_LABEL_TAG 54322
#define IS_STATISTIC_AVALABLE (word && [[word.statistics allObjects] count]>0)?YES:NO

@implementation NewWordsTable

@synthesize contentArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        cellStyle = UITableViewCellStyleValue1;
        
        //[self findTranslateOfWord:nil];
    }
    return self;
}
 
- (void)dealloc
{
    if (loadingView) {
        [loadingView release];
    }
    if (workingThread) {
        [workingThread release];
    }
    if (wordTypePicker) {
        [wordTypePicker release];
        wordTypePicker = nil;
    }
    if (sortedKeys) {
        [sortedKeys release];
    }
    if (toolsView) {
        [toolsView closeView];
        [toolsView release];
    }
    [selectedWords release];
    [contentArray release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    limit = 50;
    offset = 50;
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
    [string retain];
    table.hidden = YES;
    StringTools *myStringTools = [[StringTools alloc] init];
	[myStringTools printString:string];
	contentArray = myStringTools.arrayWords;
    sortedKeys = [[NSMutableArray alloc] initWithArray:[contentArray keysSortedByValueUsingSelector:@selector(compare:)]];
	[myStringTools release];
    [table reloadData];
    table.hidden = NO;
    [string release];
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
            UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Menu" style: UIBarButtonItemStyleBordered target: myAddWordView action:@selector(back)];
            [[self navigationItem] setBackBarButtonItem: newBackButton];
            [self.navigationController pushViewController:myAddWordView animated:YES];
            [myAddWordView setText:[sortedKeys objectAtIndex:indexPath.row]];
            [myAddWordView release]; 
            [newBackButton release];
        }
    }else{
        limit += offset;
        [table reloadData];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *) findTranslateOfWord:(NSString *)_word{
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/enrus.txt"];
    NSString *text = [[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //NSLog(@"%@",text);
    NSArray *ar = [[NSArray alloc] initWithArray:[text componentsSeparatedByString:@"\n"]];
    
    NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
    NSError *error;
    NSDate *createDate = [[NSDate alloc]init];
    createDate = [[NSDate date] retain];
    WordTypes *wordType;
    wordType = [NSEntityDescription insertNewObjectForEntityForName:@"WordTypes" 
                                             inManagedObjectContext:CONTEXT];
    [wordType setName:@"EngRusDictionari"];
    [wordType setCreateDate:createDate];
    
    for (int i = 0 ; i< [ar count]; i++) {
        if ((i%100) == 0) {
            if (![CONTEXT save:&error]) {
                [UIAlertView displayError:@"There is problem with saving data."];
            }
            [pool drain];
            pool= [[NSAutoreleasePool alloc] init];
        }
        NSArray *ar2 = [NSArray arrayWithArray:[[ar objectAtIndex:i] componentsSeparatedByString:@"="]];
        Words *word = [NSEntityDescription insertNewObjectForEntityForName:@"Words" 
                                                    inManagedObjectContext:CONTEXT];
        [word setCreateDate:createDate];
        [word setChangeDate:createDate];
        [word setText:[ar2 objectAtIndex:0]];
        [word setTranslate:[ar2 objectAtIndex:1]];
        [word setDescriptionStr:wordType.name];
        [wordType addWordsObject:word];
    }
    if (![CONTEXT save:&error]) {
        [UIAlertView displayError:@"There is problem with saving data."];
    }
    
    [createDate release];
    [createDate release];
    [ar release];
    [pool drain];
    return nil;
}

- (void) parseWordsToTheme:(WordTypes *)wordType{
    [wordType retain];
    NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
    NSMutableSet *ar = [[NSMutableSet alloc] init];
    
    int count = [selectedWords count];
    for (int i = 0; i < count; i++) {
        NSAutoreleasePool *pool1= [[NSAutoreleasePool alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text = %@", [[selectedWords objectAtIndex:i] lowercaseString]];
        NSError *error;
        NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:[NSEntityDescription entityForName:@"Words" inManagedObjectContext:[iTeachWordsAppDelegate sharedContext]]];
        //[request setPropertiesToFetch:[NSArray arrayWithObjects:@"text", nil]];
        [request setPredicate:predicate];
        
        NSArray *_data = [[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error];
        
        if ([_data count] > 0) {
            Words *_word = [_data objectAtIndex:0];     
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
        [pool1 drain];
    }
    
    [wordType addWords:ar];
    NSError *_error;
    if (![CONTEXT save:&_error]) {
        [UIAlertView displayError:@"Data is not saved."];
    }
    //[ar release];
    [pool drain];
    [loadingView.view removeFromSuperview];
    
    [wordType release];
    [table reloadData];
}

-(void) filteringList{
    NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
    
    int count = [selectedWords count];
    for (int i = 0; i < count; i++) {
        NSAutoreleasePool *pool1= [[NSAutoreleasePool alloc] init];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"text = %@", [[selectedWords objectAtIndex:i] lowercaseString]];
        NSError *error;
        NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
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
        [pool1 drain];
    }
    [pool drain];
}

#pragma mark tools view delegate

- (void) selectAll{
    if ([selectedWords count]>0) {
        [self deselectAllWords];
        return;
    }
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"" 
                                                     message:NSLocalizedString(@"Select", @"")
                                                    delegate:self 
                                           cancelButtonTitle:NSLocalizedString(@"Cansel", @"")
                                           otherButtonTitles:NSLocalizedString(@"all words", @""),NSLocalizedString(@"learned words", @""), nil] autorelease];
    
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
        [wordTypePicker release];
        wordTypePicker = nil;
    }
    wordTypePicker = [[MyPickerViewContrller alloc] initWithNibName:@"MyPicker" bundle:nil];
	wordTypePicker.delegate = self;
	[wordTypePicker openViewWithAnimation:self.navigationController.view];
}

#pragma mark allert funktions

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
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
    if (!loadingView) {
        loadingView = [[LoadingViewController alloc]initWithNibName:@"LoadingViewController" bundle:nil];
        loadingView.total = [selectedWords count];
    }
    [self.view addSubview:loadingView.view];
    loadingView.view.frame = CGRectMake(0.0, 44.0, loadingView.view.frame.size.width, loadingView.view.frame.size.height);
    workingThread = [[NSThread alloc] initWithTarget:self selector:@selector(parseWordsToTheme:) object:wordType];
    [workingThread start];

}

#pragma mark - showing functions


- (void) clickEdit{	
    if (![table isEditing]) {
        if (!selectedWords) {
            selectedWords = [[NSMutableArray alloc] init];
        }
        [table setAllowsSelectionDuringEditing:YES];
        [table setEditing:YES animated:YES];
        self.navigationItem.rightBarButtonItem =
        [[[UIBarButtonItem alloc] initWithTitle:@"take words"
                                          style: UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(showMyPickerView)] autorelease];
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
