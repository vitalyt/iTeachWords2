//
//  MyPlayer.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 6/9/10.
//  Copyright 2010 OSDN. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "MyPlayerProtocol.h"

@interface MyPlayer : UIViewController <AVAudioPlayerDelegate>{
	AVAudioPlayer           *player;
    IBOutlet UIBarButtonItem *playBtn;
}

@property (nonatomic,weak) id <MyPlayerProtocol> delegate;

- (IBAction) startPlayWithData:(NSData *)_data;
- (void)     openViewWithAnimation:(UIView *) superView;
- (IBAction) closePlayer;
- (IBAction) onStopClick:(id)sender;
- (IBAction) onPlayClick:(id)sender;
- (IBAction) onRelayClick:(id)sender;
- (void)updatePlayButtonImage;

- (BOOL)isPlaying;

@end
