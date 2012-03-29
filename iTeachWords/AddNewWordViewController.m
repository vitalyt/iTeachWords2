//
//  AddNewWordViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 12/5/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "AddNewWordViewController.h"
#import "MyPickerViewContrller.h"
#import "WordTypes.h"
#import "Words.h"
#import "RecordingWordViewController.h"

#define DELEGATE ((UIViewController*)delegate)

@implementation AddNewWordViewController

@synthesize flgSave,editingWord,dataModel,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        dataModel = [[AddWordModel alloc]init];

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

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([DELEGATE respondsToSelector:@selector(createMenu)]){
        [DELEGATE performSelector:@selector(createMenu)];
    }else{
        [self createMenu];
    }
}
- (void)viewDidLoad
{    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor clearColor]];
    if([DELEGATE respondsToSelector:@selector(createMenu)]){
        [DELEGATE performSelector:@selector(createMenu)];
    }else{
        [self createMenu];
    }
    [saveButton setHidden:YES];
    [textFld setDelegate:self];
    [translateFid setDelegate:self];   
    [textFld setFont:FONT_TEXT];
    [translateFid setFont:FONT_TEXT];    
    textFld.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:@"translateCountry"];
    translateFid.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:@"nativeCountry"];
    [textFld addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [translateFid addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
//    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
	[self setImageFlag];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    delegate = nil;
    [textFld release];
    textFld = nil;
    [translateFid release];
    translateFid = nil;
    [themeLbl release];
    themeLbl = nil;
    [saveButton release];
    saveButton = nil;
    [themeButton release];
    themeButton = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) loadData{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastThemeInAddView"] && !dataModel.currentWord) {
        [self showMyPickerView];
        return;
    }else if(!dataModel.wordType && !dataModel.currentWord){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"lastThemeInAddView"]];
        NSFetchedResultsController *fetches = [NSManagedObjectContext 
                                               getEntities:@"WordTypes" sortedBy:@"createDate" withPredicate:predicate];
        NSArray *types = [fetches fetchedObjects];
        if (types && [types count]>0) {
            dataModel.wordType = [[types objectAtIndex:0] retain];
            //[DELEGATE.navigationItem setPrompt:[NSString stringWithFormat:@"Current theme is %@",dataModel.wordType.name]];
            [themeLbl setText:[NSString stringWithFormat:NSLocalizedString(@"Current theme is %@", @""),dataModel.wordType.name]];
            [dataModel createWord];
            if (dataModel.currentWord) {
                [dataModel.currentWord setText:textFld.text];
                [dataModel.currentWord setTranslate:translateFid.text];
                [dataModel.currentWord setType:dataModel.wordType];
                [dataModel.currentWord setTypeID:dataModel.wordType.typeID];
            }
        }else{
            [self showMyPickerView];
        }
    }else if(dataModel.currentWord){
        textFld.text = dataModel.currentWord.text;
        translateFid.text = dataModel.currentWord.translate;
        [self textFieldDidChange:textFld];
        [self textFieldDidChange:translateFid];
        if (dataModel.wordType) {
            [themeLbl setText:[NSString stringWithFormat:NSLocalizedString(@"Current theme is %@", @""),dataModel.wordType.name]];
        }
    }
}

- (void)setText:(NSString*)text{
    if (self.flgSave) {
        dataModel.currentWord = nil;
        [dataModel createWord];
    }
    self.flgSave = NO;
    isDataChanged = YES;
    textFld.text = text;
    [dataModel.currentWord setText:text];
    [self textFieldDidChange:textFld];
}

- (void)setTranslate:(NSString*)text{
    if (self.flgSave) {
        dataModel.currentWord = nil;
        [dataModel createWord];
    }
    self.flgSave = NO;
    isDataChanged = YES;
    translateFid.text = text;
    [dataModel.currentWord setTranslate:text];
    [self textFieldDidChange:translateFid];
}

- (void)setWord:(Words *)_word{
    [saveButton setHidden:YES];
    [dataModel setWord:_word];
}

- (void)inputModeDidChange:(NSNotification*)notification
{
    id obj = [notification object];
    if ([obj respondsToSelector:@selector(inputModeLastUsedPreference)]) {
        id mode = [obj performSelector:@selector(inputModeLastUsedPreference)];
        NSLog(@"mode: %@", mode);
    }
}


- (void) setImageFlag{
    [self addRecButtonOnTextField:textFld];
    [self addRecButtonOnTextField:translateFid];
    NSString *path = [NSString stringWithFormat:@"%@.png", TRANSLATE_LANGUAGE_CODE];
	UIImageView *objImageEng = [[UIImageView alloc]initWithImage:[UIImage imageNamed:path]];
    [objImageEng setFrame:CGRectMake(0.0, 0.0, 20, 20)];
    path = [NSString stringWithFormat:@"%@.png", NATIVE_LANGUAGE_CODE];
	UIImageView *objImageRus = [[UIImageView alloc]initWithImage:[UIImage imageNamed:path]];
    [objImageRus setFrame:CGRectMake(0.0, 0.0, 20, 18)];
	[textFld setLeftView:objImageEng];
	[textFld setLeftViewMode:UITextFieldViewModeAlways];
	[translateFid setLeftView:objImageRus];
	[translateFid setLeftViewMode:UITextFieldViewModeAlways];
    objImageEng.layer.cornerRadius = 10.0;
    objImageRus.layer.cornerRadius = 5.0;
	[objImageRus release];
	[objImageEng release];
} 

- (void)addRecButtonOnTextField:(UITextField*)textField{
    UIButton *recButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [recButton addTarget:self 
                  action:@selector(recordPressed:)
        forControlEvents:UIControlEventTouchDown];
    [recButton setImage:[UIImage imageNamed:@"Voice 24x24.png"] forState:UIControlStateNormal];
    recButton.frame = CGRectMake(0.0, 0.0, 24, 24);
    [recButton setTag:textField.tag];
	[textField setRightView:recButton];
	[textField setRightViewMode:UITextFieldViewModeUnlessEditing];
    if ([textField.text length]==0) {
        [recButton setEnabled:NO];
    }
}


- (void) closeAllKeyboard{
    [textFld resignFirstResponder];
    [translateFid resignFirstResponder];
}

#pragma  mark picker protokol

- (IBAction) recordPressed:(id)sender{
    //[sender setHidden:YES];
    [self closeAllKeyboard];
    SoundType sounType;
    UITextField *currentTextField;
    if (((UIButton *)sender).tag == 101) {
        currentTextField = translateFid;
        if (!dataModel.currentWord.translate || [dataModel.currentWord.translate length] == 0) {
            [UIAlertView displayError:NSLocalizedString(@"You must choose a theme and enter a word before recording.", @"")];
            return;
        }
        sounType = TRANSLATE;
    }else{
        currentTextField = textFld;
        if (!dataModel.currentWord.text || [dataModel.currentWord.text length] == 0) {
            [UIAlertView displayError:NSLocalizedString(@"You must enter a word before recording.", @"")];
            return;
        }
        sounType = TEXT;
    }
    if (recordView) {
//        [recordView saveSound];
        [recordView release];
    }
    recordView = [[RecordingWordViewController alloc] initWithNibName:@"RecordFullView" bundle:nil] ;
    recordView.delegate = self;
    recordView.isDelayingSaving = YES;
    [self.view.superview addSubview:recordView.view];
    [recordView.view setFrame:CGRectMake(currentTextField.frame.origin.x+currentTextField.frame.size.width-currentTextField.rightView.frame.size.width, currentTextField.frame.origin.y, currentTextField.rightView.frame.size.width, currentTextField.rightView.frame.size.height)];
    recordView.soundType = sounType;
    [recordView setWord:dataModel.currentWord withType:sounType];
    [UIView beginAnimations:@"ShowOptionsView" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [recordView.view setFrame:CGRectMake(self.view.superview.center.x-105/2, self.view.superview.center.y-105/2, 105, 105)];
    [UIView commitAnimations];
}

- (IBAction) translatePressed:(id)sender{
    if ([translateFid.text length] == 0) {
        [dataModel loadTranslateText:textFld.text fromLanguageCode:TRANSLATE_LANGUAGE_CODE toLanguageCode:NATIVE_LANGUAGE_CODE withDelegate:self];
    }
    if ([textFld.text length] == 0) {
        [dataModel loadTranslateText:translateFid.text fromLanguageCode:NATIVE_LANGUAGE_CODE toLanguageCode:TRANSLATE_LANGUAGE_CODE withDelegate:self];
    }
}
    
- (void) recordViewDidClose:(id)sender{
}

- (IBAction) showMyPickerView{
    [self closeAllKeyboard];
    if (!myPicker) {
        myPicker = [[MyPickerViewContrller alloc] initWithNibName:@"MyPicker" bundle:nil];
        myPicker.delegate = self;
    }
    [myPicker openViewWithAnimation:DELEGATE.navigationController.view];
}

- (void) pickerDone:(WordTypes *)_wordType{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithString:_wordType.name] forKey:@"lastThemeInAddView"];
    dataModel.wordType = _wordType;
    if (!dataModel.currentWord) {
        [dataModel createWord];
    }
    //[DELEGATE.navigationItem setPrompt:[NSString stringWithFormat:@"Current theme is %@",dataModel.wordType.name]]; 
    [themeLbl setText:[NSString stringWithFormat:NSLocalizedString(@"Current theme is %@", @""),dataModel.wordType.name]];
    if (dataModel.currentWord) {
        [dataModel.currentWord setType:dataModel.wordType];
        [dataModel.currentWord setTypeID:dataModel.wordType.typeID];
    }
    self.title = _wordType.name;
}

- (void) pickerWillCansel{
    if (!dataModel.currentWord) {
        [dataModel createWord];
    }
}

- (BOOL)viewWillDisappear{
    if (!flgSave) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you want to save canges?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cansel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete canges", @"") otherButtonTitles: NSLocalizedString(@"Save changes", @""), nil];
        [actionSheet showInView:self.view];
        return NO;
    }
    return YES;
}

- (void) back{
    [self closeAllKeyboard];
    [UIAlertView removeMessage];
	if (flgSave) {
        //DELEGATE.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [DELEGATE.navigationController popViewControllerAnimated:YES];
	}
	else {
        if (!isDataChanged) {
            [self removeChanges];
            //DELEGATE.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            [DELEGATE.navigationController popViewControllerAnimated:YES];
            return;
        }
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you want to save canges?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete canges", @"") otherButtonTitles: NSLocalizedString(@"Save changes", @""), nil];
        [actionSheet showInView:DELEGATE.view];
	}
}

#pragma mark Alert functions

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[self save];
	}
	else if (buttonIndex == 0){
        [self removeChanges];
        //DELEGATE.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [DELEGATE.navigationController popViewControllerAnimated:YES];
	}
	else if (buttonIndex == 2){
		return;
	}
}

- (void)removeChanges{
    [self clear];
    isDataChanged = NO;
    [saveButton setHidden:YES];
    self.flgSave = YES;
    [dataModel removeChanges];
}

- (IBAction) save
{
    [self closeAllKeyboard];
    if ([textFld.text length]==0 && ([translateFid.text length]==0)) {
        [self removeChanges];
        return;
    }
    if (!dataModel.wordType) {
        [self showMyPickerView];
        return;
    }
    [dataModel.currentWord setDescriptionStr:dataModel.wordType.name];
    [dataModel.currentWord setText:textFld.text];
    [dataModel.currentWord setTranslate:translateFid.text];

    [dataModel saveWord];
	self.flgSave = YES;
    //[self back];
    
    [self hiddeSaveButton];
    [self clear];
}

- (void)clear{
    [textFld setText:@""];
    [translateFid setText:@""]; 
    UIButton *recButton = ((UIButton*)textFld.rightView);
    [recButton setEnabled:NO];
    recButton = ((UIButton*)translateFid.rightView);
    [recButton setEnabled:NO];
    [saveButton setHidden:YES];
}

#pragma mark textField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	if (textField == translateFid) {
		//[myTextFieldEng becomeFirstResponder];
	}
	else {
		[translateFid becomeFirstResponder];
	}
	return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField{    
    if (self.flgSave) {
        dataModel.currentWord = nil;
        [dataModel createWord];
    }
    self.flgSave = NO;
    isDataChanged = YES;
}


- (void)textFieldDidChange:(UITextField*)textField {
    [self showSaveButton];    
    if ([DELEGATE respondsToSelector:@selector(showWebLoadingView)]) {
        [DELEGATE performSelector:@selector(showWebLoadingView)];
    }
    [self updateFieldButtons];
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    NSString *text = [NSString stringWithString:textField.text];
    [text removeSpaces];
    if ([text length] == 0) {
        return;
    }
    if (textField == textFld) {
        [dataModel.currentWord setText:text];
    }else if (textField == translateFid) {
        [dataModel.currentWord setTranslate:text];
    }
    [self updateFieldButtons];
}

- (void)updateFieldButtons{
    UIButton *recTranslateButton = ((UIButton*)translateFid.rightView);
    UIButton *recTextButton = ((UIButton*)textFld.rightView);

    if ([textFld.text length]!=0 &&[translateFid.text length]==0) {
        [recTranslateButton setEnabled:YES];
        [recTextButton setEnabled:YES];
        [self changeFieldButton:recTranslateButton toState:0];
        [self changeFieldButton:recTextButton toState:1];
    }else if ([translateFid.text length]!=0 &&[textFld.text length]==0){
        [recTextButton setEnabled:YES];
        [recTranslateButton setEnabled:YES];
        [self changeFieldButton:recTextButton toState:0];
        [self changeFieldButton:recTranslateButton toState:1];
    }else if ([translateFid.text length]==0 &&[textFld.text length]==0){
        [recTextButton setEnabled:NO];
        [recTranslateButton setEnabled:NO];
        [self changeFieldButton:recTextButton toState:1];
        [self changeFieldButton:recTranslateButton toState:1];
    }else {
        [recTextButton setEnabled:YES];
        [recTranslateButton setEnabled:YES];
        [self changeFieldButton:recTextButton toState:1];
        [self changeFieldButton:recTranslateButton toState:1];
    }
}

- (void)changeFieldButton:(UIButton*)button toState:(int)state{
    UIImage *icon = [UIImage imageNamed:(state==0)?@"Search 24x24.png":@"Voice 24x24.png"];
    SEL selector = (state==0)?@selector(translatePressed:): @selector(recordPressed:);
    
    [button setImage:icon forState:UIControlStateNormal];
    [button removeTarget:nil 
                       action:NULL 
             forControlEvents:UIControlEventAllEvents];
    [button addTarget:self 
                      action:selector
            forControlEvents:UIControlEventTouchDown];

}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}

- (void)createMenu{
    [self becomeFirstResponder];
    NSMutableArray *menuItemsMutableArray = [NSMutableArray new];
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Use as translate", @"")
                                                       action:@selector(parceTranslateWord)] autorelease];
    UIMenuItem *menuTextParseItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Parse text", @"")
                                                                action:@selector(parseText)] autorelease];
    [menuItemsMutableArray addObject:menuItem];
    [menuItemsMutableArray addObject:menuTextParseItem];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect: CGRectMake(0, 0, 320, 200)
                           inView:self.view];
    menuController.menuItems = menuItemsMutableArray;
    [menuController setMenuVisible:YES
                          animated:YES];
    [[UIMenuController sharedMenuController] setMenuItems:menuItemsMutableArray];
    [menuItemsMutableArray release];
}

- (void)showSaveButton{
    if ([translateFid.text length]==0 && [textFld.text length]==0) {
        [saveButton setHidden:YES];
        isDataChanged = NO;
    }else{
        [saveButton setHidden:NO];
        [saveButton setFrame:CGRectMake(self.view.frame.size.width/4*3-18,87,35,35)]; 
    }
}

- (void)hiddeSaveButton{
    //make button animation
    [UIView beginAnimations:@"SaveButtonAnimation" context:nil];
    [UIView setAnimationDuration:5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [saveButton setFrame:CGRectMake(themeButton.center.x,themeButton.center.y,0,0)];
    [UIView commitAnimations];
}

#pragma mark loadingTranslate delegate functions

- (void)translateDidLoad:(NSString *)translateText byLanguageCode:(NSString*)_activeTranslateLanguageCode{
    if (translateText == nil) { 
        return;
    }
    if ([TRANSLATE_LANGUAGE_CODE isEqualToString:_activeTranslateLanguageCode]) {
        [self setText:translateText];
    }else{
        [self setTranslate:translateText];
    }
}

- (void)dealloc {
    if (myPicker) {
        [myPicker release];
    }
    if (recordView) {
        [recordView undoChngesWord];
        [recordView release];
    }
    [textFld release];
    [translateFid release];
    [dataModel release];
    delegate = nil;
    [themeLbl release];
    [saveButton release];
    [themeButton release];
    [super dealloc];
}
@end
