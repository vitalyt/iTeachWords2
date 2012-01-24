//
//  VoiceRecordingViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/23/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "RecordingViewController.h"

@interface VoiceRecordingViewController : RecordingViewController{
    IBOutlet UIView *recordingView;
    int     status;

}

- (IBAction)help:(id)sender;
@end
