//
//  LanguagePickerController.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 3/16/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "LanguagePickerController.h"
#import "LanguageFlagImageView.h"

#define RFLAGVIEWTAG 111
#define LFLAGVIEWTAG 222


@implementation LanguagePickerController

@synthesize content;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        content = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)dealloc
{
    [content release];
    [leftLbl release];
    [rightLbl release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) loadData
{
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)] autorelease];
    NSString *pathOfResource = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"/CountryNameCode2.txt"];
    NSString *countryNameCode = [[NSString alloc] initWithContentsOfFile:pathOfResource encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *countries = [[NSArray alloc] initWithArray:[countryNameCode componentsSeparatedByString:@"\r"]];
    [countryNameCode release];

    
    for (int i=0;i<[countries count];i++){
        NSString *country = [countries objectAtIndex:i];
        NSArray *elements = [country componentsSeparatedByString:@"\t"];
        NSString *_counry = [NSString stringWithString:[elements objectAtIndex:0]];
        NSString *_firstCode = [NSString stringWithString:[elements objectAtIndex:1]];
        NSString *_code = [NSString stringWithString:[elements objectAtIndex:2]];
        //remove dots within prefix of code
        NSMutableString *_codeExpended = [NSMutableString stringWithString:[elements objectAtIndex:6]];
        while ([_codeExpended hasPrefix:@"."]) {
            NSRange range;
            range.location = 0;
            range.length = 1;
            [_codeExpended replaceCharactersInRange:range withString:@""];
        }
        
        if (([_code length] > 0)&&([_counry length] > 0)) {
            NSDictionary *country_code = [[NSDictionary alloc] initWithObjectsAndKeys:
                                          _counry,@"country",_code, @"code",_firstCode, @"firstCode", _codeExpended, @"codeExpended",nil]; 
            [content addObject:country_code];
            [country_code release];
        }
    }
    for (int i=0;i<[content count];i++){
        NSString *_code = [NSString stringWithString:[[content objectAtIndex:i] objectForKey:@"firstCode"]];
        if ([_code isEqualToString:[NATIVE_COUNTRY_INFO objectForKey:@"firstCode"]]) {
            [pickerView selectRow:i inComponent:0 animated:YES];
            [self setFlagIconsCountry:_code inComponent:0];
        }
        if ([_code isEqualToString:[TRANSLATE_COUNTRY_INFO objectForKey:@"firstCode"]]) {
            [pickerView selectRow:i inComponent:1 animated:YES];
            [self setFlagIconsCountry:_code inComponent:1];
        }
    }
    [countries release];
}

#pragma mark - View lifecycle

- (void) createFlagsView{
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.5]];
    int flagHight = 30;
    int y = pickerView.frame.origin.y + pickerView.frame.size.height/2 - flagHight/2;
    LanguageFlagImageView *flagView1 = [[LanguageFlagImageView alloc] initWithFrame:CGRectMake(0, y, 40.0, flagHight)];
    flagView1.tag = RFLAGVIEWTAG;
    [self.view addSubview:flagView1];
    LanguageFlagImageView *flagView2 = [[LanguageFlagImageView alloc] initWithFrame:CGRectMake(280, y, 40.0, flagHight)];
    flagView2.tag = LFLAGVIEWTAG;
    [self.view addSubview:flagView2];
    [flagView1 release];
    [flagView2 release];
    //flagView = flagsView;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:NSLocalizedString(@"iStudyWords", @"")];
    [self createFlagsView];
    [self loadData];
    [pickerView reloadAllComponents];
    searchBarRight.placeholder = NSLocalizedString(@"Touch to search", @"");
    searchBarLeft.placeholder = NSLocalizedString(@"Touch to search", @"");
    leftLbl.text = NSLocalizedString(@"Native language", @"");
    rightLbl.text = NSLocalizedString(@"Diffrent language", @"");
}

- (void)viewDidUnload
{
    [searchBarLeft release];
    [searchBarRight release];
    [leftLbl release];
    leftLbl = nil;
    [rightLbl release];
    rightLbl = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Picker delegate functions
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return [content count];
}

- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dict = [content objectAtIndex:row];
	return [dict objectForKey:@"country"];
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    [self setFlagIconsCountry:[[content objectAtIndex:row] objectForKey:@"firstCode"] inComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)_pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = (_pickerView.frame.size.width - 75)/2 - 5;
    return sectionWidth;
}

- (UIView *)pickerView:(UIPickerView *)_pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *retval = (id)view;
    if (!retval) {
        retval= [[[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width-10, [_pickerView rowSizeForComponent:component].height)] autorelease];
    }
    [retval setBackgroundColor:[UIColor clearColor]];
    NSDictionary *dict = [content objectAtIndex:row];
    retval.text = [dict objectForKey:@"country"];
    retval.font = [UIFont fontWithName:@"System Bold" size:15];
    return retval;
}

- (void)setFlagIconsCountry:(NSString*)code inComponent:(int)component{
    LanguageFlagImageView *languageFlagImageView;
    switch (component) {
        case 0:
            languageFlagImageView = (LanguageFlagImageView *)[self.view viewWithTag:RFLAGVIEWTAG];
            break;
        case 1:
            languageFlagImageView = (LanguageFlagImageView *)[self.view viewWithTag:LFLAGVIEWTAG];
            break;            
        default:
            break;
    }
    if (languageFlagImageView){
        [languageFlagImageView setCountryCode:code];
    }
}

- (void)done{
    NSDictionary *dict = [content objectAtIndex:[pickerView selectedRowInComponent:0]];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastTheme"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastThemeInAddView"];
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"nativeCountryInfo"];
    [[NSUserDefaults standardUserDefaults] setValue:[dict  objectForKey:@"code"] forKey:@"nativeCountryCode"];
    [[NSUserDefaults standardUserDefaults] setValue:[dict  objectForKey:@"country"] forKey:@"nativeCountry"];
    dict = [content objectAtIndex:[pickerView selectedRowInComponent:1]];
    [[NSUserDefaults standardUserDefaults] setValue:dict forKey:@"translateCountryInfo"];
    [[NSUserDefaults standardUserDefaults] setValue:[dict  objectForKey:@"code"] forKey:@"translateCountryCode"];
    [[NSUserDefaults standardUserDefaults] setValue:[dict  objectForKey:@"country"] forKey:@"translateCountry"];
    [self.navigationController popViewControllerAnimated:YES];
    self.navigationItem.rightBarButtonItem = nil;
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)closeSearchBar{
    [searchBarLeft resignFirstResponder];
    [searchBarRight resignFirstResponder];
    searchBarRight.text = @"";
    searchBarLeft.text = @"";
}

#pragma mark -
#pragma mark UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    isSearching = YES;
    pickerView.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeSearchBar)] autorelease];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    isSearching = NO;
    pickerView.userInteractionEnabled = YES;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)] autorelease];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    for (int i=0;i<[content count];i++){
        NSString *_country = [NSString stringWithString:[[content objectAtIndex:i] objectForKey:@"country"]];
        NSString *_code = [NSString stringWithString:[[content objectAtIndex:i] objectForKey:@"firstCode"]];
        NSRange range = [[_country lowercaseString] rangeOfString:[searchText lowercaseString]];
        if (range.length > 0) {
            if (searchBarLeft == searchBar) {
                [pickerView selectRow:i inComponent:0 animated:YES];
                [self setFlagIconsCountry:_code inComponent:0];
            }else if(searchBarRight == searchBar){
                [pickerView selectRow:i inComponent:1 animated:YES];
                [self setFlagIconsCountry:_code inComponent:1];
            }
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {
    searchBar.text = @"";
	[searchBar resignFirstResponder];
}

@end
