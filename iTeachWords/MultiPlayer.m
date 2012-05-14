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
    isPlaying = YES;
    if (indexFileArray >= [words count]) {
        if (delegate && [(id)delegate respondsToSelector:@selector(playerDidFinishPlayingList:)]){
            [self.delegate playerDidFinishPlayingList:self] ;
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
//        [self incrementFileIndex];
//        [self playNextSound];
//        return;
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
        if (sound && [sound.data length]>0) {
            _data = sound.data;
            if (delegate && [(id)delegate respondsToSelector:@selector(playerDidStartPlayingSound:)]){
                [self.delegate playerDidStartPlayingSound:indexFileArray] ;
            }
            [self startPlayWithData:_data];
        }else{
            if (delegate && [(id)delegate respondsToSelector:@selector(playerDidFinishPlayingSound:)]){
                [self.delegate playerDidFinishPlayingSound:indexFileArray] ;
            }    
            [self incrementFileIndex];
            if (currentSoundType == TRANSLATE) {
                [self performSelector:@selector(playNextSound) withObject:nil afterDelay:.0];
                return;
            }
            [self startTimer];
        }
    }
    return;

}

- (BOOL)isPlaying{
    return [player isPlaying];
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

- (IBAction) closePlayer{
	[self onStopClick:nil];
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionFade; 
	myTransition.duration = 0.2;    
	[self.view.superview.layer addAnimation:myTransition forKey:nil];  
	[self.view removeFromSuperview];
}

#pragma mark - Player functioons

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player successfully:(BOOL)flag{
    if (delegate && [(id)delegate respondsToSelector:@selector(playerDidFinishPlayingSound:)]){
        [self.delegate playerDidFinishPlayingSound:indexFileArray] ;
    }
    [self incrementFileIndex];
    if (currentSoundType == TRANSLATE) {
        [self performSelector:@selector(playNextSound) withObject:nil afterDelay:.5];
        return;
    }
    [self startTimer];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self onStopClick:nil];
}

- (IBAction) onStopClick:(id)sender{
    if (flgTimer) {
        [timer invalidate];
        flgTimer = NO;
    }
	if (player != nil) {
		[player stop];
	}  
    if (delegate && [(id)delegate respondsToSelector:@selector(playerDidClose:)]){
        [self.delegate playerDidClose:self] ;
    }
    [self updatePlayButtonImage];
}

- (IBAction) onRelayClick:(id)sender{
    if (player != nil) {
        if (flgTimer) {
            [timer invalidate];
            flgTimer = NO;
        }
		[player stop];
	}
    indexFileArray = 0;
    [self playNextSound];
    [self updatePlayButtonImage];
}

- (void)dealloc {
    [words release];
    [super dealloc];
}

@end
