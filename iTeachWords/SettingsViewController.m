//
//  SettingsViewController.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 10/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "SettingsViewController.h"
#import "LanguagePickerController.h"
#import "TextFieldLanguagesCell.h"
#import "SwitchingCell.h"
#import "NotificationTableView.h"

#ifdef FREE_VERSION
#import "PurchasesDetailViewController.h";
#import "QQQInAppStore.h"
#endif

#define FONT_OF_HEAD_LABEL [UIFont fontWithName:@"Helvetica-Bold" size:16]

@implementation SettingsViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization 
        self.title = NSLocalizedString(@"Settings", @"");
    }
    return self;
}

- (void)dealloc
{
    [barItem release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    table.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Wallpaper"]];
    [TestFlight passCheckpoint:@"User gone to the Settings view"];
    [TestFlight openFeedbackView];
    barItem.frame = CGRectMake(0, self.view.frame.size.height+barItem.frame.size.height, barItem.frame.size.width, barItem.frame.size.height);
    [self.view addSubview:barItem];
}

- (void)viewDidUnload
{
    [barItem release];
    barItem = nil;
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self loadData];
}

- (void) loadData{
    NSString *language = [[NSUserDefaults standardUserDefaults] stringForKey:@"Language"];
    NSString *fontName = DEFAULT_FONT_NAME;
    int fontSize = DEFAULT_FONT_SIZE;
    bool isRepeatNotifications = IS_REPEAT_OPTION_ON;
    bool isHelpMode = IS_HELP_MODE;
    if (language) {
        [self.values setObject:language forKey:@"Language"];
    }
    if (fontName) {
        [self.values setObject:fontName forKey:@"fontName"];
    }
    if (fontSize) {
        [self.values setObject:[NSString stringWithFormat:@"%d",fontSize] forKey:@"fontSize"];
    }
    [self.values setObject:[NSNumber numberWithBool:isRepeatNotifications] forKey:@"isRepeatOptionOn"];
    [self.values setObject:[NSNumber numberWithBool:isHelpMode] forKey:@"isHelpMode"];
    
    titles = [[NSMutableArray alloc] initWithObjects:@"", nil];
    NSArray *elements = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Language",@""),NSLocalizedString(@"Font size",@""),NSLocalizedString(@"Font name",@""),NSLocalizedString(@"Help",@""),NSLocalizedString(@"Notification",@""), nil];
    NSArray *elements1 = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Password",@""), nil];
    self.data = [NSArray arrayWithObjects:elements, nil];
    [elements release];
    [elements1 release];
    [self.table reloadData];
}

- (NSString*)keyForIndexPath:(NSIndexPath*)indexPath{
    NSString *key = @"";
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                key = @"Language";
                break;
            case 1:
                key = @"fontSize";
                break;
            case 2:
                key = @"fontName";
                break;
            case 3:
                key = @"isHelpMode";
                break;
            case 4:
                key = @"isRepeatOptionOn";
                break;
                
            default:
                break;
        }
    }
    return key;
}

#pragma mark table view delegate
- (NSString*) tableView: (UITableView*)tableView cellIdentifierForRowAtIndexPath: (NSIndexPath*)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return @"TextFieldLanguagesCell";
                break;
            case 2:
                return @"TextFieldCell";
                break;
//            case 3:
//                return @"SwitchingCell";
//                break;
            case 3:
                return @"SwitchingCell";
                break;
            case 4:
                return nil;
                break;
            default:
                break;
        }
    }
    return @"TextFieldCell";   
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 88;
    }
    return 44;
}

- (NSInteger) numberOfSectionsInTableView: (UITableView*)tableView {
    return [titles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[data objectAtIndex:section] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //    if (section == 1) {
    UIView *v=[[[UIView alloc] init] autorelease];
    v.backgroundColor = [UIColor clearColor];
    NSString *tite = [titles objectAtIndex:section];
    float width ;
    width = self.view.frame.size.width - 40;
    if (section == 1) {
        width = self.view.frame.size.width - 140;
    }
    CGSize detailSize = [tite sizeWithFont:FONT_OF_HEAD_LABEL constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    UILabel *header = [[UILabel alloc] initWithFrame: CGRectMake(20, 10.0, width, detailSize.height)];
    header.numberOfLines = 3;
    header.backgroundColor = [UIColor clearColor];
    header.textColor = [UIColor colorWithRed:0.29f green:0.33f blue:0.42f alpha:1.0f];
    header.font = FONT_OF_HEAD_LABEL; 
    header.text = tite;
    [v addSubview:header];
    [header release];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	NSString *tite = [titles objectAtIndex:section];
    float width = self.view.frame.size.width - 40;
    if (section == 1) {
        width = self.view.frame.size.width - 140;
    }
	CGSize detailSize = [tite sizeWithFont:FONT_OF_HEAD_LABEL constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
	return detailSize.height + 15;//+titleSize.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[TextFieldCell class]]) {
        [((TextFieldCell *)cell).textField becomeFirstResponder];
    }else if ([cell isKindOfClass:[UITableViewCell class]] && indexPath.row == 4) {
        [self showNotificationTableView];
    }
}

- (void) configureCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath {
    NSString *titleText = [[data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if ([cell isKindOfClass:[TextFieldCell class]]) {
        TextFieldCell* _cell = (TextFieldCell *)cell;
        _cell.textField.placeholder = NSLocalizedString(@"Touch to change", @""); 
        [_cell setDelegate:self];
        [_cell.titleLabel setText:titleText];
        [_cell.titleLabel setFont:SETINGSTABLE_FONT_SIZE];
        NSString *value = [self.values objectForKey:[self keyForIndexPath:indexPath]];
        if (value) {
            _cell.textField.text = value;
        } 
        
        switch (indexPath.row) {
            case 1:
                _cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 2:
            {
                [_cell.textField setText:DEFAULT_FONT_NAME];
                [_cell.textField setFont:FONT_TEXT];
                [_cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
                break;
            case 3:
                _cell.textField.secureTextEntry = YES;
                break;
                
            default:
                break;
        }
    }
    if ([cell isKindOfClass:[TextFieldLanguagesCell class]]) {
        TextFieldLanguagesCell* _cell = (TextFieldLanguagesCell *)cell;
        _cell.textField.placeholder = NSLocalizedString(@"Touch to change", @""); 
        _cell.textField2.placeholder = NSLocalizedString(@"Touch to change", @""); 
        _cell.textField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"nativeCountry"];
        _cell.textField2.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"translateCountry"];
        [_cell.titleLabel setFont:SETINGSTABLE_FONT_SIZE];
        [_cell.titleLabel2 setFont:SETINGSTABLE_FONT_SIZE];
        _cell.titleLabel.text = NSLocalizedString(@"Native language", @""); 
        _cell.titleLabel2.text = NSLocalizedString(@"Diffrent language", @"");
        [_cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [self setImageFlagInCell:_cell];
    }else if([cell isKindOfClass:[SwitchingCell class]]){
        SwitchingCell* _cell = (SwitchingCell *)cell; 
        NSString *key = [self keyForIndexPath:indexPath];
        bool _value = [[self.values objectForKey:key] boolValue];
        _cell.titleLabel.text = titleText;
        [_cell.titleLabel setFont:SETINGSTABLE_FONT_SIZE];
        [_cell setDelegate:self];
        NSLog(@"%d",_value);
        NSLog(@"%@",key);
        [_cell.switcher setOn:_value];
        //[self.values setValue:[NSNumber numberWithInt:value] forKey:key];
    }else if([cell isMemberOfClass:[UITableViewCell class]]){
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = titleText;
        [cell.textLabel setFont:SETINGSTABLE_FONT_SIZE];
    }
}

- (void) setImageFlagInCell:(TextFieldLanguagesCell *)_cell{
    NSString *path = [NSString stringWithFormat:@"%@.png", TRANSLATE_LANGUAGE_CODE];
	UIImageView *objImageEng = [[UIImageView alloc]initWithImage:[UIImage imageNamed:path]];
    [objImageEng setFrame:CGRectMake(0.0, 0.0, 20, 20)];
    path = [NSString stringWithFormat:@"%@.png", NATIVE_LANGUAGE_CODE];
	UIImageView *objImageRus = [[UIImageView alloc]initWithImage:[UIImage imageNamed:path]];
    [objImageRus setFrame:CGRectMake(0.0, 0.0, 20, 18)];
	[_cell.textField2 setLeftView:objImageEng];
	[_cell.textField2 setLeftViewMode:UITextFieldViewModeAlways];
	[_cell.textField setLeftView:objImageRus];
	[_cell.textField setLeftViewMode:UITextFieldViewModeAlways];
    objImageEng.layer.cornerRadius = 10.0;
    objImageRus.layer.cornerRadius = 5.0;
	[objImageRus release];
	[objImageEng release];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [titles objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return index;
}

#pragma mark Cells protocol functions

-(void)cellDidEndEditing:(TextFieldCell *)cell {
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self showToolbar];
        [table reloadData];
    }
	[super cellDidEndEditing:cell];
}

-(void)cellDidBeginEditing:(TextFieldCell *)cell {
    currentTextField = cell.textField;
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    if ([cell isKindOfClass:[TextFieldLanguagesCell class]] ) {
        [self showDatePickerView:cell];
        [currentTextField resignFirstResponder];
        return;
    }else if (indexPath.row == 2){
        [self showFontPicker:nil];
        [currentTextField resignFirstResponder];
        return;
    }else if (indexPath.row == 1){
        [self showToolbar];
    }
    [super cellDidBeginEditing:cell];
}

-(void)cellChanged:(UITableViewCell *)cell {
	NSIndexPath *indexPath = [table indexPathForCell:cell];
	if (nil == indexPath) {
		return;
	}
    NSString *key;
    NSString *value;
    key = [self keyForIndexPath:indexPath];
    if ([cell isKindOfClass:[TextFieldCell class]]) {
        TextFieldCell *_cell = (TextFieldCell*)cell;
        value = _cell.textField.text;
        
        if (indexPath.section == 0) {
            [self.values setObject:value forKey:key];
            if (indexPath.row == 1) {
                [[NSUserDefaults standardUserDefaults] setInteger:[value intValue] forKey:@"defaultFontZise"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
    }else if([cell isKindOfClass:[SwitchingCell class]]){
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        SwitchingCell* _cell = (SwitchingCell *)cell; 
        _cell.titleLabel.text = [[self.data objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [_cell setDelegate:self];
        bool _value = _cell.switcher.on;
        [values setObject:[NSNumber numberWithBool:_value] forKey:key];
        [[NSUserDefaults standardUserDefaults] setBool:_value forKey:key]; 
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[iTeachWordsAppDelegate sharedDelegate] activateNotification];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}   

- (void) showDatePickerView:(TextFieldCell *)cell{
    [currentTextField resignFirstResponder];
    LanguagePickerController *languagePicker = [[LanguagePickerController alloc]initWithNibName:@"LanguagePickerController" bundle:nil];   
    [self.navigationController pushViewController:languagePicker animated:YES];
    [languagePicker release];
}

- (IBAction)closeView:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)done{
    if (![self.values objectForKey:@"Name"] || ![self.values objectForKey:@"id"] || ![self.values objectForKey:@"luid"] || ![self.values objectForKey:@"Password"]) {
        [UIAlertView displayError:NSLocalizedString(@"Data is not completly", @"")];
        return;
    }
}

- (void)showNotificationTableView{
    
#ifdef FREE_VERSION
    if (![MKStoreManager isCurrentItemPurchased:[QQQInAppStore purchaseIDByType:NOTIFICATION]]) {
        [self showPurchaseInfoView];
        return;
    }
#endif
    
     NotificationTableView *notificationViewController = [[NotificationTableView alloc] initWithNibName:@"NotificationTableView" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:notificationViewController animated:YES];
     [notificationViewController release];
     
}

#ifdef FREE_VERSION
- (void)showPurchaseInfoView{
    PurchasesDetailViewController *infoView = [[PurchasesDetailViewController alloc] initWithPurchaseType:NOTIFICATION];
    [self.navigationController presentModalViewController:infoView animated:YES];
    [infoView release];
}
#endif

- (void)showToolbar{
    CGRect frame = barItem.frame; 
    if (!isKeyboardShowing) {
        frame = CGRectMake(0, self.view.frame.size.height-260, barItem.frame.size.width, barItem.frame.size.height);
    }else{
        frame = CGRectMake(0, self.view.frame.size.height+barItem.frame.size.height, barItem.frame.size.width, barItem.frame.size.height);
    }
    [UIView beginAnimations:@"MoveAndStrech" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [barItem setFrame:frame];
    [UIView commitAnimations];
    
    isKeyboardShowing = !isKeyboardShowing;
}

- (IBAction)changeSize:(id)sender {
    [currentTextField resignFirstResponder];
}

#pragma mark Font functions

- (void)showFontPicker:(id)sender {
    [currentTextField resignFirstResponder];
	ARFontPickerViewController *controller = [[ARFontPickerViewController alloc] initWithStyle:UITableViewStylePlain];
	controller.delegate = self;
    //	[self presentModalViewController:controller animated:YES];
    [self.navigationItem setBackBarButtonItem: BACK_BUTTON];
    [self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)fontPickerViewController:(ARFontPickerViewController *)fontPicker didSelectFont:(NSString *)fontName {
	[fontPicker dismissModalViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setValue:fontName forKey:@"defaultFontName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [currentTextField setFont:FONT_TEXT];
	//[table reloadData];
}

@end
