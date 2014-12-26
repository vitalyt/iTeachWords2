//
//  InfoViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 11/10/11.
//  Copyright (c) 2011 OSDN. All rights reserved.
//

#import "InfoViewController.h"
#import "UIAlertView+Interaction.h"

@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [self addInfoButton];
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


#pragma mark my functions

- (void)addMailButton{
    UIImage *icon = [UIImage imageNamed:@"Send 32x32-2.png"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [btn setImage:icon forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendMessageView) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

- (void)sendMessageView{
    if ([iTeachWordsAppDelegate isNetwork]) {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil)
        {
            // We must always check whether the current device is configured for sending emails
            if ([mailClass canSendMail])
            {
                [self displayComposerSheet];
            }
            else
            {
                [self launchMailAppOnDevice];
            }
        }
        else
        {
            [self launchMailAppOnDevice];
        }
    }else{
        [UIAlertView displayError:NSLocalizedString(@"You have not access to this options", @"") title:NSLocalizedString(@"Network connection is not available", @"")];
    }
}

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet 
{
    [UIAlertView displayMessage:@"Всем нам очень важно услышать, насколько наша работа отвечает Вашим ожиданиям.\nИменно Вы и ваше мнение решает какой будет следующая версия продукта." title:@"Ваше мнение очень важно для нас!"];
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	[picker setSubject:@"iStudyWords"];
	
	// Set up recipients
    NSString *feedbackMail = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"FeedbackMailAddress"];
    if (feedbackMail) {
        NSArray *toRecipients = [NSArray arrayWithObject:feedbackMail];
        [picker setToRecipients:toRecipients];
    } 
//	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil]; 
//	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"]; 
	

//	[picker setCcRecipients:ccRecipients];	
//	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"png"];
//    NSData *myData = [NSData dataWithContentsOfFile:path];
//	[picker addAttachmentData:myData mimeType:@"image/png" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = @"Ваши впечатления и предложения.";
	[picker setMessageBody:emailBody isHTML:NO];
	
    picker.navigationBar.barStyle = UIBarStyleBlack;
	[self presentModalViewController:picker animated:YES];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
    UIColor *messageColor = [UIColor greenColor];
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			sendingResult = NSLocalizedString(@"Canseled", @"");
			break;
		case MFMailComposeResultSaved:
			sendingResult = NSLocalizedString(@"Message saved", @"");
			break;
		case MFMailComposeResultSent:
			sendingResult = NSLocalizedString(@"Message sent", @"");
           ;
			break;
		case MFMailComposeResultFailed:
			sendingResult = NSLocalizedString(@"Failed", @"");
            messageColor = [UIColor redColor];
			break;
		default:
			sendingResult = NSLocalizedString(@"Message did not sent", @"");
			break;
	}
	[self dismissModalViewControllerAnimated:YES];
    [UIAlertView showMessage:sendingResult withColor:messageColor];
    
}


#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
    NSString *feedbackMail = [[[NSBundle mainBundle] infoDictionary] objectForKey: @"FeedbackMailAddress"];
    if (feedbackMail) {
        NSString *recipients = [NSString stringWithFormat:@"mailto:%@&subject=iStudyWords",feedbackMail];
        
        NSString *body = @"&body=Ваши впечатления и предложения.";
        
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    } 

}

@end
