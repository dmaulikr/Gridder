//
//  GRDSoundPlayer.m
//  gridder
//
//  Created by Joshua James on 6/10/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDSoundPlayer.h"

@implementation GRDSoundPlayer

@synthesize menuBlipSoundPlayer, menuBlip2SoundPlayer, menuThemePlayer, shatterSoundBackupPlayer, shatterSoundPlayer,	squareTouchedSoundPlayer, bumpSoundBackupPlayer, bumpSoundPlayer, clockSoundPlayer, pulseFailSoundPlayer, pulseSuccessSoundPlayer, gameThemePlayer, gameOverSoundPlayer, lifeGainedSoundPlayer;

- (void)setupPlayers {
	NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"menutheme" ofType:@"mp3"]];
	menuThemePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	menuThemePlayer.numberOfLoops = -1;
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"playtheme" ofType:@"mp3"]];
	gameThemePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	gameThemePlayer.numberOfLoops = -1;
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"menubeep2" ofType:@"wav"]];
	menuBlipSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"press" ofType:@"wav"]];
	squareTouchedSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"lifegained" ofType:@"wav"]];
	lifeGainedSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"clocknoise" ofType:@"wav"]];
	clockSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gameover" ofType:@"wav"]];
	gameOverSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"menubeep2" ofType:@"wav"]];
	menuBlip2SoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"negativebeep" ofType:@"wav"]];
	pulseFailSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pulse" ofType:@"wav"]];
	pulseSuccessSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shatter" ofType:@"wav"]];
	shatterSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	shatterSoundBackupPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	
	url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bump" ofType:@"wav"]];
	bumpSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
	bumpSoundBackupPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
}

@end
