//
//  MyPlayer.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/9/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "MyPlayer.h"

@implementation MyPlayer

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void) openViewWithAnimation:(UIView *)superView {
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionFade; 
	//myTransition.subtype = kCATransitionFromTop;
	myTransition.duration = 0.2;
	//[self.view.layer addAnimation:myTransition forKey:nil]; 
	[superView.layer addAnimation:myTransition forKey:nil];
	[superView addSubview:self.view];
}

- (IBAction) closePlayer{
	[self onStopClick];
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionFade; 
	myTransition.duration = 0.2;    
	[self.view.superview.layer addAnimation:myTransition forKey:nil];

	[self.view removeFromSuperview];
    if (delegate && [(id)delegate respondsToSelector:@selector(playerDidFinishPlaying:)]){
            [self.delegate playerDidFinishPlaying:self] ;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player successfully:(BOOL)flag{
    if (delegate && [(id)delegate respondsToSelector:@selector(playerDidFinishPlaying:)]){
        [self.delegate playerDidFinishPlaying:self] ;
    }
    [self closePlayer];
}

- (IBAction) startPlayWithData:(NSData *)_data{	
    if (_data) {
        NSError *error;
        if (player) {
            [player stop];
            [player release];
            player = nil;
        }
        player = [[AVAudioPlayer alloc] initWithData:_data error:&error];
        if (player != nil){
            player.delegate = self;
            [player prepareToPlay];
            [player play];
            return;
        }
        [self audioPlayerDidFinishPlaying:player successfully:NO];
    }
}

- (IBAction) onStopClick{
	if (player != nil) {
		[player stop];
	}
}

- (IBAction) onPlayClick{
	if (player != nil) {
		[player play];
	}
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{

}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags{

}

- (void)dealloc {
    if (player != nil) {
		[player release];
        player = nil;
	}
    [super dealloc];
}
@end
