//
//  MultiPlayer.h
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/19/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyPlayer.h"

@interface MultiPlayer : MyPlayer {
    IBOutlet UISlider *mySlider;
    
    NSArray         *words;
    
	NSTimer			*timer;
	BOOL			flgTimer;
	int				indexFileArray;
	double			pauseInterval;
    
    BOOL            isPlaying;
    
    SoundType       currentSoundType;
}

@property (nonatomic,retain) NSArray * words;
@property (nonatomic,assign) SoundType currentSoundType;

- (void) playList:(NSArray *)list;
- (void) playNextSound;
- (void) startTimer;
- (void) incrementFileIndex;
- (IBAction) changeSlider:(id)sender;

@end
