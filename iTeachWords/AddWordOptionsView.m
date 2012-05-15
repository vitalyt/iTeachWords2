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
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Arrow down 24x24"] style:UIBarButtonItemStylePlain target:self action:@selector(showAddWordView:)] autorelease];
    [self.navigationItem.rightBarButtonItem setTag:4];
    [self performSelector:@selector(addWordView) withObject:nil afterDelay:0.1];
}

- (void) back{
	[wordsView back];
}

- (void)addWordView{
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

- (void)showAddWordView:(id)sender{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view];
        return;
    }
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
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                               initWithImage:[UIImage imageNamed:(!isWordsViewShowing)?@"Arrow down 24x24":@"Arrow up 24x24"] 
                                               style:UIBarButtonItemStylePlain 
                                               target:self 
                                               action:@selector(showAddWordView:)
                                               ] autorelease];
    [self.navigationItem.rightBarButtonItem setTag:4];
}

#pragma mark create menu

- (void)createMenu{
    [self becomeFirstResponder];
    NSMutableArray *menuItemsMutableArray = [NSMutableArray new];
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Add word", @"")
                                                       action:@selector(parceTranslateWord)] autorelease];
    UIMenuItem *menuTextParseItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Parse text", @"")
                                                                action:@selector(parseText:)] autorelease];
    UIMenuItem *menuTextTranslateItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Translate", @"")
                                                                    action:@selector(translateText:)] autorelease];
    UIMenuItem *menuTextPlayItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Play text", @"")
                                                               action:@selector(playText:)] autorelease];
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
        [self showAddWordView:nil];
    }
    NSString *selectedText = [self getSelectedText];
    [wordsView setText:selectedText];
    [wordsView.dataModel loadTranslateText:selectedText fromLanguageCode:TRANSLATE_LANGUAGE_CODE toLanguageCode:NATIVE_LANGUAGE_CODE withDelegate:wordsView];
    //[self translateText];
}

- (void)parseText:(id)sender{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
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
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
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
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
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

#pragma mark Alert functions

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[wordsView save:nil];
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
