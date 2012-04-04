//
//  MultiPlayer.m
//  iTeachWords
//
//  Created by Vitaly Todorovych on 5/19/11.
//  Copyright 2011 OSDN. All rights reserved.
//

#import "MultiPlayer.h"
#import "Words.h"
#import "Sounds.h"

@implementation MultiPlayer

@synthesize words,currentSoundType;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mySlider setValue:0.0];
    self.view.layer.cornerRadius = 8;
}
- (void) playList:(NSArray *)list{
    self.words = list;
    indexFileArray = 0;
    currentSoundType = TEXT;
    [self playNextSound];
    
}

- (void) loadData{
    
}

- (void) playNextSound{
    if (indexFileArray >= [words count]) {
        if (delegate && [(id)delegate respondsToSelector:@selector(playerDidFinishPlaying:)]){
            [self.delegate playerDidFinishPlaying:self] ;
        }
        [self closePlayer];
        return;
    }
    
    NSData *_data;
    Words *word = [words objectAtIndex:indexFileArray];

    NSString *description;
    if (currentSoundType == TEXT) {
        description = word.text;
    }else{
        description = word.translate;
        [self incrementFileIndex];
        [self playNextSound];
        return;
    }
    NSLog(@"plaing word ->%@",description);
    if (description) {
        NSError *error;
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"descriptionStr == %@", [description lowercaseString]];
        NSFetchRequest * request = [[[NSFetchRequest alloc] init] autorelease];
        [request setEntity:[NSEntityDescription entityForName:@"Sounds" inManagedObjectContext:[iTeachWordsAppDelegate sharedContext]]];
        [request setFetchLimit:1];  
        [request setFetchOffset:0];
        [request setPredicate:predicate];
        [request setRelationshipKeyPathsForPrefetching:nil];
        [request setPropertiesToFetch:[NSArray arrayWithObjects:@"data", nil]];
        
        
        Sounds *sound = [[[iTeachWordsAppDelegate sharedContext] executeFetchRequest:request error:&error] lastObject];
        //_data = sound.data;
        if (sound) {
            _data = sound.data;
            if (delegate && [(id)delegate respondsToSelector:@selector(playerDidStartPlayingSound:)]){
                [self.delegate playerDidStartPlayingSound:indexFileArray-1] ;
            }
            [self startPlayWithData:_data];
        }else{
            if (delegate && [(id)delegate respondsToSelector:@selector(playerDidFinishPlayingSound:)]){
                [self.delegate playerDidFinishPlayingSound:indexFileArray] ;
            }    
            [self incrementFileIndex];
            [self playNextSound];
        }
    }
    return;

}

- (void) startTimer{
	timer	= [NSTimer scheduledTimerWithTimeInterval:pauseInterval 
											 target:self 
										   selector:@selector(handleTimer:)
										   userInfo:nil 
											repeats:YES
			   ];
	flgTimer = YES;
}

- (void) handleTimer:(NSTimer *)_timer{
	[_timer invalidate];
	flgTimer = NO;
	[self playNextSound];
}

- (void) incrementFileIndex{
    if (currentSoundType == TEXT) {
        currentSoundType = TRANSLATE;
    }else{
        currentSoundType = TEXT;
        ++indexFileArray;
    }
}

#pragma matk - Action functions

- (IBAction) changeSlider:(id)sender{
	pauseInterval = ((UISlider *)sender).value * 10.0;
}

#pragma mark - Player functioons

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player successfully:(BOOL)flag{
    if (delegate && [(id)delegate respondsToSelector:@selector(playerDidFinishPlayingSound:)]){
        [self.delegate playerDidFinishPlayingSound:indexFileArray] ;
    }
    [self incrementFileIndex];
    [self startTimer];
}


- (IBAction) onStopClick{
	if (player != nil) {
        if (flgTimer) {
            [timer invalidate];
            flgTimer = NO;
        }
		[player stop];
	}
    if (delegate && [(id)delegate respondsToSelector:@selector(playerDidFinishPlayingSound:)]){
        [self.delegate playerDidFinishPlayingSound:indexFileArray] ;
    }   
}

- (void)dealloc {
    [words release];
    [super dealloc];
}

@end
