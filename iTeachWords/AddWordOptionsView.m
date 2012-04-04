//
//  AddWordWebViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/6/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "AddWordOptionsView.h"
#import "AddNewWordViewController.h"
#import "TextViewController.h"
#import "NewWordsTable.h"

@implementation AddWordOptionsView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        if (!wordsView) {
//            wordsView = [[AddNewWordViewController alloc] initWithNibName:@"AddNewWordViewController" bundle:nil];
//            [wordsView setDelegate:self];
//        } 
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self createMenu];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]
                                              initWithTitle:NSLocalizedString(@"Back", @"") style:UIBarButtonItemStyleBordered
                                              target:self action:@selector(back)] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
                                               initWithTitle:NSLocalizedString(@"Add word", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(showAddWordView)] autorelease];
    [self addWebView];
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

- (void) back{
	[wordsView back];
}

- (void)addWebView{
    if (!wordsView) {
        wordsView = [[AddNewWordViewController alloc] initWithNibName:@"AddNewWordViewController" bundle:nil];
        [wordsView setDelegate:self];
    }        
    CGRect frame = CGRectMake(10, -wordsView.view.frame.size.height, self.view.frame.size.width - 20, wordsView.view.frame.size.height);
    [wordsView.view setFrame:frame];
    [self.view addSubview:wordsView.view];
    [self.view bringSubviewToFront:wordsView.view];
    isWordsViewShowing = NO;
}

- (void)showAddWordView{
    CGRect frame = CGRectMake(10, 44, self.view.frame.size.width - 20, wordsView.view.frame.size.height);
    if (isWordsViewShowing) {
        frame = CGRectMake(10, -wordsView.view.frame.size.height, self.view.frame.size.width - 20, wordsView.view.frame.size.height);
        //[self saveData];
        [wordsView closeAllKeyboard];
    }
    [self.view bringSubviewToFront:wordsView.view];
    [UIView beginAnimations:@"MoveWebView" context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [wordsView.view setFrame:frame];
    [UIView commitAnimations];
    
    isWordsViewShowing = !isWordsViewShowing;
}

#pragma mark create menu

- (void)createMenu{
    [self becomeFirstResponder];
    NSMutableArray *menuItemsMutableArray = [NSMutableArray new];
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Add word", @"")
                                                       action:@selector(parceTranslateWord)] autorelease];
    UIMenuItem *menuTextParseItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Parse text", @"")
                                                                action:@selector(parseText)] autorelease];
    UIMenuItem *menuTextTranslateItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Translate", @"")
                                                                    action:@selector(translateText)] autorelease];
    UIMenuItem *menuTextPlayItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Play text", @"")
                                                                    action:@selector(playText)] autorelease];
    [menuItemsMutableArray addObject:menuItem];
    [menuItemsMutableArray addObject:menuTextParseItem];
    [menuItemsMutableArray addObject:menuTextTranslateItem];
    [menuItemsMutableArray addObject:menuTextPlayItem];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect: self.view.superview.frame
                           inView:self.view];
    menuController.menuItems = menuItemsMutableArray;
    [menuController setMenuVisible:YES
                          animated:YES];
    [[UIMenuController sharedMenuController] setMenuItems:menuItemsMutableArray];
    [menuItemsMutableArray release];
}

//needs to be redirect in delegate
- (NSString *)getSelectedText{
    NSString *selectedText = @"";//[webView stringByEvaluatingJavaScriptFromString:@"window.getSelection().toString()"];
    return selectedText;
}

- (void)parceTranslateWord{
    if (!isWordsViewShowing) {
        [self showAddWordView];
    }
    NSString *selectedText = [self getSelectedText];
    [wordsView setText:selectedText];
    [wordsView.dataModel loadTranslateText:selectedText fromLanguageCode:TRANSLATE_LANGUAGE_CODE toLanguageCode:NATIVE_LANGUAGE_CODE withDelegate:wordsView];
    //[self translateText];
}

- (void)parseText:(id)sender{
    if (IS_HELP_MODE && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view];
        return;
    }
    NSString *selectedText = [self getSelectedText];
    if (selectedText.length > 0) {
        [self showParsedWordTable];
    }
}

-(void) translateText:(id)sender{
    if (IS_HELP_MODE && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view];
        return;
    }
    NSString *selectedText = [self getSelectedText];
    if (selectedText.length > 0) {
        [wordsView.dataModel loadTranslateText:selectedText fromLanguageCode:TRANSLATE_LANGUAGE_CODE toLanguageCode:NATIVE_LANGUAGE_CODE withDelegate:self];
    }
}

-(void) playText:(id)sender{
    if (IS_HELP_MODE && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view];
        return;
    }
    NSString *selectedText = [self getSelectedText];
    if (selectedText.length > 0) {
        MyVocalizerViewController *voiceView = [[MyVocalizerViewController alloc] initWithDelegate:self];
        [voiceView setText:selectedText withLanguageCode:TRANSLATE_LANGUAGE_CODE];
        [self.navigationController presentModalViewController:voiceView animated:YES];
        [voiceView release];
    }
}

#pragma mark loadingTranslate delegate functions

- (void)translateDidLoad:(NSString *)translateText byLanguageCode:(NSString*)_activeTranslateLanguageCode{
    if (translateText == nil) { 
        return;
    }
    [UIAlertView displayMessage:translateText];
}

- (void) saveData{
	if (!wordsView.flgSave) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you want save word?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cansel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete canges", @"") otherButtonTitles: NSLocalizedString(@"Save changes", @""), nil];
        [actionSheet showInView:self.view];
        [actionSheet autorelease];
	}
}

- (void) showParsedWordTable{
    [wordsView removeChanges];
	NewWordsTable *parsedWordTableView = [[NewWordsTable alloc] initWithNibName:@"NewWordsTable" bundle:nil];
    [self.navigationController pushViewController:parsedWordTableView animated:YES];
    [parsedWordTableView loadDataWithString:[self getSelectedText]];
    [parsedWordTableView release];
}

#pragma mark Alert functions

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[wordsView save];
	}
	else if (buttonIndex == 0){
        [wordsView removeChanges];
	}
	else if (buttonIndex == 2){
		return;
	}
}

- (IBAction) showVocalizerView{
    
}

- (void)dealloc{
    [wordsView release];
    wordsView = nil;
    [super dealloc];
}

@end
