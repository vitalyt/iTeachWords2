//
//  MyPlayer.m
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/9/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import "MyPlayer.h"

@implementation MyPlayer

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
	[self onStopClick:nil];
	CATransition *myTransition = [CATransition animation];
	myTransition.timingFunction = UIViewAnimationCurveEaseInOut;
	myTransition.type =kCATransitionFade; 
	myTransition.duration = 0.2;    
	[self.view.superview.layer addAnimation:myTransition forKey:nil];

	[self.view removeFromSuperview];
    if (_delegate && [(id)_delegate respondsToSelector:@selector(playerDidClose:)]){
            [self.delegate playerDidClose:self] ;
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)_player successfully:(BOOL)flag{
    if (_delegate && [(id)_delegate respondsToSelector:@selector(playerDidFinishPlaying:)]){
        [self.delegate playerDidFinishPlaying:self] ;
    }
    [self closePlayer];
}

- (IBAction) startPlayWithData:(NSData *)_data{	
    if (_data && [_data length]>0) {
        NSError *error;
        if (player) {
            [player stop];
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
    [self updatePlayButtonImage];
}

- (IBAction) onStopClick:(id)sender{
	if (player != nil) {
		[player stop];
	}
    [self updatePlayButtonImage];
}

- (IBAction) onPlayClick:(id)sender{
	if (player != nil && ![player isPlaying]) {
		[player play];
        
	}else if(player != nil){
		[player stop];
    }
    [self updatePlayButtonImage];
}

- (IBAction) onRelayClick:(id)sender{
    
}

- (BOOL)isPlaying{
    return [player isPlaying];
}

- (void)updatePlayButtonImage{
    NSString *imageName;
    imageName = @"Play 16x16.png";
	if(player != nil && [player isPlaying]){
        imageName = @"Pause 16x16.png";
    }
    if (playBtn) {
        [playBtn setImage:[UIImage imageNamed:imageName]];
    } 
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self onStopClick:nil];
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags{

}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
