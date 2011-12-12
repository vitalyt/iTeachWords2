//
//  LM15.m
//  MenuItemTesting
//
//  Created by Vitaly Todorovych on 3/7/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "LM15.h"
#import "LMTableViewController.h"
#import "LMModel.h"

@implementation LM15


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [sentences release];
    [textContent release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) createMenu{
    [self becomeFirstResponder];
    
    NSMutableArray *menuItemsMutableArray = [NSMutableArray new];
    UIMenuItem *menuItem = [[[UIMenuItem alloc] initWithTitle:@"Add word"
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
- (void) firstAction{
    range = myTextView.selectedRange;
    if (range.length > 0) {
        NSMutableString *text = [NSMutableString stringWithString:myTextView.text];
        NSString *selectedWord      = [text substringWithRange:range];
        
        NSArray *words = [NSArray arrayWithArray:[text componentsSeparatedByString:@" "]];
        
        NSString *key = @"";
        for (int i = 0; i < [words count]; i++){
            if ([selectedWord isEqualToString:[words objectAtIndex:i]]) {
                key = [NSString stringWithFormat:@"%d",i+1];
            }
        }
        [((NSMutableDictionary *)[wordsInSentence objectAtIndex:sentenceIndex]) setObject:selectedWord forKey:key];
        NSLog(@"%@",((NSMutableDictionary *)[wordsInSentence objectAtIndex:sentenceIndex]));
        //NSString *replacingString   = [NSString stringWithFormat:@"%%%i",[model.wordsStore count] + 1];
        model.wordsStore = (NSMutableArray *)[[wordsInSentence objectAtIndex:sentenceIndex] allObjects];
        if (myTableView) {
            [myTableView.myTable reloadData];
        }
        
       /* [text replaceCharactersInRange:range withString:replacingString];
        myTextView.scrollEnabled = NO;
        myTextView.text = text;
        myTextView.scrollEnabled = YES; */
        // [myTextView scrollRangeToVisible:range];
    }
}




- (IBAction)buttonAction:(id)sender {
    if (!flgTableShowing) {
        [myTextView resignFirstResponder];
        if (myTableView == nil) {
            myTableView = [[LMTableViewController alloc] initWithNibName:@"LMTableViewController" bundle:nil];
        }
        model.wordsStore = (NSMutableArray *)[[wordsInSentence objectAtIndex:sentenceIndex] allObjects];
        [self.view addSubview:myTableView.view];
    }
    else{
        [myTableView.view removeFromSuperview];
    }
    flgTableShowing = !flgTableShowing;
}



- (void)createModelFile {
    NSMutableString *content = [[NSMutableString alloc] init];
    [content appendFormat:@"<B\n0\n0\n0\n15.0\n0"];
    [content appendFormat:@"\n<Q"];   
    for(int i = 0; i < [sentences count]; i++){
        [content appendFormat:@"\n%@.",[sentences objectAtIndex:i]];
        NSArray *words = [((NSDictionary *)[wordsInSentence objectAtIndex:i]) allKeys];
        for(int j = 0; j < [words count]; j++){
            [content appendFormat:@"^%@",[words objectAtIndex:j]];
            if (j+1 < [words count]) {
                [content appendFormat:@","];
            }
        }  
    }
    [content appendFormat:@"\n<A"];
    [content appendFormat:@"\nТекст по русски."];
    [content appendFormat:@"\n"];
    
    NSString *pathOfDocuments = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"LessonResouce"]];
    NSString *lessonFolder = [pathOfDocuments stringByAppendingPathComponent:lessonName];
    NSString *path = [lessonFolder stringByAppendingPathComponent:@"1.txt"];
    
    [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@\n",content);
    [content release];
}
@end
