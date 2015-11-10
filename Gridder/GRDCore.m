//
//  GRDWizard.m
//  gridder
//
//  Created by Joshua James on 1/10/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDCore.h"
#import "GRDAppDelegate.h"
#import "GRDAnimator.h"

#define POINT_MOD_EASY 10
#define POINT_MOD_MEDIUM 20
#define POINT_MOD_HARD 30
#define BUFFER_THRESHOLD 1

@implementation GRDCore

+ (GRDCore *)sharedInstance {
	static GRDCore *_sharedInstance = nil;
	static dispatch_once_t oncePredicate;
	dispatch_once(&oncePredicate, ^{
		_sharedInstance = [[GRDCore alloc] init];
		
		_sharedInstance.greaterGridSquares = [[NSMutableArray alloc] init];
		_sharedInstance.lesserGridSquares = [[NSMutableArray alloc] init];
		//_sharedInstance.gridColour = [UIColor orangeColor];
		_sharedInstance.gridTransitionColour = [UIColor purpleColor];
		
	});
	
	return _sharedInstance;
}

- (void)startNewGame {
	self.rounds = 0;
	self.lives = 3;
	self.score = 0;
	self.streak = 0;
	self.onTheEdgeStreak = 0;
	self.activationCandidates = [[NSMutableArray alloc] init];
	
	self.difficultyLevel = DifficultyLevelEasy;
}

- (void)setDifficultyLevel:(DifficultyLevel)difficultyLevel {
	id<GRDWizardProtocol> strongDelegate = self.delegate;
	if ([strongDelegate respondsToSelector:@selector(wizardDidAdjustDifficultyLevel:)]) {
		[self.delegate wizardDidAdjustDifficultyLevel:difficultyLevel];
	}
	
	_difficultyLevel = difficultyLevel;
	
	switch (difficultyLevel) {
		case DifficultyLevelHard:
			self.gridColour = [UIColor purpleColor];
			self.gridTransitionColour = [UIColor orangeColor];
			break;
		case DifficultyLevelMedium:
			self.gridColour = [UIColor blueColor];
			self.gridTransitionColour = [UIColor greenColor];
			break;
		case DifficultyLevelEasy:
		default:
			//self.gridColour = [UIColor orangeColor];
			self.gridTransitionColour = [UIColor purpleColor];
			break;
	}
	
	for (GRDSquare *square in [GRDCore sharedInstance].greaterGridSquares) {
		square.backgroundColor = self.gridColour;
	}
	for (GRDSquare *square in [GRDCore sharedInstance].lesserGridSquares) {
		square.backgroundColor = self.gridColour;
	}
}


+ (void)gainPoints:(GRDPrimeViewController *)vc {
    long pointsGained;
    
    long timeLeft = ((vc.maximumTimeAllowed - vc.timeElapsed) / 100) + BUFFER_THRESHOLD;
    
    if ([GRDCore sharedInstance].difficultyLevel == DifficultyLevelEasy) {
        pointsGained = timeLeft * POINT_MOD_EASY;
    } else if ([GRDCore sharedInstance].difficultyLevel == DifficultyLevelMedium) {
        pointsGained = timeLeft * POINT_MOD_MEDIUM;
    } else {
        pointsGained = timeLeft * POINT_MOD_HARD;
    }
    
    [GRDCore sharedInstance].score = [GRDCore sharedInstance].score + pointsGained;
    
	vc.scoreGainedFader.text = [NSString stringWithFormat:@"+%ld", pointsGained];
	vc.scoreGainedFader.alpha = 1.0f;
	[vc.scoreLabel setText:[NSString stringWithFormat:@"%ld", [GRDCore sharedInstance].score]];
    
    [GRDAnimator animateBox:vc.scoreBox];
	[GRDAnimator animatePointsGained:vc];
}

+ (void)loseALife:(GRDPrimeViewController *)vc {
	[GRDCore sharedInstance].lives--;
	
    [GRDAnimator animateBox:vc.lifeBox];
    
	[[GRDSoundPlayer sharedInstance].pulseFailSoundPlayer play];
	
	if ([GRDCore sharedInstance].lives == 0) {
		[vc.pulseTimer invalidate];
		vc.pulseTimer = nil;
		[[GRDCore sharedInstance] startNewGame];
		
		[vc.livesLabel setText:[NSString stringWithFormat:@"%d", [GRDCore sharedInstance].lives]];
		[vc.scoreLabel setText:[NSString stringWithFormat:@"%ld", [GRDCore sharedInstance].score]];
		
		[vc randomiseLesserGrid];
		[[GRDSoundPlayer sharedInstance].gameThemePlayer stop];
		
		return;
	}
	
	[vc.livesLabel setText:[NSString stringWithFormat:@"%d", [GRDCore sharedInstance].lives]];
	
	[vc.lifeFader setText:@"-1"];
	
	[GRDAnimator animateLifeFade:vc];
}

+ (void)gainALife:(GRDPrimeViewController *)vc {
	[GRDCore sharedInstance].lives++;
	
    [GRDAnimator animateBox:vc.lifeBox];

	[vc.livesLabel setText:[NSString stringWithFormat:@"%d", [GRDCore sharedInstance].lives]];
	[vc.lifeFader setText:@"+1"];
	
	[GRDAnimator animateLifeFade:vc];
}


+ (BOOL)gridComparisonMatches:(NSMutableArray *)greaterGrid compareWith:(NSMutableArray *)lesserGrid {
	
	for (int x = 1; x < 16; x++) {
		if ([GRDCore squareForPosition:x fromGrid:greaterGrid].isActive != [GRDCore squareForPosition:x fromGrid:lesserGrid].isActive) {
			return NO;
		}
	}
	
	return YES;
}

+ (GRDSquare *)squareForPosition:(NSInteger)pos fromGrid:(NSMutableArray *)grid {
	for (GRDSquare *square in grid) {
		if (square.tag == pos) {
			return square;
		}
	}
	
	return nil;
}

/*
+ (void)gainALife:(GRDViewController *)grdVC {
	GRDAppDelegate *delegate = (GRDAppDelegate *)[[UIApplication sharedApplication] delegate];

	delegate.numLives++;
	
	if (delegate.numLives >= 8) {
		[delegate.menuVC.gameCenterManager submitAchievement:kAchievementGlutton percentComplete:100];
	}
	
	if (delegate.soundIsActive) [delegate.soundPlayer.lifeGainedSoundPlayer play];
	grdVC.livesDisplay.text = [NSString stringWithFormat:@"%d", delegate.numLives];
	
	UILabel *lifeGained = [[UILabel alloc] init];
	lifeGained.text = @"+1!";
	lifeGained.backgroundColor = [UIColor clearColor];
	lifeGained.textAlignment = NSTextAlignmentCenter;
	lifeGained.textColor = [UIColor greenColor];
	lifeGained.font = [UIFont systemFontOfSize:40];
	lifeGained.frame = CGRectMake(10, 80, 100, 50);
	[grdVC.view addSubview:lifeGained];
	[UIView beginAnimations:@"ScrollLifeGainedAnimation" context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 1.5];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	lifeGained.frame = CGRectMake(10, 30, 100, 50);
	[UIView commitAnimations];
	
	[UIView animateWithDuration:1.5 animations:^{ lifeGained.alpha = 0.0f; }];
}

+ (void)loseALife:(GRDViewController *)grdVC {
	GRDAppDelegate *delegate = (GRDAppDelegate *)[[UIApplication sharedApplication] delegate];

	delegate.numLives--;
	grdVC.livesDisplay.text = [NSString stringWithFormat:@"%d", delegate.numLives];
	
	UILabel *lifeLost = [[UILabel alloc] init];
	lifeLost.text = @"-1";
	lifeLost.backgroundColor = [UIColor clearColor];
	lifeLost.textAlignment = NSTextAlignmentCenter;
	lifeLost.textColor = [UIColor redColor];
	lifeLost.font = [UIFont systemFontOfSize:40];
	lifeLost.frame = CGRectMake(10, 80, 100, 50);
	[grdVC.view addSubview:lifeLost];
	[UIView beginAnimations:@"ScrollLifeLostAnimation" context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 1.5];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	lifeLost.frame = CGRectMake(10, 30, 100, 50);
	[UIView commitAnimations];
	
	[UIView animateWithDuration:1.5 animations:^{ lifeLost.alpha = 0.0f; }];
	
	if(delegate.numLives == 0) {
		[delegate.soundPlayer.gameThemePlayer stop];
		delegate.soundPlayer.gameThemePlayer.currentTime = 0;
		[delegate.pulseTimer invalidate];
		if (delegate.soundIsActive) [delegate.soundPlayer.gameOverSoundPlayer play];
		delegate.gameInProgress = NO;
		[grdVC performSegueWithIdentifier:@"gameOver" sender:nil];
		return;
	}
}

+ (void)gainStreak:(GRDViewController *)grdVC {
	UILabel *streakGained = [[UILabel alloc] init];
	streakGained.text = @"+1!";
	streakGained.backgroundColor = [UIColor clearColor];
	streakGained.textAlignment = NSTextAlignmentCenter;
	streakGained.textColor = [UIColor blueColor];
	streakGained.font = [UIFont systemFontOfSize:40];
	streakGained.frame = CGRectMake(110, 80, 100, 50);
	[grdVC.view addSubview:streakGained];
	[UIView beginAnimations:@"StreakPointsGainedAnimation" context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 1.5];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	streakGained.frame = CGRectMake(110, 30, 100, 50);
	[UIView commitAnimations];
	
	[UIView animateWithDuration:1.5 animations:^{ streakGained.alpha = 0.0f; }];
}

+ (void)gainPoints:(GRDViewController *)grdVC {
	GRDAppDelegate *delegate = (GRDAppDelegate *)[[UIApplication sharedApplication] delegate];

	UILabel *pointsGained = [[UILabel alloc] init];
	
	if (delegate.difficultyLevel == 0) pointsGained.text = [NSString stringWithFormat:@"+%d!", (500 / (delegate.millisecondsFromGridPulse + 1)) + 5 + (delegate.numRounds * 2)];
	else if (delegate.difficultyLevel == 1) pointsGained.text = [NSString stringWithFormat:@"+%d!", (2000 / (delegate.millisecondsFromGridPulse + 1)) + 10 + (delegate.numRounds * 2)];
	else if (delegate.difficultyLevel == 2) pointsGained.text = [NSString stringWithFormat:@"+%d!", (4000 / (delegate.millisecondsFromGridPulse + 1)) + 20];
	
	pointsGained.backgroundColor = [UIColor clearColor];
	pointsGained.textAlignment = NSTextAlignmentCenter;
	pointsGained.textColor = [UIColor greenColor];
	pointsGained.font = [UIFont systemFontOfSize:30];
	pointsGained.frame = CGRectMake(200, 80, 100, 50);
	
	[grdVC.view addSubview:pointsGained];
	[UIView beginAnimations:@"ScrollPointsGainedAnimation" context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 1.5];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	pointsGained.frame = CGRectMake(200, 30, 100, 50);
	[UIView commitAnimations];
	
	[UIView animateWithDuration:1.5 animations:^{ pointsGained.alpha = 0.0f; }];
}

+ (void)gainTime:(GRDSquare *)square withGrdVC:(GRDViewController *)grdVC {
	GRDAppDelegate *delegate = (GRDAppDelegate *)[[UIApplication sharedApplication] delegate];

	if (delegate.soundIsActive) [delegate.soundPlayer.clockSoundPlayer play];
	
	UILabel *timeGained = [[UILabel alloc] init];
	timeGained.text = @"+1 Second!";
	timeGained.backgroundColor = [UIColor clearColor];
	timeGained.textAlignment = NSTextAlignmentCenter;
	timeGained.textColor = [UIColor greenColor];
	timeGained.font = [UIFont systemFontOfSize:20];
	timeGained.frame = CGRectMake(square.frame.origin.x, square.frame.origin.y, 150, 50);
	[grdVC.view addSubview:timeGained];
	[UIView beginAnimations:@"TimePointsGainedAnimation" context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 1.5];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	timeGained.frame = CGRectMake(square.frame.origin.x, square.frame.origin.y - 30, 150, 50);
	[UIView commitAnimations];
	
	[UIView animateWithDuration:1.5 animations:^{ timeGained.alpha = 0.0f; }];
}

+ (void)styleButtonAsASquare:(UIButton *)button {
	button.layer.cornerRadius = 5;
	button.backgroundColor = [UIColor blueColor];
	button.layer.borderColor = [UIColor blackColor].CGColor;
	button.layer.borderWidth = 3.0;
}
 */

/*
 
 0   1   2   3
 
 4   5   6   7
 
 8   9   10  11
 
 12  13  14  15
 
 */

+ (void)populateStraightAdjacentSquares:(NSMutableArray *)squares {
	int i = 0;
	for (GRDSquare *square in squares) {
		switch (i) {
			case 0: // 1,4
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:1]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:4]];
				break;
			case 1: // 0,5,2
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:0]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:5]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:2]];
				break;
			case 2: // 1,6,3
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:1]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:3]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:6]];
				break;
			case 3: // 2,7
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:2]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:7]];
				break;
			case 4: // 0,5,8
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:0]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:5]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:8]];
				break;
			case 5: // 1,6,9,4
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:1]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:6]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:9]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:4]];
				break;
			case 6: // 2,10,5,7
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:2]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:7]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:5]];
				break;
			case 7: // 3,6,11
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:3]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:6]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:11]];
				break;
			case 8: // 4,9,12
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:4]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:9]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:12]];
				break;
			case 9: // 5,8,13,10
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:5]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:13]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:8]];
				break;
			case 10: // 6,9,14,11
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:6]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:11]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:14]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:9]];
				break;
			case 11: // 7,10,15
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:7]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:15]];
				break;
			case 12: // 8,13
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:8]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:13]];
				break;
			case 13: // 12,9,14
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:12]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:9]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:14]];
				break;
			case 14: // 13,10,15
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:13]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:15]];
				break;
			case 15: // 14,11
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:14]];
				[square.adjacentStraightSquares addObject:[squares objectAtIndex:11]];
				break;
			default:
				break;
		}
		
		i++;
	}
	
}

+ (void)populateAdjacentAllSquares:(NSMutableArray *)squares {
	int i = 0;
	for (GRDSquare *square in squares) {
		switch (i) {
			case 0: // 1,4,5
				[square.adjacentAllSquares addObject:[squares objectAtIndex:1]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:4]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:5]];
				break;
			case 1: // 0,4,5,6,2
				[square.adjacentAllSquares addObject:[squares objectAtIndex:0]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:2]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:4]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:5]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:6]];
				break;
			case 2: // 1,5,6,7,3
				[square.adjacentAllSquares addObject:[squares objectAtIndex:1]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:3]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:5]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:6]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:7]];
				break;
			case 3: // 2,6,7
				[square.adjacentAllSquares addObject:[squares objectAtIndex:2]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:6]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:7]];
				break;
			case 4: // 0,1,5,9,8
				[square.adjacentAllSquares addObject:[squares objectAtIndex:0]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:1]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:5]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:9]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:8]];
				break;
			case 5: // 0,1,2,6,10,9,8,4
				[square.adjacentAllSquares addObject:[squares objectAtIndex:0]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:1]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:2]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:6]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:9]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:8]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:4]];
				break;
			case 6: // 1,2,3,7,11,10,9,5
				[square.adjacentAllSquares addObject:[squares objectAtIndex:1]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:2]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:3]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:7]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:11]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:9]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:5]];
				break;
			case 7: // 3,2,6,10,11
				[square.adjacentAllSquares addObject:[squares objectAtIndex:3]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:2]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:6]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:11]];
				break;
			case 8: // 4,5,9,13,12
				[square.adjacentAllSquares addObject:[squares objectAtIndex:4]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:5]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:9]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:13]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:12]];
				break;
			case 9: // 4,5,6,10,14,13,12,8
				[square.adjacentAllSquares addObject:[squares objectAtIndex:4]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:5]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:6]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:14]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:13]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:12]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:8]];
				break;
			case 10: // 5,6,7,11,15,14,13,9
				[square.adjacentAllSquares addObject:[squares objectAtIndex:5]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:6]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:7]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:11]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:15]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:14]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:13]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:9]];
				break;
			case 11: // 7,6,10,14,15
				[square.adjacentAllSquares addObject:[squares objectAtIndex:7]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:6]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:14]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:15]];
				break;
			case 12: // 8,9,13
				[square.adjacentAllSquares addObject:[squares objectAtIndex:8]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:9]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:13]];
				break;
			case 13: // 12,8,9,10,14
				[square.adjacentAllSquares addObject:[squares objectAtIndex:12]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:8]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:9]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:14]];
				break;
			case 14: // 13,9,10,11,15
				[square.adjacentAllSquares addObject:[squares objectAtIndex:13]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:9]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:11]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:15]];
				break;
			case 15: // 14,10,11
				[square.adjacentAllSquares addObject:[squares objectAtIndex:14]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:10]];
				[square.adjacentAllSquares addObject:[squares objectAtIndex:11]];
				break;
			default:
				break;
		}
		
		i++;
	}

}

@end
