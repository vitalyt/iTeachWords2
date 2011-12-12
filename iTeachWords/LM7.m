//
//  LM7.m
//  MenuItemTesting
//
//  Created by Vitaly Todorovych on 3/7/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "LM7.h"
#import "LMTableViewController.h"
#import "LMModel.h"

@implementation LM7

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

- (IBAction)buttonAction:(id)sender {
    if (!flgTableShowing) {
        [myTextView resignFirstResponder];
        if (myTableView == nil) {
            myTableView = [[LMTableViewController alloc] initWithNibName:@"LMTableViewController" bundle:nil];
        }
        [self.view addSubview:myTableView.view];
    }
    else{
        [myTableView.view removeFromSuperview];
    }
    flgTableShowing = !flgTableShowing;
}

- (void)createModelFile {
    NSMutableString *content = [[NSMutableString alloc] init];
    [content appendFormat:@"<B\n0\n0\n0\n7.0\n0\n<Q\n"];
    [content appendFormat:@"Текст по русски."];
    [content appendFormat:@"^"];
    for (int i = 0; i < [model.wordsStore count]; i++) {
        [content appendFormat:@"%@",[model.wordsStore objectAtIndex:i]];
        if (i+1 < [model.wordsStore count]) {
            [content appendFormat:@","];
        }
    }
    [content appendFormat:@"\n<A"];
    NSString *text = myTextView.text;
    NSArray *ar = [[NSArray alloc] initWithArray:[text componentsSeparatedByString:@"."]];
    
    for (NSString *str in ar) {
        if ([str length] > 0) {
            [content appendFormat:@"\n%@.",str];
        }
    }
    [content appendFormat:@"\n"];
    [ar release];
    
    NSString *pathOfDocuments = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"LessonResouce"]];
    NSString *lessonFolder = [pathOfDocuments stringByAppendingPathComponent:lessonName];
    NSString *path = [lessonFolder stringByAppendingPathComponent:@"1.txt"];
    
    [content writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@\n",content);
    [content release];
}

- (void)setTextContent:(NSString *)_str
{
    if (textContent != _str) {
        [textContent release];
        textContent = [_str retain];
        [sentences removeAllObjects];
        [wordsInSentence removeAllObjects];
        sentenceIndex = 0;
        
//        [sentences setArray:[textContent componentsSeparatedByString:@"."]];
//        for (int i = 0; i < [sentences count]; i++) {
//            NSMutableDictionary *ar = [[NSMutableDictionary alloc] init];
//            [wordsInSentence addObject:ar];
//            [ar release];
//        }
        myTextView.text = textContent;
    }
}
@end
