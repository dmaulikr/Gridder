//
//  GRDSoundPlayer.h
//  gridder
//
//  Created by Joshua James on 6/10/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface GRDSoundPlayer : NSObject

@property (strong, nonatomic) AVAudioPlayer *menuThemePlayer;
@property (strong, nonatomic) AVAudioPlayer *gameThemePlayer;
@property (strong, nonatomic) AVAudioPlayer *menuBlipSoundPlayer;
@property (strong, nonatomic) AVAudioPlayer *squareTouchedSoundPlayer;
@property (strong, nonatomic) AVAudioPlayer *lifeGainedSoundPlayer;
@property (strong, nonatomic) AVAudioPlayer *pulseSuccessSoundPlayer;
@property (strong, nonatomic) AVAudioPlayer *pulseFailSoundPlayer;
@property (strong, nonatomic) AVAudioPlayer *clockSoundPlayer;
@property (strong, nonatomic) AVAudioPlayer *gameOverSoundPlayer;
@property (strong, nonatomic) AVAudioPlayer *menuBlip2SoundPlayer;
@property (strong, nonatomic) AVAudioPlayer *bumpSoundPlayer;
@property (strong, nonatomic) AVAudioPlayer *bumpSoundBackupPlayer;
@property (strong, nonatomic) AVAudioPlayer *shatterSoundPlayer;
@property (strong, nonatomic) AVAudioPlayer *shatterSoundBackupPlayer;

- (void)setupPlayers;

@end
