//
//  GRDWizard.m
//  gridder
//
//  Created by Joshua James on 1/10/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDWizard.h"
#import "GRDAppDelegate.h"

@implementation GRDWizard

+ (BOOL)gridComparisonMatches:(NSMutableArray *)greaterGrid compareWith:(NSMutableArray *)lesserGrid {
	
	for (int x = 1; x < 16; x++) {
		for (GRDSquare *square in lesserGrid) {
			if (square.tag == x) {
				NSLog(@"LESSER GRID POS <%d> isActive:%@ ", x, square.isActive ? @"YES" : @"NO");
			}
		}
		for (GRDSquare *square in greaterGrid) {
			if (square.tag == x) {
				NSLog(@"GREATER GRID POS <%d> isActive:%@ ", x, square.isActive ? @"YES" : @"NO");
			}
		}
		if ([GRDWizard squareForPosition:x fromGrid:greaterGrid].isActive != [GRDWizard squareForPosition:x fromGrid:lesserGrid].isActive) {
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

@end
