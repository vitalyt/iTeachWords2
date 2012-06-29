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
    if (!isSaved && currentSound) {
        [self undoChngesWord];
    }
    word = _word;
    isSaved = NO;
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

- (IBAction) saveSound:(id)sender {
    if (IS_HELP_MODE && sender && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }

    @try {
        NSData *data = [[NSData alloc]initWithContentsOfURL:recordedTmpFile];
        if (data && [data length]>0 && currentSound) {
            [currentSound setData:data];
            if (!isDelayingSaving) {
                [self saveCanges];
            }else{
                [CONTEXT.undoManager endUndoGrouping];
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
        [self.view removeFromSuperview];
        if ((self.delegate)&&([self.delegate respondsToSelector:@selector(recordViewDidClose:)])) {
            [self.delegate recordViewDidClose:self];
        }
    }
}

- (IBAction)play:(id)sender {
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
    
    NSData *data;
    data = [[NSData alloc]initWithContentsOfURL:recordedTmpFile];
    [[iTeachWordsAppDelegate sharedDelegate] playSound:data inView:self.view];
    [data release];
}

- (void)saveCanges{    
    isSaved = YES;
    [iTeachWordsAppDelegate saveUndoBranch];
}

- (void)undoChngesWord{
    isSaved = YES;
    [iTeachWordsAppDelegate remoneUndoBranch];
}

- (void)dealloc
{    
    if (!isSaved) {
        [self undoChngesWord];
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
    [self.view setBackgroundColor:[UIColor clearColor]];
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
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }
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

- (IBAction) loadFromNetwork:(id)sender{
    if (IS_HELP_MODE && sender && [usedObjects indexOfObject:sender] == NSNotFound) {
        _currentSelectedObject = sender;
        [_hint presentModalMessage:[self helpMessageForButton:sender] where:self.view.superview];
        return;
    }

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
        if ([language isEqualToString:@"UK"]) {
            language = @"EN";
        }
    }
    NSString *urlString = [NSString stringWithFormat:@"http://translate.google.com/translate_tts?ie=UTF-8&q=%@&tl=%@&client=webapp",
                           text,
                           language];
    WBRequest * request = [WBRequest getRequestWithURL:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] delegate:self];
    [wbEngine performRequest:request];
    NSLog(@"%@",urlString);
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

-(UIView*)hintStateViewForDialog:(id)hintState
{
    CGRect frame = self.view.superview.frame;
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width-20, frame.size.height/3)];
    l.numberOfLines = 4;
    [l setTextAlignment:UITextAlignmentCenter];
    [l setBackgroundColor:[UIColor clearColor]];
    [l setTextColor:[UIColor whiteColor]];
    [l setText:[self helpMessageForButton:_currentSelectedObject]];
    return [l autorelease];
}

- (NSString*)helpMessageForButton:(id)_button{
    NSString *message = nil;
    int index = ((UIBarButtonItem*)_button).tag+1;
    switch (index) {
        case 1:
            message = NSLocalizedString(@"Запись собственной озвучки", @"");
            break;
        case 2:
            message = NSLocalizedString(@"Поиск озвучки в интернете", @"");
            break;
        case 3:
            message = NSLocalizedString(@"Воспроизведение", @"");
            break;
        case 4:
            message = NSLocalizedString(@"Сохранение", @"");
            break;
            
        default:
            break;
    }
    return message;
}

-(UIView*)hintStateViewToHint:(id)hintState
{
    [usedObjects addObject:_currentSelectedObject];
    UIView *buttonView = nil;
    UIView *view = _currentSelectedObject;
    CGRect frame = view.frame;
    buttonView = [[[UIView alloc] initWithFrame:frame] autorelease];
    [buttonView setFrame:CGRectMake(frame.origin.x+self.view.frame.origin.x, frame.origin.y+self.view.frame.origin.y, frame.size.width, frame.size.height)];
    return buttonView;
}

    
@end
