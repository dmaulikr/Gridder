//
//  GRDPrimeViewController.m
//  gridder
//
//  Created by sithrex on 22/03/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import "GRDPrimeViewController.h"
#import "GRDWizard.h"
#import "GRDAppDelegate.h"

enum {
	DifficultyLevelEasy = 0,
	DifficultyLevelMedium = 1,
	DifficultyLevelHard = 2
};

typedef NSInteger DifficultyLevel;

@interface GRDPrimeViewController ()

@property (nonatomic) int score;
@property (nonatomic) int rounds;
@property (nonatomic) int lives;
@property (nonatomic) int streak;
@property (nonatomic) DifficultyLevel difficultyLevel;
@property (nonatomic) CGRect scoreFaderFrame;
@property (nonatomic) CGRect lifeFaderFrame;
@property (nonatomic, strong) NSMutableArray *activationCandidates;

// Views
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIView *transitionFader;
@property (nonatomic, strong) UILabel *scoreGainedFader;
@property (nonatomic, strong) UILabel *lifeFader;

// Achievements
@property (nonatomic) int onTheEdgeStreak;

@end

@implementation GRDPrimeViewController

#pragma mark -
#pragma mark VIEW CONTROLLER DELEGATE
#pragma mark -

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.lesserGrid.backgroundColor = [UIColor clearColor];
	self.greaterGrid.backgroundColor = [UIColor clearColor];
	self.gridColour = [UIColor orangeColor];
	
	[self startNewGame];
	
	[self.view bringSubviewToFront:self.greaterGrid];
	[self.view bringSubviewToFront:self.lesserGrid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self drawGUI];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self didTouchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self didEndTouching:touches withEvent:event];
}

#pragma mark -
#pragma mark GUI
#pragma mark -

- (void)drawGUI {
	[self generateGrids];
	self.transitionFader = [[UIView alloc] initWithFrame:self.view.frame];
	self.transitionFader.backgroundColor = self.view.backgroundColor;
	self.transitionFader.hidden = YES;
	[self.view addSubview:self.transitionFader];
	[self.view bringSubviewToFront:self.transitionFader];
	
	self.scoreFaderFrame = CGRectMake(self.footerView.frame.size.width - 60, self.footerView.frame.origin.y - 20, 100, 50);
	self.lifeFaderFrame = CGRectMake(self.footerView.frame.origin.x - 15, self.footerView.frame.origin.y - 20, 100, 50);

	self.scoreGainedFader = [[UILabel alloc] initWithFrame:self.scoreFaderFrame];
	self.scoreGainedFader.backgroundColor = [UIColor clearColor];
	self.scoreGainedFader.textAlignment = NSTextAlignmentCenter;
	self.scoreGainedFader.textColor = self.gridColour;
	self.scoreGainedFader.font = [UIFont systemFontOfSize:30];
	self.scoreGainedFader.alpha = 0.0f;
	[self.view addSubview:self.scoreGainedFader];
	
	
	self.lifeFader = [[UILabel alloc] initWithFrame:self.lifeFaderFrame];
	self.lifeFader.backgroundColor = [UIColor clearColor];
	self.lifeFader.textAlignment = NSTextAlignmentCenter;
	self.lifeFader.textColor = self.gridColour;
	self.lifeFader.font = [UIFont systemFontOfSize:30];
	self.lifeFader.alpha = 0.0f;
	[self.view addSubview:self.lifeFader];
	
	[self populateFooterView];
	[self randomiseLesserGrid];
}

- (void)populateFooterView {
	self.pauseButton = [[UIButton alloc] initWithFrame:CGRectMake((self.footerView.frame.size.width / 2) - 47, 0, 100, self.footerView.frame.size.height)];
	[self.pauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
	[self.pauseButton setBackgroundColor:self.gridColour];
	[self.footerView addSubview:self.pauseButton];
}

- (void)generateGrids {
	self.greaterGridSquares = [[NSMutableArray alloc] init];
	self.lesserGridSquares = [[NSMutableArray alloc] init];
	
	[self generateGreaterGridWithXOffset:0 withYOffset:0 fromCount:1];
	[self generateLesserGridWithXOffset:0 withYOffset:0 fromCount:1];
	
	[GRDWizard populateAdjacentAllSquares:self.lesserGridSquares];
	[GRDWizard populateStraightAdjacentSquares:self.lesserGridSquares];
}

- (void)generateGreaterGridWithXOffset:(NSInteger)xOffset withYOffset:(NSInteger)yOffset fromCount:(NSInteger)count {
	GRDSquare *square = [[[NSBundle mainBundle] loadNibNamed:@"GRDSquare"
													   owner:self
													 options:nil] lastObject];
	
	square.frame = CGRectMake(0 + xOffset, yOffset, (self.greaterGrid.bounds.size.width / GREATERGRID_SQUARE_SIZE) - 15, (self.greaterGrid.bounds.size.width / GREATERGRID_SQUARE_SIZE) - 15);

	square.layer.masksToBounds = NO;
	square.tag = count;
	square.backgroundColor = self.gridColour;
	square.alpha = 0.3f;
	square.delegate = self;
	square.isActive = NO;

	square.userInteractionEnabled = YES;

	[self.greaterGrid addSubview:square];
	[self.greaterGridSquares addObject:square];
	if (count % 4 == 0) {
		if (count >= 16) return;
		yOffset += square.bounds.size.height;
		[self generateGreaterGridWithXOffset:0 withYOffset:yOffset + 15 fromCount:count + 1];
		return;
	}
	
	[self generateGreaterGridWithXOffset:(xOffset + self.greaterGrid.bounds.size.width / 4) + 5 withYOffset:yOffset fromCount:count + 1];
}

- (void)generateLesserGridWithXOffset:(NSInteger)xOffset withYOffset:(NSInteger)yOffset fromCount:(NSInteger)count {
	GRDSquare *square = [[[NSBundle mainBundle] loadNibNamed:@"GRDSquare"
													   owner:self
													 options:nil] lastObject];
	
	square.frame = CGRectMake(0 + xOffset, yOffset, (self.lesserGrid.frame.size.width / 4) - 10, (self.lesserGrid.frame.size.width / 4) - 10);
	square.tag = count;
	square.backgroundColor = self.gridColour;
	square.alpha = 0.3f;
	square.isActive = NO;
	square.adjacentAllSquares = [[NSMutableArray alloc] init];
	square.adjacentStraightSquares = [[NSMutableArray alloc] init];
	
	[self.lesserGrid addSubview:square];
	[self.lesserGridSquares addObject:square];
	
	if (count % 4 == 0) {
		if (count >= 16) return;
		yOffset += square.bounds.size.height;
		[self generateLesserGridWithXOffset:0 withYOffset:yOffset + 10 fromCount:count + 1];
		return;
	}
	
	[self generateLesserGridWithXOffset:xOffset + (self.lesserGrid.frame.size.width / 4) + 5 withYOffset:yOffset fromCount:count + 1];
}

- (BOOL)prefersStatusBarHidden{
	return YES;
}

#pragma mark - 
#pragma mark TIMER
#pragma mark -

- (void)setupTimer {
	self.progressBar = [[YLProgressBar alloc] init];
	self.progressBar.type = YLProgressBarTypeFlat;
	self.progressBar.hideStripes = YES;
	self.progressBar.hideTrack = YES;
	self.progressBar.hideGloss = YES;
	self.progressBar.progressTintColor = self.gridColour;
	self.progressBar.progressTintColors = [[NSArray alloc] initWithObjects:self.gridColour, nil];
	self.progressBar.trackTintColor = self.view.backgroundColor;
	self.progressBar.center = self.view.center;
	self.progressBar.frame = CGRectMake(10, 20, self.view.frame.size.width - 20, 30);
	self.maximumTimeAllowed = 800;
	self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];

	[self.view addSubview:self.progressBar];
}

- (void)timerFireMethod:(NSTimer *)theTimer {
	self.timeUntilNextPulse += 10;
	if (self.timeUntilNextPulse >= self.maximumTimeAllowed) {
		self.timeUntilNextPulse = 0;
		[self pulseWithSuccessfulMatch:NO];
	}
	
	[self.progressBar setProgress:((float)self.timeUntilNextPulse / self.maximumTimeAllowed) animated:YES];
}

#pragma mark -
#pragma mark TOUCH METHODS
#pragma mark -

- (void)squareTouch:(NSSet *)touches withEvent:(UIEvent *)event {
	
	GRDSquare *touchedSquare;
	UITouch *touch = [touches anyObject];
	CGPoint firstTouch = [touch locationInView:self.greaterGrid];
	for (GRDSquare *square in self.greaterGridSquares) {
		if (CGRectContainsPoint(square.frame, firstTouch)) {
			touchedSquare = square;
		}
	}
	
	if (!touchedSquare.isBeingTouchDragged) {
		if (touchedSquare) {
			if (!touchedSquare.isActive) {
				touchedSquare.isActive = YES;
			} else {
				touchedSquare.isActive = NO;
			}
			
			if ([GRDWizard gridComparisonMatches:self.greaterGridSquares compareWith:self.lesserGridSquares]) {
				[self pulseWithSuccessfulMatch:YES];
			}
		}
	}
	
	touchedSquare.isBeingTouchDragged = YES;
}

- (void)didBeginTouching:(NSSet *)touches withEvent:(UIEvent *)event {
	[self squareTouch:touches withEvent:event];
}

- (void)didTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self squareTouch:touches withEvent:event];
}

- (void)didEndTouching:(NSSet *)touches withEvent:(UIEvent *)event {
	for (GRDSquare *square in self.greaterGridSquares) {
		square.isBeingTouchDragged = NO;
	}
}

- (void)squareDidBeginTouching:(NSSet *)touches withEvent:(UIEvent *)event {
	[self didBeginTouching:touches withEvent:event];
}

- (void)squareDidEndTouching:(NSSet *)touches withEvent:(UIEvent *)event {
	[self didEndTouching:touches withEvent:event];
}

- (void)squareDidTouchesMove:(NSSet *)touches withEvent:(UIEvent *)event {
	[self didTouchesMoved:touches withEvent:event];
}

#pragma mark -
#pragma mark ANIMATIONS
#pragma mark -

- (void)pulseTransitionWithSuccess:(BOOL)successful {
	self.transitionFader.backgroundColor = successful ? self.view.backgroundColor : [UIColor redColor];
	self.transitionFader.hidden = NO;
	[UIView animateWithDuration:0.2
						  delay:0.0
						options:0
					 animations:^{
						 self.transitionFader.alpha = 1.0f;
					 } completion:^(BOOL finished) {
						 self.transitionFader.hidden = YES;
						 self.transitionFader.alpha = 0;
					 }
	 ];
}

- (void)gainPoints {
	int pointsGained;
	if (self.difficultyLevel == DifficultyLevelEasy) pointsGained = (500 / (self.timeUntilNextPulse + 1)) + 5 + (self.rounds * 2);
	else if (self.difficultyLevel == DifficultyLevelMedium)pointsGained = (2000 / (self.timeUntilNextPulse + 1)) + 10 + (self.rounds * 2);
	else pointsGained = (4000 / (self.timeUntilNextPulse + 1)) + 20;

	self.scoreGainedFader.text = [NSString stringWithFormat:@"+%d!", pointsGained];
	self.scoreGainedFader.alpha = 1.0f;
	[self.scoreLabel setText:[NSString stringWithFormat:@"%d", self.score + [self.scoreGainedFader.text intValue]]];
	
	[UIView beginAnimations:@"ScrollPointsGainedAnimation" context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 1.5];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	self.scoreGainedFader.frame = CGRectMake(self.scoreGainedFader.frame.origin.x, self.scoreGainedFader.frame.origin.y - 100, self.scoreGainedFader.frame.size.width, self.scoreGainedFader.frame.size.height);
	[UIView commitAnimations];
	
	[UIView animateWithDuration:1.5 animations:^{ self.scoreGainedFader.alpha = 0.0f;} completion:^(BOOL finished) {
		self.scoreGainedFader.frame = self.scoreFaderFrame;
	}];
}

- (void)loseALife {
	self.lives--;
	
	if (self.lives == 0) {
		[self.pulseTimer invalidate];
		self.pulseTimer = nil;
		[self startNewGame];
		
		return;
	}
	
	[self.livesLabel setText:[NSString stringWithFormat:@"%d", self.lives]];
	
	[self.lifeFader setText:@"-1"];
	[self fadeLife];
}

- (void)gainALife {
	self.lives++;
	
	[self.livesLabel setText:[NSString stringWithFormat:@"%d", self.lives]];
	[self.lifeFader setText:@"+1"];
	
	[self fadeLife];
}

- (void)fadeLife {
	self.lifeFader.alpha = 1.0f;
	
	[UIView beginAnimations:@"ScrollLifeAnimation" context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 1.5];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	self.lifeFader.frame = CGRectMake(self.lifeFader.frame.origin.x, self.lifeFader.frame.origin.y - 100, self.lifeFader.frame.size.width, self.lifeFader.frame.size.height);
	[UIView commitAnimations];
	
	[UIView animateWithDuration:1.5 animations:^{ self.lifeFader.alpha = 0.0f; } completion:^(BOOL finished) {
		self.lifeFader.frame = self.lifeFaderFrame;
	}];

}

- (void)setDifficultyLevel:(DifficultyLevel)difficultyLevel {
	switch (difficultyLevel) {
		case DifficultyLevelHard:
			self.gridColour = [UIColor purpleColor];
			break;
		case DifficultyLevelMedium:
			self.gridColour = [UIColor blueColor];
			break;
		case DifficultyLevelEasy:
		default:
			self.gridColour = [UIColor orangeColor];
			break;
	}
	
	for (GRDSquare *square in self.greaterGridSquares) {
		square.backgroundColor = self.gridColour;
	}
	for (GRDSquare *square in self.lesserGridSquares) {
		square.backgroundColor = self.gridColour;
	}
	
	self.pauseButton.backgroundColor = self.gridColour;
	self.scoreGainedFader.textColor = self.gridColour;
	self.lifeFader.textColor = self.gridColour;
	self.progressBar.progressTintColor = self.gridColour;
	self.progressBar.progressTintColors = [[NSArray alloc] initWithObjects:self.gridColour, nil];
}

#pragma mark - 
#pragma mark GAME FUNCTIONS
#pragma mark -

- (void)startNewGame {
	self.rounds = 0;
	self.lives = 3;
	self.score = 0;
	self.streak = 0;
	self.onTheEdgeStreak = 0;
	self.activationCandidates = [[NSMutableArray alloc] init];
	
	self.difficultyLevel = DifficultyLevelEasy;
	
	[self.livesLabel setText:[NSString stringWithFormat:@"%d", self.lives]];
	[self.scoreLabel setText:[NSString stringWithFormat:@"%d", self.score]];
}

- (void)pulse {
	[self randomiseLesserGrid];
	
	if (self.lives == 1) {
		self.onTheEdgeStreak++;
		if (self.onTheEdgeStreak == 10) {
			//[delegate.menuVC.gameCenterManager submitAchievement:kAchievementOnTheEdge percentComplete:100];
		}
	} else {
		self.onTheEdgeStreak = 0;
	}
	
	//delegate.soundPlayer.pulseSuccessSoundPlayer.currentTime = 0;
	//if (delegate.soundIsActive) [delegate.soundPlayer.pulseSuccessSoundPlayer play];
	
	
	
	if (self.rounds > 50) {
		self.difficultyLevel = DifficultyLevelHard;
		self.gridColour = [UIColor redColor];
	} else if (self.rounds > 10) {
		self.difficultyLevel = DifficultyLevelMedium;
		self.gridColour = [UIColor purpleColor];
	}
	
	//if (glassLevel < 3) {
	//	glassLevel = (delegate.numRounds + 1) / 6;
	//}
	
	//if(delegate.currentStreak > delegate.highestStreak) delegate.highestStreak++;
	
	
	if (self.difficultyLevel == DifficultyLevelEasy) {
		if (self.maximumTimeAllowed > 300) self.maximumTimeAllowed -= 30;
	} else if (self.difficultyLevel == DifficultyLevelMedium) {
		if (self.maximumTimeAllowed > 280) self.maximumTimeAllowed -= 30;
	} else if (self.difficultyLevel == DifficultyLevelHard) {
		if (self.maximumTimeAllowed > 250) self.maximumTimeAllowed -= 30;
	}
	
	
	//[self pulseTransitionWithSuccess:YES];

}
- (void)pulseWithSuccessfulMatch:(BOOL)successful {
	if (!self.pulseTimer) {
		[self setupTimer];
	}
	
	self.rounds++;
	self.timeUntilNextPulse = 0;

	
	if (successful) {
		[self gainPoints];
		self.streak++;
		if (self.streak % 10 == 0) [self gainALife];

		for (GRDSquare *greaterSquare in self.greaterGridSquares) {
			if (greaterSquare.isActive) {
				[UIView animateWithDuration:0.2
									  delay:0.0
									options:UIViewAnimationOptionCurveEaseIn
								 animations:^{
									 greaterSquare.backgroundColor = [UIColor purpleColor];
								 }
								 completion:^(BOOL finished){
									 [UIView animateWithDuration:0.2
														   delay:0.0
														 options: UIViewAnimationOptionCurveEaseIn
													  animations:^{
														  greaterSquare.backgroundColor = self.gridColour;
													  }
													  completion:^(BOOL finished) {
														  
													  }];
								 }];
			} else {
				[UIView animateWithDuration:0.2
									  delay:0.0
									options:UIViewAnimationOptionCurveEaseIn
								 animations:^{
									 greaterSquare.alpha = 0.1f;
								 }
								 completion:^(BOOL finished){
									 [UIView animateWithDuration:0.2
														   delay:0.0
														 options: UIViewAnimationOptionCurveEaseIn
													  animations:^{
														  greaterSquare.alpha = 0.3f;
													  }
													  completion:^(BOOL finished) {
														  
													  }];
								 }];
			}
		}
		
		for (GRDSquare *lesserSquare in self.lesserGridSquares) {
			if (lesserSquare.isActive) {
				[UIView animateWithDuration:0.2
									  delay:0.0
									options: UIViewAnimationOptionCurveEaseIn
								 animations:^{
									 lesserSquare.backgroundColor = [UIColor purpleColor];
								 }
								 completion:^(BOOL finished) {
									 [UIView animateWithDuration:0.2
														   delay:0.0
														 options: UIViewAnimationOptionCurveEaseIn
													  animations:^{
														  lesserSquare.backgroundColor = self.gridColour;
													  }
													  completion:^(BOOL finished) {
													  }];
								 }];
			} else {
				[UIView animateWithDuration:0.2
									  delay:0.0
									options:UIViewAnimationOptionCurveEaseIn
								 animations:^{
									 lesserSquare.alpha = 0.1f;
								 }
								 completion:^(BOOL finished){
									 [UIView animateWithDuration:0.2
														   delay:0.0
														 options: UIViewAnimationOptionCurveEaseIn
													  animations:^{
														  lesserSquare.alpha = 0.3f;
													  }
													  completion:^(BOOL finished) {
														  
													  }];
								 }];
			}

		}
		
		[self performSelector:@selector(pulse) withObject:nil afterDelay:0.4f];
	} else {
		
		[self randomiseLesserGrid];
		
		self.streak = 0;
		if (self.maximumTimeAllowed < 600) self.maximumTimeAllowed += 40;
		[self loseALife];
		
		
		[self pulseTransitionWithSuccess:successful];
	}
	

}

- (void)randomiseLesserGrid {
	for (GRDSquare *square in self.lesserGridSquares) {
		square.isActive = NO;
	}
	
	int activeMax = 5;
	if (self.difficultyLevel == DifficultyLevelEasy) {
		activeMax = 5;
	} else if (self.difficultyLevel == DifficultyLevelMedium) {
		activeMax = 7;
	} else if (self.difficultyLevel == DifficultyLevelHard) {
		activeMax = 10;
	}

	for (int i = 0; i <= activeMax; i++) {
		// Clear active flag
		for (GRDSquare *square in self.lesserGridSquares) {
			square.isActive = NO;
		}
		int activeCount = 0;
		
		// Select random start point
		GRDSquare *randomlyChosenSquare = [self.lesserGridSquares objectAtIndex:arc4random_uniform(15)];
		if (randomlyChosenSquare) { randomlyChosenSquare.isActive = YES; }
		activeCount++;
		
		// New algorithm
		while (activeCount < activeMax) {
			// Determine candidate squares
			self.activationCandidates = [[NSMutableArray alloc] init];
			for (unsigned int x = 0; x < [self.lesserGridSquares count]; x++) {
				// If the square isn't already active...
				GRDSquare *square = [self.lesserGridSquares objectAtIndex:x];
				if (!square.isActive) {
					// But one of its adjacent squares is...
					for (unsigned int y = 0; y < [square.adjacentStraightSquares count]; y++) {
						GRDSquare *adjacentSquare = [square.adjacentStraightSquares objectAtIndex:y];
						if (adjacentSquare.isActive) {
							// It's a candidate
							[self.activationCandidates addObject:[NSNumber numberWithInt:x]];
					
							break;
						}
					}
				}
			}
			
			// Activate a random candidate
			unsigned int idx = arc4random_uniform([self.activationCandidates count]);
			
			GRDSquare *square = [self.lesserGridSquares objectAtIndex:[((NSNumber *)[self.activationCandidates objectAtIndex:idx]) intValue]];
			square.isActive = true;
			++activeCount;
		}
		
	}
	
	for (GRDSquare *square in self.greaterGridSquares) {
		square.isActive = NO;
	}
	self.activationCandidates = nil;
	
}



@end
