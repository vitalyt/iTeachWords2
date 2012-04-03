//
//  RecordingWordViewController.h
//  iTeachWords
//
//  Created by Edwin Zuydendorp on 1/20/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordingViewController.h"
#import "ToolsViewProtocol.h"
#import "WBEngine.h"

@class Words,Sounds;
@interface RecordingWordViewController : RecordingViewController {
@private
    Sounds          *currentSound;
    Words           *word;
    
    SoundType       soundType;
    WBEngine        *wbEngine;
    
    bool            isDelayingSaving;
    bool            isSaved;
}
@property (nonatomic,assign) SoundType    soundType;
@property (nonatomic, assign) bool isDelayingSaving;

- (void) setWord:(Words *)_word withType:(SoundType)type;


- (IBAction)saveSound:(id)sender;
- (IBAction) loadFromNetwork:(id)sender;
- (void)saveCanges;
- (void)undoChngesWord;

@end
