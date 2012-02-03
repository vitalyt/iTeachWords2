//
//  RecordModel.m
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/19/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "RecordModel.h"

@implementation RecordModel

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
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance]; 
//    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];    
}

- (void) startRecordInFile:(NSString *)_fileName{	
    [self createRecirdingFile:_fileName];
    
//    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
//    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
//    [audioSession setActive:YES error: &error];
    
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
    [recorder setMeteringEnabled:YES];
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
    [super dealloc];
}

@end
