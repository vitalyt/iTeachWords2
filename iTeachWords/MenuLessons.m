//
//  MenuLessons.m
//  iTeachWords
//
//  Created by  user on 03.07.11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "MenuLessons.h"
#import "LM7.h"
#import "LM15.h"
#import "Test7.h"
#import "Test15.h"
#import "MyData.h"

@implementation MenuLessons

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addLesson)];
    }
    return self;
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
    [self loadData];
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

- (void) loadData{
    NSString *pathOfLessonResouce = [NSHomeDirectory() stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey: @"LessonResouce"]];
    NSMutableArray *ar = [[NSMutableArray alloc]  initWithArray:[[NSFileManager defaultManager] contentsOfDirectoryAtPath:pathOfLessonResouce error:nil]];
    //[ar removeObjectAtIndex:0];
	data = ar;
    [table reloadData];
}

- (void) addLesson{
    LM15 *lessonMaker = [[LM15 alloc] initWithNibName:@"LM15" bundle:nil];
    [self.navigationController pushViewController:lessonMaker animated:YES];
    lessonMaker.textContent = @"Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user. Quits the application and it begins the transition to the background state.";    
    
//    LM7 *lessonMaker = [[LM7 alloc] initWithNibName:@"LM7" bundle:nil];
//    [self.navigationController pushViewController:lessonMaker animated:YES];
//    lessonMaker.textContent = @"Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user. Quits the application and it begins the transition to the background state.";
//    [lessonMaker release];

}

- (void) configureCell:(UITableViewCell *)theCell forRowAtIndexPath:(NSIndexPath *)indexPath{
    theCell.textLabel.text = [data objectAtIndex:indexPath.row];
    // [theCell.imageView setImage:[UIImage imageNamed:[contentImageArray objectAtIndex:indexPath.row]]];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self loadLesson:[data objectAtIndex:indexPath.row]];
}


- (NSMutableArray *)loadLesson:(NSString *)lessonName{
	MyData *_data = [[MyData alloc] initWithLesson:lessonName];
	
    switch ([[_data.options objectAtIndex:3] intValue]) {
		case 15:
        {
        	Test15 *test15 = [[Test15 alloc] initWithNibName:@"Test15" bundle:nil];
            test15.words = [[NSMutableArray alloc] initWithArray:[_data convertData]];
            test15.lessonName = lessonName;
            [self.navigationController pushViewController:test15 animated:YES];
        }
			break;
		case 7:
        {	
            Test7 *test7 = [[Test7 alloc] initWithNibName:@"Test7" bundle:nil];
            test7.words = [[NSMutableArray alloc] initWithArray:[_data convertData]];
            test7.lessonName = lessonName;
            [self.navigationController pushViewController:test7 animated:YES];
        }
			break;
		default:
			[table reloadData];
			break;
	}
	NSMutableArray *_array = (NSMutableArray *)[_data convertData];
	return _array;
}

@end
