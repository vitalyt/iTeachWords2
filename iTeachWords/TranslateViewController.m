//
//  TranslateViewController.m
//  TranslatingViewTestProject
//
//  Created by Vitalii Todorovych on 18.04.13.
//  Copyright (c) 2013 Vitalii Todorovych. All rights reserved.
//

#import "TranslateViewController.h"
#import "UIViewController+KNSemiModal.h"
#import "SemiWebViewController.h"
#import "JSON.h"
#import "MyPickerViewContrller.h"
#import "WordTypes.h"
#import "Words.h"
#import "RecordingWordViewController.h"
#import "WebViewController.h"
#import "LanguageFlagImageView.h"

#define DELEGATE ((UIViewController*)_delegate)
#define OFFSET_VALUE 50
#define TOP_BORDER_OFFSET_VALUE 20
#define ANIMATION_DURATION .3

@interface TranslateViewController ()

@end

@implementation TranslateViewController

@synthesize delegate = _delegate;
@synthesize flgSave = _flgSave;
@synthesize editingWord = _editingWord;
@synthesize dataModel = _dataModel;

- (void)dealloc {
    _delegate = nil;
    [_dataModel release];
    _dataModel = nil;
    [themeLbl release];
    themeLbl = nil;
    [saveButton release];
    saveButton = nil;
    [themeButton release];
    themeButton = nil;
    [myPicker release];
    myPicker = nil;
    if (recordView) {
        [recordView undoChngesWord];
        [recordView release];
        recordView = nil;
    }
    [semiWebViewController release];
    [_engTextView release];
    [_rusTextView release];
    [scrollView release];
    [engContainerView release];
    [rusContainerView release];
    [engFlagImageView release];
    [rusFlagImageView release];
    [engRecordBtn release];
    [rusRecordBtn release];
    [engSearchBtn release];
    [rusSearchBtn release];
    [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataModel = [[AddWordModel alloc]init];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if([DELEGATE respondsToSelector:@selector(createMenu)]){
        [DELEGATE performSelector:@selector(createMenu)];
    }else{
        [self createMenu];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    interfaceOffset = 0.0;
    [self customizeViews];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [saveButton setHidden:YES];
    [self.engTextView setFont:FONT_TEXT];
    [self.rusTextView setFont:FONT_TEXT];
    self.engTextView.contentInset = UIEdgeInsetsMake(25,0,0,0);
    self.rusTextView.contentInset = UIEdgeInsetsMake(25,0,0,0);
//    self.engTextView.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:@"translateCountry"];
//    self.rusTextView.placeholder = [[NSUserDefaults standardUserDefaults] objectForKey:@"nativeCountry"];
//    [self.engTextView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self.rusTextView addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self loadData];
}

- (BOOL)isLandscapeMode{
    return NO;
}

#pragma mark customization
- (void)customizeViews{
    [self customizeTextViews];
    [self createFlagsView];
    [self customiseControlButtons];
}

- (void)createFlagsView{
    //set images
    NSDictionary *translateCountryInfo = TRANSLATE_COUNTRY_INFO;
    NSDictionary *nativeCountryInfo = NATIVE_COUNTRY_INFO;
    [engFlagImageView setCountryCode:[translateCountryInfo objectForKey:@"firstCode"]];
    [engFlagImageView setCountryCode:[nativeCountryInfo objectForKey:@"firstCode"]];
    [self customiseFlagImageView:engFlagImageView];
    [self customiseFlagImageView:rusFlagImageView];
}

- (void)customizeTextViews{
    self.engTextView.layer.cornerRadius = 5.0;
    self.engTextView.clipsToBounds = YES;
    self.rusTextView.layer.cornerRadius = 5.0;
    self.rusTextView.clipsToBounds = YES;    
//    self.rusTextView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.rusTextView.layer.shadowOffset = CGSizeMake(1.0f, .0f);
//    self.rusTextView.layer.shadowOpacity = 1.0f;
//    self.rusTextView.layer.shadowRadius = 5.0f;
}

- (void)customiseFlagImageView:(UIView*)flagImageView{
    //add cornerRadius
//    flagImageView.layer.masksToBounds = YES;
//    flagImageView.layer.cornerRadius = 3.0;
    
    //add shadew
    [flagImageView setBackgroundColor:[UIColor clearColor]];
    flagImageView.layer.shadowRadius = 3.0;
    flagImageView.clipsToBounds = NO;
    flagImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    flagImageView.layer.shadowOffset = CGSizeMake(0, 1);
    flagImageView.layer.shadowOpacity = 1;
    flagImageView.layer.shadowRadius = [LanguageFlagImageView cornerRadius];
}

- (void)customiseControlButtons{
    BOOL isEngText = (self.engTextView.text.length > 0)?YES:NO;
    BOOL isRusText = (self.rusTextView.text.length > 0)?YES:NO;
    [engRecordBtn setEnabled:isEngText];
    [engSearchBtn setEnabled:isEngText];
    [rusRecordBtn setEnabled:isRusText];
    [rusSearchBtn setEnabled:isRusText];
}

#pragma mark TextView delegating
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView == self.rusTextView || textView == self.engTextView) {
        [self changeTextViewsPositionIfNeedWithEditingTextView:textView];
        if (self.flgSave) {
            _dataModel.currentWord = nil;
            [_dataModel createWord];
        }
        self.flgSave = NO;
        isDataChanged = YES;
    }
    [recordView saveSound:nil];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    NSString *text = [NSString stringWithString:textView.text];
    text = [NSString removeSpaces:text];
    if ([text length] == 0) {
        return;
    }
    if (textView == self.engTextView) {
        [_dataModel.currentWord setText:text];
    }else if (textView == self.rusTextView) {
        [_dataModel.currentWord setTranslate:text];
    }
    if (textView == self.rusTextView || textView == self.engTextView) {
        [self resetTextViewsReplacement];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@" "] ||
       [text isEqualToString:@"."] ||
       [text isEqualToString:@","]) {
        //do translate loading
        
        return YES;
    }
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{    
    [self customiseControlButtons];
    [self showSaveButton];
    if ([DELEGATE respondsToSelector:@selector(showWebLoadingView)]) {
        [DELEGATE performSelector:@selector(showWebLoadingView)];
    }
}

#pragma mark textView Replacement
- (IBAction)makeReplacementTextViews:(id)sender {
    [self.view endEditing:YES];
    [self resetTextViewsReplacement];
    CGRect engContainerViewFrame = engContainerView.frame;
    CGRect rusContainerViewFrame = rusContainerView.frame;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^(){
        [rusContainerView setFrame:engContainerViewFrame];
        [engContainerView setFrame:rusContainerViewFrame];
    }];
    isReplasmentViewsMode = !isReplasmentViewsMode;
}

-(SemiWebViewController*)webView{
    if (!semiWebViewController) {
        semiWebViewController = [[SemiWebViewController alloc] initWithNibName:@"SemiWebViewController" bundle:nil];
    }
    return semiWebViewController;
}

- (IBAction)searchClicked:(id)sender {
    [self presentSemiViewController:[self webView] withOptions:@{
     KNSemiModalOptionKeys.pushParentBack    : @(YES),
     KNSemiModalOptionKeys.animationDuration : @(0.3),
     KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
	 }];
    NSString *nativeLaguage = @"";
    NSString *learningLaguage = @"";
    NSString *textLnguage = @"";
    if(sender == engSearchBtn){
        nativeLaguage = @"en";
        learningLaguage = @"ru";
        textLnguage = self.engTextView.text;
    }else if(sender == rusSearchBtn){
        nativeLaguage = @"ru";
        learningLaguage = @"en";
        textLnguage = self.rusTextView.text;
    }
    NSString *urlShow = [[[NSString alloc] initWithFormat: @"http://translate.google.com/?hl=%@&sl=%@&tl=%@&ie=UTF-8&prev=_m&q=%@",
                          learningLaguage,
                          nativeLaguage,
                          learningLaguage,textLnguage] autorelease];
    [[self webView] loadWebViewWithUrl:urlShow];
    [self.view endEditing:YES];
}

- (void)showWordsUseVariants:(id)sender{
    [self.view endEditing:YES];
    NSString *nativeLaguage = @"";
    NSString *learningLaguage = @"";
    NSString *textLnguage = @"";
    if(sender == engRecordBtn){
        nativeLaguage = @"en";
        learningLaguage = @"ru";
        textLnguage = self.engTextView.text;
    }else if(sender == rusRecordBtn){
        nativeLaguage = @"ru";
        learningLaguage = @"en";
        textLnguage = self.rusTextView.text;
    }
    @try {
        NSString *urlShow = [NSString stringWithFormat:@"http://translate.google.com/translate_a/ex?key=%@&sl=%@&tl=%@&q=%@&utrans=news",@"AIzaSyDL0K_RUzws8KQLHAdlcj75YZYLWDoj1BQ",nativeLaguage,learningLaguage,textLnguage];
        NSString *responseString = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:urlShow] encoding:NSUTF8StringEncoding error:nil];
        if (!responseString) {
            return;
        }
        NSMutableArray *luckyNumbers = [responseString JSONValue];
        [responseString release];
        
        NSMutableString *mutableHtmlStr = [[NSMutableString alloc] init];
        [mutableHtmlStr appendFormat:@"<HTML><BODY>"];
        for (NSArray *ar in luckyNumbers) {
            for (NSArray *ar1 in ar) {
                for (NSArray *ar2 in ar1) {
                    [mutableHtmlStr appendFormat:@"%@",[ar2 objectAtIndex:0]];
                    [mutableHtmlStr appendFormat:@"<br>"];
                    [mutableHtmlStr appendFormat:@"%@",[ar2 objectAtIndex:3]];
                    [mutableHtmlStr appendFormat:@"<hr>"];
                }
            }
        }
        [mutableHtmlStr appendFormat:@"</BODY></HTML>"];
        
        [self presentSemiViewController:[self webView] withOptions:@{
         KNSemiModalOptionKeys.pushParentBack    : @(YES),
         KNSemiModalOptionKeys.animationDuration : @(0.3),
         KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
         }];
        [[self webView] loadWebViewWithHtml:mutableHtmlStr];
        [mutableHtmlStr release];
    }
    @catch (NSException *exception) {
        [[self webView] dismissSemiModalView];
    }

}

- (void)changeTextViewsPositionIfNeedWithEditingTextView:(UITextView*)editingTextView{
    CGRect containerViewFrame = (isReplasmentViewsMode)?engContainerView.frame:rusContainerView.frame;
    float offset = containerViewFrame.origin.y - TOP_BORDER_OFFSET_VALUE;
    if ((interfaceOffset >= offset) ||
        (isReplasmentViewsMode && editingTextView == self.rusTextView) ||
        (!isReplasmentViewsMode && editingTextView == self.engTextView)){
        return;
    }
    offset -= interfaceOffset;
    CGSize scrollViewContentSize = scrollView.contentSize;
    CGPoint scrollViewContentOffset = scrollView.contentOffset;
    scrollViewContentSize.height += offset;
    scrollViewContentOffset.y += offset;
    [scrollView setContentOffset:CGPointMake(0, offset)];
    
    [UIView animateWithDuration:ANIMATION_DURATION animations:^(){
        scrollView.contentSize = scrollViewContentSize;
        scrollView.contentOffset = scrollViewContentOffset;
        interfaceOffset += offset;
    }];
}

- (void)resetTextViewsReplacement{
//    float offset = ((isReplasmentViewsMode)?self.engTextView.frame.origin.y:self.rusTextView.frame.origin.y) - TOP_BORDER_OFFSET_VALUE;
    CGSize scrollViewContentSize = scrollView.contentSize;
    CGPoint scrollViewContentOffset = scrollView.contentOffset;
    scrollViewContentSize.height -= interfaceOffset;
    scrollViewContentOffset.y = 0;
    [UIView animateWithDuration:ANIMATION_DURATION animations:^(){
        scrollView.contentSize = scrollViewContentSize;
        scrollView.contentOffset = scrollViewContentOffset;
        interfaceOffset = 0;
    }];
}






- (void) loadData{
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"lastThemeInAddView"] && !_dataModel.currentWord) {
        [self showMyPickerView:nil];
        return;
    }else if(!_dataModel.wordType && !_dataModel.currentWord){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"lastThemeInAddView"]];
        NSFetchedResultsController *fetches = [NSManagedObjectContext
                                               getEntities:@"WordTypes" sortedBy:@"createDate" withPredicate:predicate];
        NSArray *types = [fetches fetchedObjects];
        if (types && [types count]>0) {
            _dataModel.wordType = [[types objectAtIndex:0] retain];
            [themeLbl setText:[NSString stringWithFormat:NSLocalizedString(@"Current theme is %@", @""),_dataModel.wordType.name]];
            [_dataModel createWord];
            if (_dataModel.currentWord) {
                [_dataModel.currentWord setText:self.engTextView.text];
                [_dataModel.currentWord setTranslate:self.rusTextView.text];
                [_dataModel.currentWord setType:_dataModel.wordType];
                [_dataModel.currentWord setTypeID:_dataModel.wordType.typeID];
            }
        }else{
            [self showMyPickerView:nil];
        }
    }else if(_dataModel.currentWord){
        self.engTextView.text = _dataModel.currentWord.text;
        self.rusTextView.text = _dataModel.currentWord.translate;
        [self textViewDidChange:self.engTextView];
        [self textViewDidChange:self.rusTextView];
        if (_dataModel.wordType) {
            [themeLbl setText:[NSString stringWithFormat:NSLocalizedString(@"Current theme is %@", @""),_dataModel.wordType.name]];
        }
    }
}

- (void)setText:(NSString*)text{
    if (self.flgSave) {
        _dataModel.currentWord = nil;
        [_dataModel createWord];
    }
    self.flgSave = NO;
    isDataChanged = YES;
    self.engTextView.text = text;
    [_dataModel.currentWord setText:text];
    [self textViewDidChange:self.engTextView];
}

- (void)setTranslate:(NSString*)text{
    if (self.flgSave) {
        _dataModel.currentWord = nil;
        [_dataModel createWord];
    }
    self.flgSave = NO;
    isDataChanged = YES;
    self.rusTextView.text = text;
    [_dataModel.currentWord setTranslate:text];
    [self textViewDidChange:self.rusTextView];
}

- (void)setWord:(Words *)_word{
    [saveButton setHidden:YES];
    [_dataModel setWord:_word];
}


#pragma  mark picker protokol
- (IBAction) recordPressed:(id)sender{
    [self.view endEditing:YES];
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
    //[sender setHidden:YES];
    SoundType sounType;
    UITextView *currentTextField;
    if (((UIButton *)sender).tag == 101) {
        currentTextField = self.rusTextView;
        if (!_dataModel.currentWord.translate || [_dataModel.currentWord.translate length] == 0) {
            [UIAlertView displayError:NSLocalizedString(@"You must choose a theme and enter a word before recording.", @"")];
            return;
        }
        sounType = TRANSLATE;
    }else{
        currentTextField = self.engTextView;
        if (!_dataModel.currentWord.text || [_dataModel.currentWord.text length] == 0) {
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
    CGRect recordBtnFrame = (sounType = TRANSLATE)?rusRecordBtn.frame:engRecordBtn.frame;
    [recordView.view setFrame:CGRectMake(recordBtnFrame.origin.x + recordBtnFrame.size.width/2,
                                         recordBtnFrame.origin.y+44,
                                         recordBtnFrame.size.width,
                                         recordBtnFrame.size.height)];
    recordView.soundType = sounType;
    [recordView setWord:_dataModel.currentWord withType:sounType];
    [UIView beginAnimations:@"ShowOptionsView" context:nil];
    [UIView setAnimationDuration:.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [recordView.view setFrame:CGRectMake(self.view.superview.center.x-105/2, self.view.superview.center.y-105/2, 105, 105)];
    [UIView commitAnimations];
}

- (IBAction) translatePressed:(id)sender{
    [self.view endEditing:YES];
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        ((UIButton*)_currentSelectedObject).tag = 2;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
    if ([self.rusTextView.text length] == 0) {
        [_dataModel loadTranslateText:self.engTextView.text fromLanguageCode:TRANSLATE_LANGUAGE_CODE toLanguageCode:NATIVE_LANGUAGE_CODE withDelegate:self];
    }
    if ([self.engTextView.text length] == 0) {
        [_dataModel loadTranslateText:self.rusTextView.text fromLanguageCode:NATIVE_LANGUAGE_CODE toLanguageCode:TRANSLATE_LANGUAGE_CODE withDelegate:self];
    }
}

- (void) recordViewDidClose:(id)sender{
    if (recordView) {
        [recordView release];
        recordView = nil;
    }
}

- (IBAction) showMyPickerView:(id)sender{
    [self.view endEditing:YES];
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
    _dataModel.wordType = _wordType;
    if (!_dataModel.currentWord) {
        [_dataModel createWord];
    }
    //[DELEGATE.navigationItem setPrompt:[NSString stringWithFormat:@"Current theme is %@",_dataModel.wordType.name]];
    [themeLbl setText:[NSString stringWithFormat:NSLocalizedString(@"Current theme is %@", @""),_dataModel.wordType.name]];
    if (_dataModel.currentWord) {
        [_dataModel.currentWord setType:_dataModel.wordType];
        [_dataModel.currentWord setTypeID:_dataModel.wordType.typeID];
    }
    self.title = _wordType.name;
}

- (void) pickerWillCansel{
    if (!_dataModel.currentWord) {
        [_dataModel createWord];
    }
}

- (BOOL)viewWillDisappear{
    if (!_flgSave) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:NSLocalizedString(@"Do you want to save canges?", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"Cansel", @"") destructiveButtonTitle:NSLocalizedString(@"Delete canges", @"") otherButtonTitles: NSLocalizedString(@"Save changes", @""), nil];
        [actionSheet showInView:self.view];
        return NO;
    }
    return YES;
}

- (void) back{
    [self.view endEditing:YES];
    [UIAlertView removeMessage];
	if (_flgSave) {
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
    [_dataModel removeChanges];
}

- (IBAction) save:(id)sender
{
    if (IS_HELP_MODE && sender && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
    [self.view endEditing:YES];
    if ([self.engTextView.text length]==0 && ([self.rusTextView.text length]==0)) {
        [self removeChanges];
        return;
    }
    if (!_dataModel.wordType) {
        [self showMyPickerView:nil];
        return;
    }
    [_dataModel.currentWord setDescriptionStr:_dataModel.wordType.name];
    [_dataModel.currentWord setText:self.engTextView.text];
    [_dataModel.currentWord setTranslate:self.rusTextView.text];
    
    [_dataModel saveWord];
	self.flgSave = YES;
    //[self back];
    
    [self hiddeSaveButton];
    [self performSelector:@selector(clear) withObject:nil afterDelay:0.3];
}

- (void)clear{
    [self.engTextView setText:@""];
    [self.rusTextView setText:@""];
    [rusRecordBtn setEnabled:NO];
    [engRecordBtn setEnabled:NO];
    [saveButton setHidden:YES];
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
    NSString *text = self.engTextView.text;
    NSString *translate = self.rusTextView.text;
    text = [NSString removeSpaces:text];
    translate = [NSString removeSpaces:translate];
    
    if ([translate length]==0 && [text length]==0) {
        [saveButton setHidden:YES];
        isDataChanged = NO;
    }else{
        [saveButton setHidden:NO];
        [saveButton setFrame:CGRectMake(self.view.frame.size.width/4*3-18,1,41,41)];
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

@end
