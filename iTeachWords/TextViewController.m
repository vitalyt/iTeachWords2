//
//  TextViewController.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/25/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "TextViewController.h"
#import "StringTools.h"
//#import "myButtonPlayer.h"
#import "LanguagePickerController.h"
#import "NewWordsTable.h"
#import "PagesScrollView.h"

#ifdef FREE_VERSION
#import "PurchasesDetailViewController.h"
#import "QQQInAppStore.h"
#endif

#define radius 10
#define textFieldHieght 371

@implementation TextViewController
@synthesize array;
@synthesize arrayCount;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self  = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
                                                   initWithTitle:NSLocalizedString(@"Parse text", @"") style:UIBarButtonItemStyleBordered 
                                                   target:self 
                                                   action:@selector(showTable)] autorelease];
        [self createMenu];
    }
    return self;
}

-(id) initWithTabBar {
	if ([self init]) {
		//метка на кнопке собственно вкладки
		self.title = @"Text translate";
		//добавьте к проекту любое изображение
		self.tabBarItem.image = [UIImage imageNamed:@"40-inbox.png"];
	}
	return self;
}

- (void)dealloc {
    [navSC release];
    navSC = nil;
    [loadingView release];
    [pagesScrollView release];
    [myTextView release];
	[array release];
    [super dealloc];
}

- (void) loadView{
    [super loadView];
    myTextView.layer.cornerRadius = radius;
    myTextView.layer.borderWidth = 2.0f;
    myTextView.layer.borderColor = [[UIColor grayColor] CGColor];
    pagesScrollView = [[PagesScrollView alloc] initWithNibName:@"PagesScrollView" bundle:nil];
    [pagesScrollView setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)customizeTextView:(UITextView*)textView{
    CGRect frame = CGRectMake(10.0f/21.0f, 10.0f/21.0f, 1.0f/21.0f, 1.0f/21.0f);
    textView.layer.contents = (id)[UIImage imageNamed: @"innershadow.png"].CGImage;
    textView.layer.contentsCenter = frame;
    textView.layer.cornerRadius = 5.0;
    textView.clipsToBounds = YES;
    [textView setFont:FONT_TEXT];
    [textView setTextColor:[UIColor blackColor]];
    //    self.rusTextView.layer.shadowColor = [[UIColor blackColor] CGColor];
    //    self.rusTextView.layer.shadowOffset = CGSizeMake(1.0f, .0f);
    //    self.rusTextView.layer.shadowOpacity = 1.0f;
    //    self.rusTextView.layer.shadowRadius = 5.0f;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedString(@"iStudyWords", @"")];
    [self createMenu];
    [self.view bringSubviewToFront:self.bar];
    CGRect barFrame = self.bar.frame;
    [self.bar setFrame:CGRectMake(barFrame.origin.x, 200.0, barFrame.size.width, barFrame.size.height)];
    [self.bar setHidden:YES];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
	myTextView.text = [self loadText];
    
    [self.view addSubview:pagesScrollView.view];
    CGRect frame = self.view.frame;
    frame.origin.x = 0.0;
    frame.origin.y = frame.size.height - pagesScrollView.view.frame.size.height;
    [pagesScrollView.view setFrame:frame];
//    [myTextView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"board.png"]]];
    
    [self customizeTextView:myTextView];
    //    [myTextView setText:@"<H1>header</H1>"];
//    [myTextView setContentToHTMLString:@"<H1>header</H1>"];
}


- (void)viewDidUnload
{
    [navSC release];
    navSC = nil;
    [loadingView release];
    loadingView = nil;
    [myTextView release];
    myTextView = nil;
    [pagesScrollView release];
    pagesScrollView  = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return NO;
}

- (void) back{
    [self saveText];
	[super back];
}

- (IBAction) showTable{
	[self saveText];
	NewWordsTable *table = [[NewWordsTable alloc] initWithNibName:@"NewWordsTable" bundle:nil];
    [self.navigationItem setBackBarButtonItem:BACK_BUTTON];
    [self.navigationController pushViewController:table animated:YES];
    NSString *loadedText = [[[NSString alloc] initWithString:myTextView.text] autorelease];
    loadedText = [NSString removeNumbers:loadedText];
    loadedText = [NSString removeChars:@"-',!." from:loadedText];
    NSLog(@"%@",loadedText);
    [table loadDataWithString:loadedText];
    [table release];
}

#pragma mark MyRecognize functions

- (IBAction) showVoiceRecordView{
	MyRecognizerViewController *voiceView = [[MyRecognizerViewController alloc] initWithDelegate:self];
    [self.navigationController presentModalViewController:voiceView animated:YES];
    [voiceView release];
}

- (IBAction) showVocalizerView{
    MyVocalizerViewController *voiceView = [[MyVocalizerViewController alloc] initWithDelegate:self];
    [voiceView setText:myTextView.text withLanguageCode:[self currentTextLanguage]];
    [self.navigationController presentModalViewController:voiceView animated:YES];
    [voiceView release];
}

- (IBAction)selectAll:(id)sender {
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view];
        return;
    }
    [myTextView selectAll:self];
    [[UIMenuController sharedMenuController] setIsAccessibilityElement:NO];
}

- (IBAction)clearAll:(id)sender {
    [myTextView setText:@""];
}

#pragma mark MyRecognize delegate

-(void)didRecognizeText:(NSString*)text languageCode:(NSString*)textLanguageCode{
    NSArray *languageCode = [textLanguageCode componentsSeparatedByString:@"_"];
    [self setCurrentTextLanguage:[[languageCode objectAtIndex:0] lowercaseString]];
    [myTextView setText:text];
}

- (NSString *) loadText{
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]];
	path = [path stringByAppendingPathComponent:@"myText.doc"];
    NSError *_error = nil;
	NSString *_str = [NSString stringWithContentsOfFile:(NSString *)path encoding:NSUTF8StringEncoding error:(NSError **)_error];
	if (_error)
	{
		NSLog(@"Error writing file at path: %@; error was %@", path, _error);
		return [NSString stringWithFormat:@"Error writing file at path: %@; error was %@", path, _error];
	}
    return _str;
}
					 
- (void) saveText{
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]];
    path = [path stringByAppendingPathComponent:@"myText.doc"];
    NSString *plist = myTextView.text;
    NSError *_error = nil;
    [plist writeToFile:path
            atomically:YES
              encoding:NSUTF8StringEncoding
                 error:&_error];
    
    [[NSUserDefaults standardUserDefaults] setValue:[self currentTextLanguage] forKey:@"lastTextLanguageInTextParseView"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (_error)
    {
        NSLog(@"Error writing file at path: %@; error was %@", path, _error);
    }
}

- (NSString *)getSelectedText{
    range = myTextView.selectedRange;
    NSMutableString *text = [NSMutableString stringWithString:myTextView.text];
    NSString *selectedText = [text substringWithRange:range];
    return selectedText;
}

-(void) translateText:(id)sender{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view];
        return;
    }
    NSString *selectedText = [self getSelectedText];
    if (selectedText.length > 0) {
        NSString *translateLangusgeCode = ([NATIVE_LANGUAGE_CODE isEqualToString:[[self currentTextLanguage] uppercaseString]])?TRANSLATE_LANGUAGE_CODE:NATIVE_LANGUAGE_CODE;
        [wordsView.dataModel setDelegate:self];
        [wordsView.dataModel loadTranslateText:selectedText fromLanguageCode:[self currentTextLanguage] toLanguageCode:translateLangusgeCode withDelegate:self];    }
}

-(void) playText:(id)sender{
#ifdef FREE_VERSION
    if (![MKStoreManager isCurrentItemPurchased:[QQQInAppStore purchaseIDByType:VOCALIZER]]) {
        [self showPurchaseInfoView];
        return;
    }
#endif
    NSString *selectedText = [self getSelectedText];
    if (selectedText.length > 0) {
        MyVocalizerViewController *voiceView = [[MyVocalizerViewController alloc] initWithDelegate:self];
        [voiceView setText:selectedText withLanguageCode:[self currentTextLanguage]];
        [self.navigationController presentModalViewController:voiceView animated:YES];
        [voiceView release];
    }
}

- (void)showAddWordView:(id)sender{
    [super showAddWordView:sender];
    [myTextView resignFirstResponder];
    [self.bar hideButtonsAnimated:YES];
}

#pragma mark loadingTranslate delegate functions

- (void)translateDidLoad:(NSString *)translateText byLanguageCode:(NSString*)_activeTranslateLanguageCode{
    [UIAlertView displayMessage:translateText];
}

//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
//    NSLog(@"%@",NSStringFromSelector(action));
//    if (action == @selector(select:)) {
//        NSString *selectedText = [self getSelectedText];
//        if (selectedText.length > 0) {
//            [self.bar showButtonsAnimated:YES];
//        }
//    }
//    return YES;
//}

- (void)showLanguageSegment{
    if (!navSC) {
        navSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:TRANSLATE_LANGUAGE_CODE, NATIVE_LANGUAGE_CODE, nil]];
        navSC.center = CGPointMake(400, 220);
    }
    navSC.changeHandler = ^(NSUInteger newIndex) {
        [self setCurrentTextLanguage:(newIndex == 0)?TRANSLATE_LANGUAGE_CODE:NATIVE_LANGUAGE_CODE];
    };
    [self.view addSubview:navSC];
    
    [UIView beginAnimations:@"Changing size of textView" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
	navSC.center = CGPointMake((myTextView.isFirstResponder)?260:400,220);
    [UIView commitAnimations];
	navSC.tag = 1;
}

#pragma mark textview delegate functions

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView.frame.size.height>199.0) {
        [UIView beginAnimations:@"Changing size of textView" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [myTextView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 199.0)];
        [UIView commitAnimations];
        [self.bar setHidden:NO];
        [self.bar showButtonsAnimated:YES];
        if ([UITextInputMode currentInputMode] == nil) {
            [self showLanguageSegment];
        }
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.frame.size.height<395.0) {
        [UIView beginAnimations:@"Changing size of textView" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [myTextView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width,  textFieldHieght)];
        [UIView commitAnimations];
//        [self.bar setHidden:YES];
    }
    if ([UITextInputMode currentInputMode] == nil) {
        [self showLanguageSegment];
    }
}

- (BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [self.bar hideButtonsAnimated:YES];
        [_textView resignFirstResponder];
        return NO;
    }
    [self setCurrentTextLanguage:[self detectCurrentTextLanguage]];
    return YES;
}

- (void)setCurrentTextLanguage:(NSString*)_textLanguage{
    if (_textLanguage != currentTextLanguage) {
        if (currentTextLanguage) {
            [currentTextLanguage release];
        }
        currentTextLanguage = [_textLanguage retain];
    }
}

- (NSString*)currentTextLanguage{
    if (!currentTextLanguage) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastTextLanguageInTextParseView"]) {
            [self setCurrentTextLanguage:[[NSUserDefaults standardUserDefaults] stringForKey:@"lastTextLanguageInTextParseView"]];
        }else{
            [self setCurrentTextLanguage:TRANSLATE_LANGUAGE_CODE];
        }
    }
    return currentTextLanguage;
}

- (NSString *)detectCurrentTextLanguage{
    if ([UITextInputMode currentInputMode] == nil) {
        return TRANSLATE_LANGUAGE_CODE;
    }
    NSArray *languageCode = [[[UITextInputMode currentInputMode] primaryLanguage] componentsSeparatedByString:@"-"];
    return [[languageCode objectAtIndex:0] lowercaseString];
}

- (void)setText:(NSString*)text{
    [myTextView setText:text];
}

#pragma mark button view protocol

- (void)buttonDidClick:(id)sender  withIndex:(NSNumber*)index{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        [sender setTag:index.intValue+100];
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view];
        return;
    }
#ifdef FREE_VERSION
    if (![MKStoreManager isCurrentItemPurchased:[QQQInAppStore purchaseIDByType:VOCALIZER]]) {
        [self showPurchaseInfoView];
        return;
    }
#endif
    switch (index.intValue) {
        case 0:
            [self showVoiceRecordView];
            break;
        case 1:
            [self showVocalizerView];
            break;
            
        default:
            break;
    }
}

#ifdef FREE_VERSION
- (void)showPurchaseInfoView{
    PurchasesDetailViewController *infoView = [[PurchasesDetailViewController alloc] initWithPurchaseType:VOCALIZER];
    [self.navigationController presentModalViewController:infoView animated:YES];
    [infoView release];
}
#endif

#pragma mark MyVocalizerDelegate

-(void)didVocalizerPlayedText:(NSString*)text languageCode:(NSString*)textLanguageCode{

}

- (NSString*)helpMessageForButton:(id)_button{   
    int index = ((UIBarButtonItem*)_currentSelectedObject).tag;
    if(index<100){
        return [super helpMessageForButton:_button];
    }
    NSString *message = nil; 
    switch (index) {
        case 100:
            message = NSLocalizedString(@"Распознавание речи", @"");
            break;
        case 101:
            message = NSLocalizedString(@"Синтез речи", @"");
            break;
        default:
            break;
    }
    return message;
}

-(UIView*)hintStateViewToHint:(id)hintState
{
    
    int index = ((UIBarButtonItem*)_currentSelectedObject).tag;
//    
    if(index<100){
        return [super hintStateViewToHint:hintState];
    }
    UIView *view = (UIView *)_currentSelectedObject;
    [usedObjects addObject:_currentSelectedObject];

    if(view.tag>=100){
        CGRect frame = view.frame;
        CGRect buttonFrame;
        buttonFrame = CGRectMake(frame.origin.x+pagesScrollView.view.frame.origin.x, frame.origin.y+pagesScrollView.view.frame.origin.y, frame.size.width, frame.size.height);
        UIView *buttonView = [[[UIView alloc] initWithFrame:frame] autorelease];
        [buttonView setFrame:buttonFrame];
        return buttonView;
    }
    return view;
}

@end
