//
//  MyPlayerProtocol.h
//  Untitled
//
//  Created by Edwin Zuydendorp on 10/8/10.
//  Copyright 2010 OSDN. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyPlayerProtocol
@optional
- (void) playerDidStartPlayingSound:(int)soundIndex;
- (void) playerDidFinishPlayingSound:(int)soundIndex;
- (void) playerDidFinishPlaying:(id)sender;
- (void) playerStartPlaying:(id)sender;


@end
