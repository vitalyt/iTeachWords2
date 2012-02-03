//
//  RecordingWordViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/20/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "RecordingWordViewController.h"
#import "Sounds.h"
#import "Words.h"
#import "WBRequest.h"
#import "WBConnection.h"

@implementation RecordingWordViewController

@synthesize soundType,isDelayingSaving;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) setWord:(Words *)_word withType:(SoundType)type{
    word = _word;
    [iTeachWordsAppDelegate createUndoBranch];
    currentSound = [NSEntityDescription insertNewObjectForEntityForName:@"Sounds" 
                                                     inManagedObjectContext:CONTEXT];
    [currentSound setWord:word];
    [currentSound setType:[NSNumber numberWithInt:self.soundType]];
    self.soundType = type;
    if (type == TRANSLATE) {
        [currentSound setDescriptionStr:[[word translate] lowercaseString]];
    }else{
        [currentSound setDescriptionStr:[[word text] lowercaseString]];
    }
    [currentSound setCreateDate:[NSDate date]];
}

- (IBAction) saveSound {
    @try {
        NSData *data = [[NSData alloc]initWithContentsOfURL:recordedTmpFile];
        if (data && [data length]>0) {
            [currentSound setData:data];
            [CONTEXT.undoManager endUndoGrouping];
            if (!isDelayingSaving) {
                [self saveCanges];
            }
        }
        else{
            [self undoChngesWord];
        }
        [data  release];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        isSaved = YES;
        [self.view removeFromSuperview];
        if ((self.delegate)&&([self.delegate respondsToSelector:@selector(recordViewDidClose:)])) {
            [self.delegate recordViewDidClose:self];
        }
    }
}

- (void)saveCanges{    
    [iTeachWordsAppDelegate saveDB];
}

- (void)undoChngesWord{
    [iTeachWordsAppDelegate remoneUndoBranch];
}

- (void)dealloc
{    
    if (!isSaved) {
        [self saveSound];
    }
    if (wbEngine) {
        [wbEngine release];
    }
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


- (IBAction)record:(id)sender {
    NSString *imageName;
    if(activityIndicatorView.hidden == YES){
        activityIndicatorView.hidden = NO;
        [activityIndicatorView startAnimating];
        imageName = @"Stop 24x24.png";
        [self startRecordInFile:fileName];
    }
    else{
        activityIndicatorView.hidden = YES;
        [activityIndicatorView stopAnimating];
        imageName = @"Record 24x24.png"; 
        [recorder stop];
        
    }
    if ([sender isKindOfClass:[UIBarButtonItem  class]]) {
        [((UIBarButtonItem *)sender) setImage:[UIImage imageNamed:imageName]];
    }else if([sender isKindOfClass:[UIButton  class]]){
        [((UIButton *)sender) setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
}

- (IBAction) loadFromNetwork{
    activityIndicatorView.hidden = NO;
    [activityIndicatorView startAnimating];
    
    if (!wbEngine) {
        wbEngine = [WBEngine new];
    }
    NSString *text = currentSound.descriptionStr;
    NSString *language;
    if (self.soundType == TRANSLATE) {
        language = NATIVE_LANGUAGE_CODE;
    }else{
        language = TRANSLATE_LANGUAGE_CODE;
    }
    NSString *urlString = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?tl=%@&q=%@",
                           language,
                           text];
    WBRequest * request = [WBRequest getRequestWithURL:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] delegate:self];
    [wbEngine performRequest:request];
}

- (void) connectionDidFinishLoading: (WBConnection*)connection {
    
    activityIndicatorView.hidden = YES;
    [activityIndicatorView stopAnimating];

    NSData *value = [connection data];
    NSLog(@"%@",value);
    if (value && [value length]>0) {
        if (!recordedTmpFile) {
            [self createRecirdingFile:nil];
        }
        
        [value writeToURL:recordedTmpFile atomically:YES];
    }
}
    
@end
