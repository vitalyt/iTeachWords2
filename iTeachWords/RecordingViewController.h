//
//  RecordingViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/20/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "ToolsViewProtocol.h"
#import "RecordingViewProtocol.h"
#import "WBEngine.h"

@class Words,Sounds;
@interface RecordingViewController : UIViewController <AVAudioRecorderDelegate> {
@private
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
    NSString        *fileName;
    NSURL           *recordedTmpFile;
    AVAudioRecorder *recorder;
	NSError			*error;
    
    Sounds          *currentSound;
    Words           *word;
    id	<ToolsViewProtocol> toolsViewDelegate;
    id	<RecordingViewProtocol> delegate;
    
    SoundType       soundType;
    WBEngine                *wbEngine;
}
@property (nonatomic,retain) NSString *fileName;
@property (nonatomic,retain) id <ToolsViewProtocol>  toolsViewDelegate;
@property (nonatomic,retain) id <RecordingViewProtocol>  delegate;
@property (nonatomic,assign) SoundType    soundType;

- (IBAction)record:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction) saveSound;

- (void) setWord:(Words *)_word withType:(SoundType)type;
- (void) createRecirdingFile:(NSString *)_fileName;
- (void) startRecordInFile:(NSString *)fileName;
- (IBAction) loadFromNetwork;
@end
