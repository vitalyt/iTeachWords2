//
//  RecordModel.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/19/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@protocol RecordingViewProtocol <NSObject>
@optional
- (void) recordViewDidClose:(id)sender;
@end


@interface RecordModel : UIViewController <AVAudioRecorderDelegate>{
    NSString        *fileName;
    NSURL           *recordedTmpFile;
    AVAudioRecorder *recorder;
	NSError			*error;
    
}

- (void) createRecirdingFile:(NSString *)_fileName;
- (void) startRecordInFile:(NSString *)fileName;

@end
