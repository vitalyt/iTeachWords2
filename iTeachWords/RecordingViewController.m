//
//  RecordingViewController.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/20/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "RecordingViewController.h"
#import "Sounds.h"
#import "Words.h"
#import "WBRequest.h"
#import "WBConnection.h"

@implementation RecordingViewController

@synthesize fileName,toolsViewDelegate,soundType,delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void) setWord:(Words *)_word withType:(SoundType)type{
    if (word) {
        [word release];
    }
    word = [_word retain];
    
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
    NSData *data = [[NSData alloc]initWithContentsOfURL:recordedTmpFile];
    NSLog(@"%@",data);
    if (data && [data length]>0) {
        [currentSound setData:data];
    }
    
//    NSError *_error;
//    if (![CONTEXT save:&_error]) {
//        [UIAlertView displayError:@"Data is not saved."];
//    }
    [data release];
    data = nil;
    [self.view removeFromSuperview];
    if ((self.delegate)&&([self.delegate respondsToSelector:@selector(recordViewDidClose:)])) {
		[self.delegate recordViewDidClose:self];
	}
}

- (IBAction)play:(id)sender {
    NSData *data;
    data = [[NSData alloc]initWithContentsOfURL:recordedTmpFile];
    [[iTeachWordsAppDelegate sharedDelegate] playSound:data inView:self.view];
    [data release];
}

- (IBAction)close:(id)sender {
    if(activityIndicatorView.hidden == NO){
        [self record:nil];
    }
    if ((self.toolsViewDelegate)&&([(id)self.toolsViewDelegate respondsToSelector:@selector(optionsSubViewDidClose:)])) {
		[self.toolsViewDelegate optionsSubViewDidClose:self];
	}
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
}

- (void) createRecirdingFile:(NSString *)_fileName{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:
                      [[[NSBundle mainBundle] infoDictionary] objectForKey: @"myResource"]];
    path = [path stringByAppendingPathComponent:@"/WordRecords/"];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:path] == NO){
        [fileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (_fileName == nil) {
        _fileName = @"recordingTote";
    }
    path = [path stringByAppendingPathComponent:
            [NSString stringWithFormat: @"%@.%@", _fileName, @"caf"]  ];
    if(recordedTmpFile != nil){
        [recordedTmpFile release];
        recordedTmpFile = nil;
    }
    recordedTmpFile = [[NSURL alloc] initFileURLWithPath:path];
    NSLog(@"Using File called: %@",recordedTmpFile);
}

- (void) startRecordInFile:(NSString *)_fileName{	
    [self createRecirdingFile:_fileName];
    
    NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey]; 
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    if(recorder != nil){
        [recorder release];
        recorder = nil;
    }
    recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile 
                                            settings:recordSetting error:&error];
    [recordSetting release];
    [recorder setDelegate:self];
    [recorder prepareToRecord];
    [recorder record];	
}

- (void)dealloc
{
    if(recordedTmpFile != nil){
        [recordedTmpFile release];
        recordedTmpFile = nil;
    }
    if(recorder != nil){
        [recorder release];
        recorder = nil;
    }    
    if (wbEngine) {
        [wbEngine release];
    }
    //[delegate release];
    [fileName release];
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

- (IBAction) loadFromNetwork{
    activityIndicatorView.hidden = NO;
    [activityIndicatorView startAnimating];
    
    if (!wbEngine) {
        wbEngine = [WBEngine new];
    }
    NSString *text = currentSound.descriptionStr;
    NSString *language;
    if (self.soundType == TRANSLATE) {
        language = [[NSUserDefaults standardUserDefaults] objectForKey:NATIVE_COUNTRY_CODE];
    }else{
        language = [[NSUserDefaults standardUserDefaults] objectForKey:TRANSLATE_COUNTRY_CODE];
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
