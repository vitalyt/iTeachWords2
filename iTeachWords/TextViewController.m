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

#define radius 10

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    myTextView.layer.cornerRadius = radius;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createMenu];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"grnd.png"]];
    [myTextView setFont:FONT_TEXT];
	myTextView.text = [self loadText];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return YES;
}

- (IBAction) showTable{
	[self saveText];
	NewWordsTable *table = [[NewWordsTable alloc] initWithNibName:@"NewWordsTable" bundle:nil];
    [self.navigationController pushViewController:table animated:YES];
    [table loadDataWithString:myTextView.text];
}
					 
- (NSString *) loadText{
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]];
	path = [path stringByAppendingPathComponent:@"myText.doc"];
    NSError *error = nil;
	NSString *_str = [NSString stringWithContentsOfFile:(NSString *)path encoding:NSUTF8StringEncoding error:(NSError **)error];
	if (error)
	{
		NSLog(@"Error writing file at path: %@; error was %@", path, error);
		return [NSString stringWithFormat:@"Error writing file at path: %@; error was %@", path, error];
	}
    return _str;
}
					 
- (void) saveText{
	NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]];
    path = [path stringByAppendingPathComponent:@"myText.doc"];
    NSString *plist = myTextView.text;
    NSError *error = nil;
    [plist writeToFile:path
            atomically:YES
              encoding:NSUTF8StringEncoding
                 error:&error];
    if (error)
    {
        NSLog(@"Error writing file at path: %@; error was %@", path, error);
    }
}

- (void) createMenu{
    [self becomeFirstResponder];
    NSMutableArray *menuItemsMutableArray = [NSMutableArray new];
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"Translate", @"")
                                                       action:@selector(translateText)] autorelease];
    [menuItemsMutableArray addObject:menuItem];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect: CGRectMake(0, 0, 320, 200)
                           inView:self.view];
    menuController.menuItems = menuItemsMutableArray;
    [menuController setMenuVisible:YES
                          animated:YES];
    [[UIMenuController sharedMenuController] setMenuItems:menuItemsMutableArray];
    [menuItemsMutableArray release];
}

-(void) translateText{
    //[textView resignFirstResponder];
    range = myTextView.selectedRange;
    if (range.length > 0) {
        NSMutableString *text = [NSMutableString stringWithString:myTextView.text];
        NSString *selectedWord = [text substringWithRange:range];
        NSLog(@"%@",selectedWord);
        NSString *translate = [selectedWord translateString];
        if (translate) {
            [UIAlertView displayMessage:translate];
        }
    }
}

#pragma mark textview delegate functions

- (BOOL)textView:(UITextView *)_textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [_textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)setText:(NSString*)text{
    [myTextView setText:text];
}

- (void)viewDidUnload {
}

- (void)dealloc {
	[array release];
    [super dealloc];
}
@end
