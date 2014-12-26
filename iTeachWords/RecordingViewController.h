//
//  RecordingViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/19/12.
//  Copyright (c) 2012 OSDN. All rights reserved.
//

#import "RecordModel.h"
#import "ToolsViewProtocol.h"

@interface RecordingViewController : RecordModel{
    IBOutlet UIActivityIndicatorView *activityIndicatorView;
    IBOutlet UIView *vuMeter;
    IBOutlet UIBarButtonItem *recordButton;
    
    bool    isRecording;
    
    NSTimer *meterTimer;
}

@property (nonatomic,assign) id <RecordingViewProtocol>  delegate;
@property (nonatomic,assign) id <ToolsViewProtocol>  toolsViewDelegate;

- (void)runTimer;
- (float)materViewWidth;
- (void)setVUMeterWidth:(float)width;

- (IBAction)record:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)close:(id)sender;

@end
