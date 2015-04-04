//
//  GRDSoundPlayer.m
//  gridder
//
//  Created by Joshua James on 6/10/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDSoundPlayer.h"

@implementation GRDSoundPlayer

+ (GRDSoundPlayer *)sharedInstance {
	static GRDSoundPlayer *_sharedInstance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[GRDSoundPlayer alloc] init];
		
		NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"menutheme" ofType:@"mp3"]];
		_sharedInstance.menuThemePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		_sharedInstance.menuThemePlayer.numberOfLoops = -1;
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"playtheme" ofType:@"mp3"]];
		_sharedInstance.gameThemePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		_sharedInstance.gameThemePlayer.numberOfLoops = -1;
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"menubeep2" ofType:@"wav"]];
		_sharedInstance.menuBlipSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"lifegained" ofType:@"wav"]];
		_sharedInstance.lifeGainedSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"clocknoise" ofType:@"wav"]];
		_sharedInstance.clockSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"gameover" ofType:@"wav"]];
		_sharedInstance.gameOverSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"match" ofType:@"wav"]];
		_sharedInstance.menuBlip2SoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"negativebeep" ofType:@"wav"]];
		_sharedInstance.pulseFailSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pulse" ofType:@"wav"]];
		_sharedInstance.pulseSuccessSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"shatter" ofType:@"wav"]];
		_sharedInstance.shatterSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		_sharedInstance.shatterSoundBackupPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"bump" ofType:@"wav"]];
		_sharedInstance.bumpSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		_sharedInstance.bumpSoundBackupPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];

		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"press" ofType:@"wav"]];
		_sharedInstance.squareTouchedSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pulse" ofType:@"wav"]];
		_sharedInstance.pulseSuccessSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
		
		url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"negativebeep" ofType:@"wav"]];
		_sharedInstance.pulseFailSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];

		
	});
	
	return _sharedInstance;
}

@end
