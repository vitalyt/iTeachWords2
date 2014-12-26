//
//  MyPickerViewContrller.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/30/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "MyPickerViewContrller.h"
#import "MyPickerViewProtocol.h"
#import "WordTypes.h"
#import "ThemesTableView.h"
#import "ThemeDetailView.h"

#define PICKER_ROW_HEIGHT 50

@implementation MyPickerViewContrller
@synthesize pickerView;
@synthesize delegate,data;

- (void) initArray{
	if (self != nil) {
		[self loadData];
	}
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

+ (NSArray*)loadAllThemeWithPredicate:(NSPredicate*)_predicate{
    NSLog(@"%@",_predicate);
    NSFetchedResultsController *_fetches = [NSManagedObjectContext 
                                            getEntities:@"WordTypes" sortedBy:@"createDate" withPredicate:_predicate];
    
	NSSortDescriptor *_data = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
	NSArray *_companies = [_fetches fetchedObjects];
    return [_companies sortedArrayUsingDescriptors:[NSArray arrayWithObjects:_data, nil]];
}

+ (NSArray*)loadAllTheme{
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"nativeCountryCode = %@ && translateCountryCode = %@",NATIVE_LANGUAGE_CODE, TRANSLATE_LANGUAGE_CODE];
    return [MyPickerViewContrller loadAllThemeWithPredicate:_predicate];
}

- (void) loadData{ 
	self.data = [MyPickerViewContrller loadAllTheme];
    if ([self.data count] == 0) {
        [UIAlertView displayMessage:NSLocalizedString(@"The list of dictionaries is empty. First of all create a theme.", @"") title:NSLocalizedString(@"Suggestion", @"")];
    }
    rows = [[NSMutableArray alloc] initWithCapacity:[self.data count]];
    for (int i=0; i<[self.data count]; i++) {
        ThemeDetailView *pickerRowView = [[ThemeDetailView alloc] initWithNibName:@"ThemeDetailView" bundle:nil];
        [pickerRowView.view setFrame:CGRectMake(0, 0, pickerView.frame.size.width, PICKER_ROW_HEIGHT)];
        [rows addObject:pickerRowView];
        [pickerRowView setTheme:[data objectAtIndex:i]];
    }

    
	[pickerView reloadAllComponents];
    
    NSString *lastTheme  = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastTheme"];
    if (lastTheme){
        int i = 0;
        for (WordTypes *types in data) {
            if ([types.name isEqualToString:lastTheme]){
                [pickerView selectRow:i inComponent:0 animated:YES];
                [self pickerView:pickerView didSelectRow:i inComponent:0];
            }
            ++i;
        }
    }
}

- (NSString *) getTextPicker
{
	if ([data count] > 0) {
		return [NSString stringWithFormat:@"%@",[[data objectAtIndex:[pickerView selectedRowInComponent:0]] name]];
	}
	return @"";
}

- (WordTypes *) getType
{
	if ([data count] > 0) {
		return [data objectAtIndex:[pickerView selectedRowInComponent:0]];
	}
	return nil;
}

- (void) openViewWithAnimation:(UIView *) superView{ 
	[superView addSubview:self.view];
    CGRect frame = superView.bounds;
    frame.origin.x = 0;
    frame.origin.y = 0-self.view.frame.size.height;
    [self.view setFrame:frame];
    
    frame.origin.y = 20;//+self.view.frame.size.height;
    [UIView beginAnimations:@"pickerShoving" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view setFrame:frame];
    [UIView commitAnimations];
    [self.view performSelector:@selector(setBackgroundColor:) withObject:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.75] afterDelay:.5];
}

- (IBAction) showAddView:(id)sender
{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
    [pickerView setUserInteractionEnabled:NO];
    isAdding = YES;
    WordTypes *wordType;
    [iTeachWordsAppDelegate createUndoBranch];
    wordType = [NSEntityDescription insertNewObjectForEntityForName:@"WordTypes" 
                                             inManagedObjectContext:CONTEXT];
    [wordType setName:@""];
    [wordType setNativeCountryCode:[NATIVE_LANGUAGE_CODE uppercaseString]];
    [wordType setTranslateCountryCode:[TRANSLATE_LANGUAGE_CODE uppercaseString]];
    [wordType setCreateDate:[NSDate date]];
    
//    [iTeachWordsAppDelegate saveUndoBranch];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"lastTheme"];
    [self loadData];
    [pickerView selectRow:0 inComponent:0 animated:YES];
    [self performSelector:@selector(editThemeName:)withObject:nil afterDelay:.3];
}

- (IBAction)editThemeName:(id)sender {
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
    [pickerView setUserInteractionEnabled:NO];
    [themeEditingFlt setText:@""];
	[themeEditingFlt.layer addAnimation:[self cretePushAnimation] forKey:nil];
    if (!isAdding) {
        [iTeachWordsAppDelegate createUndoBranch];
    }
    [themeEditingFlt setHidden:NO];
    WordTypes *wordType = [data objectAtIndex:[pickerView selectedRowInComponent:0]];
    [themeEditingFlt performSelector:@selector(setText:) withObject:wordType.name afterDelay:.25];
    [themeEditingFlt becomeFirstResponder];
}

- (void)closeEditingField{
	[themeEditingFlt.layer addAnimation:[self cretePopAnimation] forKey:nil];
    [iTeachWordsAppDelegate remoneUndoBranch];
    [themeEditingFlt setHidden:YES];
    [themeEditingFlt resignFirstResponder];
    [self loadData];
    isAdding = NO;
}

- (void)saveEditingField{
    NSString *typeName = [NSString stringWithString:themeEditingFlt.text];
    typeName = [NSString removeSpaces:typeName];
    if ([typeName length] == 0) {
        [UIAlertView displayError:NSLocalizedString(@"Please enter the name of the theme.", @"")];
        return;
    }
    if ([self isThemeAvailability:typeName]) {
        [UIAlertView displayError:NSLocalizedString(@"The theme with current name already exist.", @"")];
        return;
    }
    
    WordTypes *wordType = [data objectAtIndex:[pickerView selectedRowInComponent:0]];
    [wordType setName:themeEditingFlt.text];
    [iTeachWordsAppDelegate saveUndoBranch];
    [themeEditingFlt setHidden:YES];
    [themeEditingFlt resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] setValue:typeName forKey:@"lastTheme"];
    [self loadData];
    isAdding = NO;
}

- (bool)isThemeAvailability:(NSString*)themeName{
    NSPredicate *_predicate = [NSPredicate predicateWithFormat:@"nativeCountryCode = %@ && translateCountryCode = %@ && name = %@",NATIVE_LANGUAGE_CODE, TRANSLATE_LANGUAGE_CODE,themeName];
    if ([[MyPickerViewContrller loadAllThemeWithPredicate:_predicate] count]>0) {
        return YES;
    }
    return NO;
}

- (IBAction) cansel
{    
    [pickerView setUserInteractionEnabled:YES];
    if (!themeEditingFlt.hidden) {
        [self closeEditingField];
        return;
    }
    CGRect frame = self.view.frame;
    frame.origin.y = 0-self.view.frame.size.height;
    frame.origin.x = 0;
    [UIView beginAnimations:@"pickerShoving" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view setFrame:frame];
    [UIView commitAnimations];
    
    [self closeView];
}

- (void)closeView{
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.view performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:.5];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerWillCansel)]) {
		[self.delegate pickerWillCansel];
	}  
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField.text length] > 0) {
        [self done];
    }else{
        [self cansel];
    }
    return YES;
}

- (IBAction) done
{
    [pickerView setUserInteractionEnabled:YES];
    if (!themeEditingFlt.hidden) {
        [self saveEditingField];
        return;
    }
    [pickerView setUserInteractionEnabled:YES];
    if ([data count] <= [pickerView selectedRowInComponent:0]) {
        [UIAlertView displayError:@"No selected theme."];
        return;
    }
	if (self.delegate && [self.delegate respondsToSelector:@selector(setTextFromPicker:)]) {
		[self.delegate setTextFromPicker: [self getTextPicker]];
	}
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerDone:)]) {
		[self.delegate pickerDone:[data objectAtIndex:[pickerView selectedRowInComponent:0]]];
	}
    
    CGRect frame = self.view.frame;
    frame.origin.y = 0-self.view.frame.size.height;
    
    [UIView beginAnimations:@"pickerShoving" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.view setFrame:frame];
    [UIView commitAnimations];
    
    [self closeView];
}

- (IBAction) remove:(id)sender
{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
    CustomAlertView *alert = [[CustomAlertView alloc] initWithTitle:@"Removing" message:@"Are you sure you want to delete this theme?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		[self deleteType];
	}
}

- (CATransition*)cretePushAnimation{
    CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush; 
	myTransition.duration = 0.2;
    myTransition.subtype = kCATransitionFromLeft;
    return myTransition;
}

- (CATransition*)cretePopAnimation{
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush; 
	myTransition.duration = 0.2;
    myTransition.subtype = kCATransitionFromRight;
    return myTransition;
}


- (IBAction)showThemesTableView:(id)sender {
    ThemesTableView *themesTableView = [[ThemesTableView alloc] initWithNibName:@"ThemesTableView" bundle:nil];
    [((UIViewController*)self.delegate).navigationController pushViewController:themesTableView animated:YES];
    [themesTableView setDelegate:self.delegate];
    [self cansel];    
}

- (IBAction) deleteType{
    NSInteger selectedIndex = [pickerView selectedRowInComponent:0];
    WordTypes *wordType = [data objectAtIndex:selectedIndex];
    [iTeachWordsAppDelegate createUndoBranch];
    [CONTEXT deleteObject:wordType];
    [iTeachWordsAppDelegate saveUndoBranch];
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:data];
    [array removeObjectAtIndex:selectedIndex];
    data = array;
	[self loadData];
//    [pickerView reloadAllComponents];
    [pickerView selectRow:((selectedIndex==0)?0:selectedIndex-1) inComponent:0 animated:YES];
    
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [data count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    WordTypes *wordType = [data objectAtIndex:row];
	return [wordType name];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([self.delegate respondsToSelector:@selector(pickerDidChooseType:)]) {
		[self.delegate pickerDidChooseType:[data objectAtIndex:row]];
	}
//    [self showThemeDetail:[data objectAtIndex:row]];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return PICKER_ROW_HEIGHT;
}

// Row view creation delegate
- (UIView *)pickerView:(UIPickerView *)_pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    ThemeDetailView *pickerRowView = (ThemeDetailView*)[rows objectAtIndex:row];
    return (UIView*)pickerRowView.view;
}

- (void)showThemeDetail:(WordTypes*)_wordType{
    if (!themeDetailView) {
        themeDetailView = [[ThemeDetailView alloc] initWithNibName:@"ThemeDetailView" bundle:nil];
        [self.view addSubview:themeDetailView.view];
        [themeDetailView.view setFrame:CGRectMake(0, 259, themeDetailView.view.frame.size.width, themeDetailView.view.frame.size.height)];
    }
    [themeDetailView performSelectorInBackground:@selector(setTheme:) withObject:_wordType];
//    [themeDetailView setTheme:_wordType];
}

- (void)viewDidUnload {
    themeEditingFlt = nil;
    [super viewDidUnload];
}

-(UIView*)hintStateViewForDialog:(id)hintState
{
    CGRect frame = self.view.superview.frame;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height/4, frame.size.width-20, frame.size.height/4)];
    l.numberOfLines = 4;
    [l setTextAlignment:NSTextAlignmentCenter];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:[self helpMessageForButton:_currentSelectedObject]];
    return l;
}

- (NSString*)helpMessageForButton:(id)_button{
    NSString *message = nil;
    NSInteger index = ((UIBarButtonItem*)_button).tag+1;
    switch (index) {
        case 1:
            message = NSLocalizedString(@"Добавление нового словаря", @"");
            break;
        case 2:
            message = NSLocalizedString(@"Переименование словаря", @"");
            break;
        case 3:
            message = NSLocalizedString(@"Удаление словаря", @"");
            break;
        default:
            break;
    }
    return message;
}


-(UIView*)hintStateViewToHint:(id)hintState
{
    UIView *buttonView = nil;
    UIView *view = (UIView *)_currentSelectedObject;
    CGRect frame = view.frame;
    buttonView = [[UIView alloc] initWithFrame:frame];
    [buttonView setFrame:CGRectMake(frame.origin.x, frame.origin.y+20, frame.size.width, frame.size.height)];
    return buttonView;
}

@end
