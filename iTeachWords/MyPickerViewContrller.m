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

@implementation MyPickerViewContrller
@synthesize pickerView;
@synthesize delegate,data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void) initArray{
	if (self != nil) {
		[self loadData];
	}
}

- (void) loadData{ 
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"nativeCountryCode = %@ && translateCountryCode = %@",[[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE], [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE]];
    NSLog(@"%@",predicate);
    NSFetchedResultsController *fetches = [NSManagedObjectContext 
                                           getEntities:@"WordTypes" sortedBy:@"createDate" withPredicate:predicate];
    
	NSSortDescriptor *date = [[NSSortDescriptor alloc] initWithKey:@"createDate" ascending:NO];
	NSArray *companies = [fetches fetchedObjects];
	self.data = [companies sortedArrayUsingDescriptors:[NSArray arrayWithObjects:date, nil]];
    [date release];
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
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionMoveIn; 
	myTransition.subtype = kCATransitionFromBottom;
	//myTransition.duration = 1.0;
	[self.view.layer addAnimation:myTransition forKey:nil]; 
	[superView addSubview:self.view];
}

- (IBAction) cansel
{
    CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionFade; 
	myTransition.duration = 0.3;
	[self.view.superview.layer addAnimation:myTransition forKey:nil];
	[self.view removeFromSuperview];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerWillCansel)]) {
		[self.delegate pickerWillCansel];
	}
}

- (IBAction) done
{
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
    
    CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionFade; 
	//myTransition.subtype = kCATransitionPush;
	myTransition.duration = 0.3;
	//[self.view.layer addAnimation:myTransition forKey:nil]; 
	[self.view.superview.layer addAnimation:myTransition forKey:nil];
	[self.view removeFromSuperview];

}

- (IBAction) remove
{
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Removing" message:@"Are you sure you want to delete this theme?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil]  autorelease];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 1) {
		[self deleteType];
	}
}

- (IBAction) showAddView
{
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush; 
	
	myTransition.duration = 0.2;
	
    myTransition.subtype = kCATransitionFromLeft;
    [myTextField becomeFirstResponder];
    
    [rightButton setAction:@selector(saveNewTheme)];
    [rightButton setTitle:@"Add"];
    
    [leftButton setAction:@selector(closeAddView)];
    [leftButton setStyle:UIBarButtonItemStyleBordered];
	
	[myTextField.layer addAnimation:myTransition forKey:nil];
	myTextField.hidden = NO;
    [myTextField setText:@""];
}

- (IBAction) closeAddView
{
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type = kCATransitionPush; 
	myTransition.duration = 0.2;
    myTransition.subtype = kCATransitionFromRight;
    [rightButton setAction:@selector(done)];
    //[rightButton setTitle:@"Done"];
    [rightButton setStyle:UIBarButtonItemStyleDone];
    [leftButton setAction:@selector(cansel)];
    [myTextField resignFirstResponder];
	
	[myTextField.layer addAnimation:myTransition forKey:nil];
	myTextField.hidden = YES;
    [myTextField setText:@""];
    
}

- (void) saveNewTheme{
    NSString *typeName = [NSString stringWithString:myTextField.text];
    [typeName removeSpaces];
	if ([typeName length] == 0) {
        [UIAlertView displayError:@"Please enter the name of the theme."];
		return;
	}
    
    NSError *error;
    NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];   
    [request setEntity:[NSEntityDescription entityForName:@"WordTypes" inManagedObjectContext:[iTeachWordsAppDelegate sharedContext]]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"name = %@",typeName]];  
    NSArray *_data = [[NSArray alloc]initWithArray:[[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error]];
    if ([_data count] > 0) {
        [UIAlertView displayError:@"The Name already exists."];
    }else{
        WordTypes *wordType;
        wordType = [NSEntityDescription insertNewObjectForEntityForName:@"WordTypes" 
                                                inManagedObjectContext:CONTEXT];
        [wordType setName:typeName];
        [wordType setNativeCountryCode:[[[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE] uppercaseString]];
        [wordType setTranslateCountryCode:[[[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE] uppercaseString]];
        [wordType setCreateDate:[NSDate date]];
        if (![CONTEXT save:&error]) {
            [UIAlertView displayError:@"There is problem with saving data."];
        }
        [[NSUserDefaults standardUserDefaults] setValue:typeName forKey:@"lastTheme"];
        [_data release];
        [self loadData];
        [self closeAddView];
        return;
    }
    [_data release];
    
	
}

- (IBAction) deleteType{
    int selectedIndex = [pickerView selectedRowInComponent:0];
    WordTypes *wordType = [data objectAtIndex:selectedIndex];
    [CONTEXT deleteObject:wordType];
     NSError *error;
    if (![CONTEXT save:&error]) {
        [UIAlertView displayError:@"There is problem with saving updated data. Updating data does not completely."];
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:data];
    [array removeObjectAtIndex:selectedIndex];
    [data release];
    data = array;
    [pickerView reloadAllComponents];
    [pickerView selectRow:(selectedIndex==0)?0:selectedIndex-1 inComponent:0 animated:YES];
	[self loadData];
    
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
   
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];    
	myTextField.hidden = YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	delegate = nil;
	[pickerView release];
	[data release];
    [super dealloc];
}


@end
