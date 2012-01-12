//
//  LMTextViewController.m
//  MenuItemTesting
//
//  Created by Vitaly Todorovych on 3/3/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "LMTextViewController.h"
#import "LMTableViewController.h"
#import "LMModel.h"

@implementation LMTextViewController

@synthesize textContent,lessonName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        sentences       = [[NSMutableArray alloc] init];
        wordsInSentence = [[NSMutableArray alloc] init];
        lessonName      = [[NSString alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [lessonName release];
    if (sentences) {
        //[sentences release];
    }
    [wordsInSentence release];
    [myTableView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)setTextContent:(NSString *)_str
{
    if (textContent != _str) {
        [textContent release];
        textContent = [_str retain];
        [sentences removeAllObjects];
        [wordsInSentence removeAllObjects];
        sentenceIndex = 0;
        
        [sentences setArray:[textContent componentsSeparatedByString:@"."]];
        for (int i = 0; i < [sentences count]; i++) {
            NSMutableDictionary *ar = [[NSMutableDictionary alloc] init];
            [wordsInSentence addObject:ar];
            [ar release];
        }
        myTextView.text = [sentences objectAtIndex:sentenceIndex];
    }
}

#pragma mark - View lifecycle



- (IBAction)nextSentence:(id)sender {
    if ((sentenceIndex + 1) >= [sentences count]) {
        return;
    }
    ++sentenceIndex;
    myTextView.text = [sentences objectAtIndex:sentenceIndex];
    
    if (myTableView) {
        model.wordsStore = (NSMutableArray *)[[wordsInSentence objectAtIndex:sentenceIndex] allObjects];
        [myTableView.myTable reloadData];
    }
    
}

- (IBAction)prevSentence:(id)sender {
    if ((sentenceIndex - 1) < 0) {
        return;
    }
    --sentenceIndex;
    myTextView.text = [sentences objectAtIndex:sentenceIndex];

    if (myTableView) {
        model.wordsStore = (NSMutableArray *)[[wordsInSentence objectAtIndex:sentenceIndex] allObjects];
        [myTableView.myTable reloadData];
    }
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createMenu];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //[self createMenu];
    /*if ([touches count] == 1) {
     UIMenuController *menuController = [UIMenuController sharedMenuController];
     
     if (menuController.menuVisible) {
     [menuController setMenuVisible:NO
     animated:YES];
     
     [self resignFirstResponder];
     }
     }*/
}

- (void) createMenu{
    [self becomeFirstResponder];
    NSMutableArray *menuItemsMutableArray = [NSMutableArray new];
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:@"First Action"
                                                       action:@selector(firstAction)] autorelease];
    
    UIMenuItem *menuItem2 = [[[UIMenuItem alloc] initWithTitle:@"Second Action"
                                                        action:@selector(secondAction)] autorelease];
    [menuItemsMutableArray addObject:menuItem];
    [menuItemsMutableArray addObject:menuItem2];
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    [menuController setTargetRect: CGRectMake(0, 0, 320, 200)
                           inView:self.view];
    menuController.menuItems = menuItemsMutableArray;
    [menuController setMenuVisible:YES
                          animated:YES];
    [[UIMenuController sharedMenuController] setMenuItems:menuItemsMutableArray];
    [menuItemsMutableArray release];
}

- (BOOL) canBecomeFirstResponder{
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [myTextView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width, 195.0)];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [myTextView setFrame:CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.size.width,  395.0)];
}

- (void) firstAction{
    range = myTextView.selectedRange;
    if (range.length > 0) {
        NSMutableString *text = [NSMutableString stringWithString:myTextView.text];
        NSString *selectedWord      = [text substringWithRange:range];
        NSString *replacingString   = [NSString stringWithFormat:@"%%%i",[model.wordsStore count] + 1];
        [[model mutableArrayValueForKey:@"wordsStore"] addObject:selectedWord];
       // [model.wordsStore addObject:selectedWord];
        [text replaceCharactersInRange:range withString:replacingString];
        myTextView.scrollEnabled = NO;
        myTextView.text = text;
        myTextView.scrollEnabled = YES; 
        // [myTextView scrollRangeToVisible:range];
    }
}

- (void) secondAction{
    
}

- (IBAction)saveLesson{
    [self addingNameForLesson];
}

-(void) addingNameForLesson{
    UIAlertView *nameAllert = [[UIAlertView alloc]initWithTitle:@"" message:@"Enter name for lesson." delegate:self cancelButtonTitle:@"Cansel" otherButtonTitles:@"Ok", nil];
    NSString *text = @"";
    if (lessonName) {
        text = lessonName;
    }
    [nameAllert addTextFieldWithValue:text label:@"Lesson name"];
    //UITextField *nameField = [[UITextField alloc]initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
    //[nameAllert addSubview:nameField];
    [nameAllert show];
    //[nameField release];
    [nameAllert release];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        lessonName = [[NSString stringWithFormat:@"%@",((UITextField*)[alertView textField]).text] retain];
        NSLog(@"%@",lessonName);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *pathOfDocuments = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"LessonResouce"]];
        NSString *lessonFolder = [pathOfDocuments stringByAppendingPathComponent:lessonName];
        
        if (![fileManager fileExistsAtPath:lessonFolder]){
            //[fileManager createDirectoryAtPath:lessonFolder attributes:nil];
            [fileManager createDirectoryAtPath:lessonFolder withIntermediateDirectories:YES attributes:nil error:nil];
        }
        [self createModelFile];
    }
}

- (void)createModelFile {

}
@end
