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

	[self setImageFlag];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void) loadData{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastThemeInAddView"] && !dataModel.currentWord) {
        [self showMyPickerView:nil];
        return;
    }else if(!dataModel.wordType && !dataModel.currentWord){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"lastThemeInAddView"]];
        NSFetchedResultsController *fetches = [NSManagedObjectContext 
                                               getEntities:@"WordTypes" sortedBy:@"createDate" withPredicate:predicate];
        NSArray *types = [fetches fetchedObjects];
        if (types && [types count]>0) {
            dataModel.wordType = [[types objectAtIndex:0] retain];
            [themeLbl setText:[NSString stringWithFormat:NSLocalizedString(@"Current theme is %@", @""),dataModel.wordType.name]];
            [dataModel createWord];
            if (dataModel.currentWord) {
                [dataModel.currentWord setText:textFld.text];
                [dataModel.currentWord setTranslate:translateFid.text];
                [dataModel.currentWord setType:dataModel.wordType];
                [dataModel.currentWord setTypeID:dataModel.wordType.typeID];
            }
        }else{
            [self showMyPickerView:nil];
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

- (void) setImageFlag{
    [self addRecButtonOnTextField:textFld];
    [self addRecButtonOnTextField:translateFid];
    NSDictionary *translateCountryInfo = TRANSLATE_COUNTRY_INFO;
    NSDictionary *nativeCountryInfo = NATIVE_COUNTRY_INFO;

    NSString *path = [NSString stringWithFormat:@"%@.png", [translateCountryInfo objectForKey:@"firstCode"]];
	UIImageView *objImageEng = [[UIImageView alloc]initWithImage:[UIImage imageNamed:path]];
    [objImageEng setFrame:CGRectMake(0.0, 0.0, 20, 20)];
    path = [NSString stringWithFormat:@"%@.png", [nativeCountryInfo objectForKey:@"firstCode"]];
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
    [self closeAllKeyboard];
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
    //[sender setHidden:YES];
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
        [recordView saveSound:nil];
        [recordView release];
        recordView = nil;
    }
    recordView = [[RecordingWordViewController alloc] initWithNibName:@"RecordFullView" bundle:nil] ;
    recordView.delegate = self;
//    recordView.isDelayingSaving = YES;
    [self.view.superview addSubview:recordView.view];
    
    [recordView.view setFrame:CGRectMake(currentTextField.frame.origin.x+currentTextField.frame.size.width-currentTextField.rightView.frame.size.width, currentTextField.frame.origin.y+44, currentTextField.rightView.frame.size.width, currentTextField.rightView.frame.size.height)];
    recordView.soundType = sounType;
    [recordView setWord:dataModel.currentWord withType:sounType];
    [UIView beginAnimations:@"ShowOptionsView" context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [recordView.view setFrame:CGRectMake(self.view.superview.center.x-105/2, self.view.superview.center.y-105/2, 105, 105)];
    [UIView commitAnimations];
}

- (IBAction) translatePressed:(id)sender{
    [self closeAllKeyboard];
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        ((UIButton*)_currentSelectedObject).tag = 2;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
    if ([translateFid.text length] == 0) {
        [dataModel loadTranslateText:textFld.text fromLanguageCode:TRANSLATE_LANGUAGE_CODE toLanguageCode:NATIVE_LANGUAGE_CODE withDelegate:self];
    }
    if ([textFld.text length] == 0) {
        [dataModel loadTranslateText:translateFid.text fromLanguageCode:NATIVE_LANGUAGE_CODE toLanguageCode:TRANSLATE_LANGUAGE_CODE withDelegate:self];
    }
}
    
- (void) recordViewDidClose:(id)sender{
    if (recordView) {
        [recordView release];
        recordView = nil;
    }
}

- (IBAction) showMyPickerView:(id)sender{
    [self closeAllKeyboard];
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
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
		[self save:nil];
	}
	else if (buttonIndex == 0){
        [self removeChanges];
        //DELEGATE.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        if (recordView) {
            [recordView saveSound:nil];
            [recordView release];
            recordView = nil;
        }
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

- (IBAction) save:(id)sender
{
    if (IS_HELP_MODE && sender && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
    [self closeAllKeyboard];
    if ([textFld.text length]==0 && ([translateFid.text length]==0)) {
        [self removeChanges];
        return;
    }
    if (!dataModel.wordType) {
        [self showMyPickerView:nil];
        return;
    }
    [dataModel.currentWord setDescriptionStr:dataModel.wordType.name];
    [dataModel.currentWord setText:textFld.text];
    [dataModel.currentWord setTranslate:translateFid.text];

    [dataModel saveWord];
	self.flgSave = YES;
    //[self back];
    
    [self hiddeSaveButton];
    [self performSelector:@selector(clear) withObject:nil afterDelay:0.3];
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
    [recordView close:nil];
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
    text = [NSString removeSpaces:text];
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
    SEL selector = (state==0)?@selector(translatePressed:):@selector(recordPressed:);
    
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
                                                                action:@selector(parseText:)] autorelease];
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
    NSString *text = textFld.text;
    NSString *translate = translateFid.text;
    text = [NSString removeSpaces:text];
    translate = [NSString removeSpaces:translate];
    
    if ([translate length]==0 && [text length]==0) {
        [saveButton setHidden:YES];
        isDataChanged = NO;
    }else{
        [saveButton setHidden:NO];
        [saveButton setFrame:CGRectMake(self.view.frame.size.width/4*3-18,87,41,41)]; 
    }
}

- (void)hiddeSaveButton{
    //make button animation
    [UIView beginAnimations:@"SaveButtonAnimation" context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [saveButton setFrame:CGRectMake(themeButton.center.x,themeButton.center.y,10,10)];
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



-(UIView*)hintStateViewForDialog:(id)hintState
{
    CGRect frame = self.view.superview.frame;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height/4*2, frame.size.width-20, frame.size.height/4)];
    l.numberOfLines = 4;
    [l setTextAlignment:UITextAlignmentCenter];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:[self helpMessageForButton:_currentSelectedObject]];
    return l;
}

- (NSString*)helpMessageForButton:(id)_button{
    NSString *message = nil;
    int index = ((UIBarButtonItem*)_button).tag;
    switch (index) {
        case 0:
            message = NSLocalizedString(@"Выбор словаря", @"");
            break;
        case 1:
            message = NSLocalizedString(@"Сохранение слова", @"");
            break;
        case 2:
            message = NSLocalizedString(@"Поиск перевода в интернете", @"");
            break;
        case 101:
        case 100:
            message = NSLocalizedString(@"Озвучивание слова", @"");
            break;
        default:
            break;
    }
    return message;
}

-(UIView*)hintStateViewToHint:(id)hintState
{
    NSLog(@"%@",usedObjects);
    NSLog(@"%@",_currentSelectedObject);
    [usedObjects addObject:_currentSelectedObject];
    UIView *buttonView = nil;
    UIView *view = _currentSelectedObject;
    CGRect frame = view.frame;
    CGRect buttonFrame;
    int index = ((UIBarButtonItem*)_currentSelectedObject).tag;
    buttonFrame = CGRectMake(frame.origin.x+self.view.frame.origin.x, frame.origin.y+self.view.frame.origin.y, frame.size.width, frame.size.height);
    if (index == 2 || index == 100 || index == 101) {
        buttonFrame = CGRectMake(frame.origin.x+self.view.frame.origin.x+view.superview.frame.origin.x, frame.origin.y+self.view.frame.origin.y+view.superview.frame.origin.y, frame.size.width, frame.size.height);
    }
    buttonView = [[[UIView alloc] initWithFrame:frame] autorelease];
    [buttonView setFrame:buttonFrame];
    return buttonView;
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

- (void)dealloc {
    [myPicker release];
    myPicker = nil;
    if (recordView) {
        [recordView undoChngesWord];
        [recordView release];
        recordView = nil;
    }
    [dataModel release];
    dataModel = nil;
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
    [super dealloc];
}
@end
