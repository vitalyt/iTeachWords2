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
#import "RecordingViewController.h"

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
    if([DELEGATE respondsToSelector:@selector(createMenu)]){
        [DELEGATE performSelector:@selector(createMenu)];
    }else{
        [self createMenu];
    }
    [textFld setDelegate:self];
    [translateFid setDelegate:self];   
    [textFld setFont:FONT_TEXT];
    [translateFid setFont:FONT_TEXT];    
    textFld.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY];
    translateFid.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY];
    [textFld addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [translateFid addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
//    [self.view setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    
	[self setImageFlag];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
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
    }else if(!dataModel.wordType){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"lastThemeInAddView"]];
        NSFetchedResultsController *fetches = [NSManagedObjectContext 
                                               getEntities:@"WordTypes" sortedBy:@"createDate" withPredicate:predicate];
        NSArray *types = [fetches fetchedObjects];
        if (types && [types count]>0) {
            dataModel.wordType = [[types objectAtIndex:0] retain];
            //[DELEGATE.navigationItem setPrompt:[NSString stringWithFormat:@"Current theme is %@",dataModel.wordType.name]];
            [themeLbl setText:[NSString stringWithFormat:@"Current theme is %@",dataModel.wordType.name]];
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
    }else if(dataModel.currentWord && dataModel.wordType){
        editingWord = YES;
        textFld.text = dataModel.currentWord.text;
        translateFid.text = dataModel.currentWord.translate;
        [self textFieldDidChange:textFld];
        [self textFieldDidChange:translateFid];
        //[DELEGATE.navigationItem setPrompt:[NSString stringWithFormat:@"Current theme is %@",dataModel.wordType.name]]; 
        [themeLbl setText:[NSString stringWithFormat:@"Current theme is %@",dataModel.wordType.name]];
    }
}

- (void)setText:(NSString*)text{
    [dataModel createWord];
    textFld.text = text;
    [dataModel.currentWord setText:text];
    [self textFieldDidChange:textFld];
}

- (void)setTranslate:(NSString*)text{
    [dataModel createWord];
    translateFid.text = text;
    [dataModel.currentWord setTranslate:text];
    [self textFieldDidChange:translateFid];
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
    NSString *path = [NSString stringWithFormat:@"%@.png", [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE]];
	UIImageView *objImageEng = [[UIImageView alloc]initWithImage:[UIImage imageNamed:path]];
    [objImageEng setFrame:CGRectMake(0.0, 0.0, 20, 20)];
    path = [NSString stringWithFormat:@"%@.png", [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE]];
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
	[textField setRightViewMode:UITextFieldViewModeAlways];
    if ([textField.text length]==0) {
        [recButton setEnabled:NO];
    }
}

- (void)setWord:(Words *)_word{
    [dataModel setWord:_word];
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
            [UIAlertView displayError:@"You must enter a word or choose a theme before recording."];
            return;
        }
        sounType = TRANSLATE;
    }else{
        currentTextField = textFld;
        if (!dataModel.currentWord.text || [dataModel.currentWord.text length] == 0) {
            [UIAlertView displayError:@"You must enter a word before recording."];
            return;
        }
        sounType = TEXT;
    }
    if (recordView) {
        [recordView saveSound];
        [recordView release];
    }
    recordView = [[RecordingViewController alloc] initWithNibName:@"RecordFullView" bundle:nil] ;
    recordView.delegate = self;
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

- (void) recordViewDidClose:(id)sender{
}

- (IBAction) showMyPickerView{
    [translateFid resignFirstResponder];
    [textFld resignFirstResponder];
    if (!myPicker) {
        myPicker = [[MyPickerViewContrller alloc] initWithNibName:@"MyPicker" bundle:nil];
        myPicker.delegate = self;
    }
    [myPicker openViewWithAnimation:DELEGATE.navigationController.view];
}

- (void) pickerDone:(WordTypes *)_wordType{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithString:_wordType.name] forKey:@"lastThemeInAddView"];
    dataModel.wordType = _wordType;
    [dataModel createWord];
    //[DELEGATE.navigationItem setPrompt:[NSString stringWithFormat:@"Current theme is %@",dataModel.wordType.name]]; 
    [themeLbl setText:[NSString stringWithFormat:@"Current theme is %@",dataModel.wordType.name]];
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


- (void) back{
	if (flgSave) {
        DELEGATE.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [DELEGATE.navigationController popViewControllerAnimated:YES];
	}
	else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you want save word?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cansel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete canges", @"") otherButtonTitles: NSLocalizedString(@"Save changes", @""), nil];
        [actionSheet showInView:self.view];
	}
}

#pragma mark Alert functions

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if (buttonIndex == 1) {
		[self save];
	}
	else if (buttonIndex == 0){
        [self removeChanges];
        DELEGATE.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
        [DELEGATE.navigationController popViewControllerAnimated:YES];
	}
	else if (buttonIndex == 2){
		return;
	}
}

- (void)removeChanges{
    [dataModel.wordType removeWordsObject:dataModel.currentWord];
}

- (IBAction) save
{
    [self closeAllKeyboard];
    [dataModel.currentWord setDescriptionStr:dataModel.wordType.name];
    [dataModel.currentWord setText:textFld.text];
    [dataModel.currentWord setTranslate:translateFid.text];
    NSError *_error;
    if (![CONTEXT save:&_error]) {
        [UIAlertView displayError:@"Data is not saved."];
    }else{
        // [UIAlertView displayMessage:@"Data is saved."];
        dataModel.currentWord = nil;
        [dataModel createWord];
    }
	self.flgSave = YES;
    //[self back];
    [UIView beginAnimations:@"SaveButtonAnimation" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [saveButton setFrame:CGRectMake(themeButton.center.x,themeButton.center.y,0,0)];
    [UIView commitAnimations];
}

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
    self.flgSave = NO;
}


- (void)textFieldDidChange:(UITextField*)textField {
    [saveButton setFrame:CGRectMake(self.view.frame.size.width/2+11,11,0,0)];
//    [UIView beginAnimations:@"SButtonAnimation" context:nil];
//    [UIView setAnimationDuration:0.5];
//    [UIView setAnimationBeginsFromCurrentState:YES];
    [saveButton setFrame:CGRectMake(self.view.frame.size.width/2+11,11,self.view.frame.size.width/2-22,37)];
//    [UIView commitAnimations];
    
    if ([DELEGATE respondsToSelector:@selector(showWebLoadingView)]) {
        [DELEGATE performSelector:@selector(showWebLoadingView)];
    }
    self.flgSave = NO;
    UIButton *recButton = ((UIButton*)textField.rightView);
    if ([textField.text length]==0) {
        [recButton setEnabled:NO];
    }else{
        [recButton setEnabled:YES];
    }
}

- (void) textFieldDidEndEditing:(UITextField *)textField{
    NSString *text = [NSString stringWithString:textField.text];
    [text removeSpaces];
    if ([text length] == 0) {
        return;
    }
    if (textField.tag == 100) {
        NSString *translateText = [text translateString];
        [self setTranslate:translateText];
    }
    if (textField == textFld) {
        [dataModel.currentWord setText:text];
    }else if (textField == translateFid) {
        [dataModel.currentWord setTranslate:text];
    }
}


- (void)createMenu{
    [self becomeFirstResponder];
    NSMutableArray *menuItemsMutableArray = [NSMutableArray new];
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:@"use as translate"
                                                       action:@selector(parceTranslateWord)] autorelease];
    UIMenuItem *menuTextParseItem = [[[UIMenuItem alloc] initWithTitle:@"Parse text"
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


- (void)dealloc {
    if (myPicker) {
        [myPicker release];
    }
    delegate = nil;
    [textFld release];
    [translateFid release];
    [dataModel release];
    [themeLbl release];
    [saveButton release];
    [themeButton release];
    [super dealloc];
}
@end
