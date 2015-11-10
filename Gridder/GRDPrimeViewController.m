//
//  GRDPrimeViewController.m
//  gridder
//
//  Created by sithrex on 22/03/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import "GRDPrimeViewController.h"
#import "GRDAppDelegate.h"
#import "GRDAnimator.h"

#define ALPHA_LEVEL 0.3
#define SCROLLING_TEXT_SIZE 15

@interface GRDPrimeViewController ()

@property (nonatomic) BOOL isTutorialMode;
@property (strong, nonatomic) UIView *tutorialTransitionView;

@end

@implementation GRDPrimeViewController

#pragma mark -
#pragma mark VIEW CONTROLLER DELEGATE
#pragma mark -

- (void)viewDidLoad {
	[super viewDidLoad];
    
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"GRDPrimeView"
                                                      owner:self
                                                    options:nil];
    
    self.primeView = [nibViews objectAtIndex:0];
        
    self.view = self.primeView;

   // self.primeView.primeFooterView footerView.backgroundColor = self.view.backgroundColor;
	self.primeView.primeLesserGrid.backgroundColor = [UIColor clearColor];
	self.primeView.primeGreaterGrid.backgroundColor = [UIColor clearColor];
    self.primeView.primeTempView.alpha = 0;
    
	[GRDCore sharedInstance].delegate = self;
    
    [GRDCore sharedInstance].gridColour = self.primeView.primeTempView.backgroundColor;
    
	[[GRDCore sharedInstance] startNewGame];
	
	[self.primeView bringSubviewToFront:self.primeView.primeGreaterGrid];
	[self.primeView bringSubviewToFront:self.primeView.primeLesserGrid];

    self.isTutorialMode = YES;

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
	
//	[self.particleEmitter setEmitterPositionFromTouch: [touches anyObject]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self didEndTouching:touches withEvent:event];
	
	//[self.particleEmitter setIsEmitting:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	[self.particleEmitter setIsEmitting:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//	[self.particleEmitter setIsEmitting:NO];
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
	
	self.scoreFaderFrame = CGRectMake(self.primeView.primeScoreBox.frame.origin.x - 25, self.primeView.primeScoreBox.frame.origin.y - 20, 100, 50);
	self.lifeFaderFrame = CGRectMake(self.primeView.primeLifeBox.frame.origin.x - 25, self.primeView.primeLifeBox.frame.origin.y - 20, 100, 50);

	self.scoreGainedFader = [[UILabel alloc] initWithFrame:self.scoreFaderFrame];
	self.scoreGainedFader.backgroundColor = [UIColor clearColor];
	self.scoreGainedFader.textAlignment = NSTextAlignmentCenter;
	self.scoreGainedFader.textColor = [GRDCore sharedInstance].gridColour;
	self.scoreGainedFader.font = [UIFont systemFontOfSize:SCROLLING_TEXT_SIZE];
	self.scoreGainedFader.alpha = 0.0f;
    
    [self.primeView.primeScoreLabel setTextColor:[GRDCore sharedInstance].gridColour];
    
	[self.view addSubview:self.scoreGainedFader];
	
	
	self.lifeFader = [[UILabel alloc] initWithFrame:self.lifeFaderFrame];
	self.lifeFader.backgroundColor = [UIColor clearColor];
	self.lifeFader.textAlignment = NSTextAlignmentCenter;
	self.lifeFader.textColor = [GRDCore sharedInstance].gridColour;
	self.lifeFader.font = [UIFont systemFontOfSize:SCROLLING_TEXT_SIZE];
	self.lifeFader.alpha = 0.0f;
	[self.view addSubview:self.lifeFader];
	
	//[self populateFooterView];
	[self randomiseLesserGrid];
    
    self.primeView.primeScoreBox.backgroundColor = [GRDCore sharedInstance].gridColour;
    self.primeView.primeLifeBox.backgroundColor = [GRDCore sharedInstance].gridColour;
    
    
    self.primeView.primePauseBox.backgroundColor = [[GRDCore sharedInstance].gridColour colorWithAlphaComponent:ALPHA_LEVEL];
    self.primeView.primeLifeBox.backgroundColor = [[GRDCore sharedInstance].gridColour colorWithAlphaComponent:ALPHA_LEVEL];
    self.primeView.primeScoreBox.backgroundColor = [[GRDCore sharedInstance].gridColour colorWithAlphaComponent:ALPHA_LEVEL];
	
	//[self.livesLabel setText:[NSString stringWithFormat:@"%d", [GRDCore sharedInstance].lives]];
	[GRDAnimator animatePulse:self.transitionFader];
}

//- (void)populateFooterView {
//	self.pauseButton = [[UIButton alloc] initWithFrame:CGRectMake((self.footerView.frame.size.width / 2) - 47, 0, 100, self.footerView.frame.size.height)];
//	//self.pauseButton.layer.cornerRadius = 3.0f;
//	[self.pauseButton setTitle:@"PAUSE" forState:UIControlStateNormal];
//	[self.pauseButton setBackgroundColor:[GRDCore sharedInstance].gridColour];
//	[self.footerView addSubview:self.pauseButton];
//}

- (void)generateGrids {
	[self generateGreaterGridWithXOffset:0 withYOffset:0 fromCount:1];
	[self generateLesserGridWithXOffset:0 withYOffset:0 fromCount:1];
	
	[GRDCore populateAdjacentAllSquares:[GRDCore sharedInstance].lesserGridSquares];
	[GRDCore populateStraightAdjacentSquares:[GRDCore sharedInstance].lesserGridSquares];
}

- (void)generateGreaterGridWithXOffset:(NSInteger)xOffset withYOffset:(NSInteger)yOffset fromCount:(NSInteger)count {
	GRDSquare *square = [[[NSBundle mainBundle] loadNibNamed:@"GRDSquare"
													   owner:self
													 options:nil] lastObject];
	
	square.frame = CGRectMake(0 + xOffset, yOffset, (self.primeView.primeGreaterGrid.bounds.size.width / GREATERGRID_SQUARE_OFFSET_TO_DIVIDE_BY) - GREATERGRID_GAP_SIZE, (self.primeView.primeGreaterGrid.bounds.size.width / GREATERGRID_SQUARE_OFFSET_TO_DIVIDE_BY) - GREATERGRID_GAP_SIZE);

	square.layer.masksToBounds = NO;
	square.tag = count;
	square.backgroundColor = [GRDCore sharedInstance].gridColour;
	square.alpha = ALPHA_LEVEL;
	square.delegate = self;
	square.isActive = NO;
	square.isGreaterSquare = YES;
	square.userInteractionEnabled = YES;
	square.layer.cornerRadius = 1.0f;
	
	[self.primeView.primeGreaterGrid addSubview:square];
	[[GRDCore sharedInstance].greaterGridSquares addObject:square];
    
	if (count % 4 == 0) {
		if (count >= 16) return;
		yOffset += square.bounds.size.height;
		[self generateGreaterGridWithXOffset:0 withYOffset:yOffset + GREATERGRID_GAP_SIZE fromCount:count + 1];
		return;
	}
	
	[self generateGreaterGridWithXOffset:(xOffset + self.primeView.primeGreaterGrid.bounds.size.width / 4) + (GREATERGRID_GAP_SIZE - 2) withYOffset:yOffset fromCount:count + 1];
}

- (void)generateLesserGridWithXOffset:(NSInteger)xOffset withYOffset:(NSInteger)yOffset fromCount:(NSInteger)count {
	GRDSquare *square = [[[NSBundle mainBundle] loadNibNamed:@"GRDSquare"
													   owner:self
													 options:nil] lastObject];
	
	square.frame = CGRectMake(0 + xOffset, yOffset, (self.primeView.primeLesserGrid.frame.size.width / LESSERGRID_SQUARE_OFFSET_TO_DIVIDE_BY) - LESSERGRID_GAP_SIZE, (self.primeView.primeLesserGrid.frame.size.width / LESSERGRID_SQUARE_OFFSET_TO_DIVIDE_BY) - LESSERGRID_GAP_SIZE);
	square.tag = count;
	square.backgroundColor = [GRDCore sharedInstance].gridColour;
	square.alpha = ALPHA_LEVEL;
	square.isActive = NO;
	square.adjacentAllSquares = [[NSMutableArray alloc] init];
	square.adjacentStraightSquares = [[NSMutableArray alloc] init];
	square.isGreaterSquare = NO;
	//square.layer.cornerRadius = 3.0f;

	[self.primeView.primeLesserGrid addSubview:square];
	[[GRDCore sharedInstance].lesserGridSquares addObject:square];
	
	if (count % 4 == 0) {
		if (count >= 16) return;
		yOffset += square.bounds.size.height;
		[self generateLesserGridWithXOffset:0 withYOffset:yOffset + LESSERGRID_GAP_SIZE fromCount:count + 1];
		return;
	}
	
	[self generateLesserGridWithXOffset:xOffset + (self.primeView.primeLesserGrid.frame.size.width / LESSERGRID_SQUARE_OFFSET_TO_DIVIDE_BY) + (LESSERGRID_GAP_SIZE - 2) withYOffset:yOffset fromCount:count + 1];
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
    UIColor *tintColour = [[GRDCore sharedInstance].gridColour colorWithAlphaComponent:1.0f];
	self.progressBar.progressTintColor = tintColour;
	self.progressBar.progressTintColors = [[NSArray alloc] initWithObjects:tintColour, nil];
	self.progressBar.trackTintColor = self.view.backgroundColor;
	self.progressBar.center = self.primeView.primePauseBox.center;
	self.progressBar.frame = CGRectMake(1, 4, self.primeView.primePauseBox.frame.size.width - 3, self.primeView.primePauseBox.frame.size.height - 3);
	self.maximumTimeAllowed = 800;
	self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];

    self.progressBar.transform = CGAffineTransformMakeRotation(3 * M_PI_2);

	[self.primeView.primePauseBox addSubview:self.progressBar];
    
    [self.primeView.primePauseBox bringSubviewToFront:self.primeView.primePauseBoxIcon];
}

- (void)timerFireMethod:(NSTimer *)theTimer {
	if (![[GRDSoundPlayer sharedInstance].gameThemePlayer isPlaying]) {
		[[GRDSoundPlayer sharedInstance].gameThemePlayer prepareToPlay];
		[[GRDSoundPlayer sharedInstance].gameThemePlayer play];
	}
	
	self.timeElapsed += 10;
	if (self.timeElapsed >= self.maximumTimeAllowed) {
		self.timeElapsed = 0;
		[self pulseWithSuccessfulMatch:NO];
	}
	
	[self.progressBar setProgress:((float)self.timeElapsed / self.maximumTimeAllowed) animated:YES];
}

#pragma mark -
#pragma mark TOUCH METHODS
#pragma mark -

- (void)squareTouch:(NSSet *)touches withEvent:(UIEvent *)event {
	GRDSquare *touchedSquare;
	UITouch *touch = [touches anyObject];
	CGPoint firstTouch = [touch locationInView:self.primeView.primeGreaterGrid];
	for (GRDSquare *square in [GRDCore sharedInstance].greaterGridSquares) {
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
			
			if ([GRDCore gridComparisonMatches:[GRDCore sharedInstance].greaterGridSquares compareWith:[GRDCore sharedInstance].lesserGridSquares]) {
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
	for (GRDSquare *square in [GRDCore sharedInstance].greaterGridSquares) {
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
#pragma mark WIZARD DELEGATE
#pragma mark -

- (void)wizardDidAdjustDifficultyLevel:(DifficultyLevel)difficultyLevel {
	self.pauseButton.backgroundColor = [GRDCore sharedInstance].gridColour;
	self.scoreGainedFader.textColor = [GRDCore sharedInstance].gridColour;
	self.lifeFader.textColor = [GRDCore sharedInstance].gridColour;
	self.progressBar.progressTintColor = [GRDCore sharedInstance].gridColour;
	self.progressBar.progressTintColors = [[NSArray alloc] initWithObjects:[GRDCore sharedInstance].gridColour, nil];
}

#pragma mark - 
#pragma mark GAME FUNCTIONS
#pragma mark -

- (void)pulse {
	[self randomiseLesserGrid];
	
	if ([GRDCore sharedInstance].lives == 1) {
		[GRDCore sharedInstance].onTheEdgeStreak++;
		if ([GRDCore sharedInstance].onTheEdgeStreak == 10) {
			//[delegate.menuVC.gameCenterManager submitAchievement:kAchievementOnTheEdge percentComplete:100];
		}
	} else {
		[GRDCore sharedInstance].onTheEdgeStreak = 0;
	}
    
	//delegate.soundPlayer.pulseSuccessSoundPlayer.currentTime = 0;
	//if (delegate.soundIsActive) [delegate.soundPlayer.pulseSuccessSoundPlayer play];

	
	if ([GRDCore sharedInstance].rounds > 30) {
		[GRDCore sharedInstance].difficultyLevel = DifficultyLevelHard;
	} else if ([GRDCore sharedInstance].rounds > 10) {
		[GRDCore sharedInstance].difficultyLevel = DifficultyLevelMedium;
	}
	
	//if (glassLevel < 3) {
	//	glassLevel = (delegate.numRounds + 1) / 6;
	//}
	
	//if(delegate.currentStreak > delegate.highestStreak) delegate.highestStreak++;
	
	
	if ([GRDCore sharedInstance].difficultyLevel == DifficultyLevelEasy) {
		if (self.maximumTimeAllowed > 300) self.maximumTimeAllowed -= 30;
	} else if ([GRDCore sharedInstance].difficultyLevel == DifficultyLevelMedium) {
		if (self.maximumTimeAllowed > 280) self.maximumTimeAllowed -= 30;
	} else if ([GRDCore sharedInstance].difficultyLevel == DifficultyLevelHard) {
		if (self.maximumTimeAllowed > 250) self.maximumTimeAllowed -= 30;
	}
}

- (void)pulseWithSuccessfulMatch:(BOOL)successful {
	if (!self.pulseTimer) {
		[self setupTimer];
	}
	
	if (successful) {
		[[GRDSoundPlayer sharedInstance].menuBlip2SoundPlayer play];
		[GRDCore gainPoints:self];
		[GRDCore sharedInstance].streak++;
		if ([GRDCore sharedInstance].streak % 10 == 0) [GRDCore gainALife:self];

		[GRDAnimator animateMatch];
		
		[self performSelector:@selector(pulse) withObject:nil afterDelay:0.4f];
	} else {
		[self randomiseLesserGrid];
		
        [GRDAnimator animateBox:self.primeView.primePauseBox];

		[GRDCore sharedInstance].streak = 0;
		if (self.maximumTimeAllowed < 600) self.maximumTimeAllowed += 40;
		[GRDCore loseALife:self];
		
		[GRDAnimator animatePulse:self.transitionFader];
	}
    
    [GRDCore sharedInstance].rounds++;
    self.timeElapsed = 0;
}

- (void)randomiseLesserGrid {
	for (GRDSquare *square in [GRDCore sharedInstance].lesserGridSquares) {
		square.isActive = NO;
	}
	
	int activeMax = 5;
	if ([GRDCore sharedInstance].difficultyLevel == DifficultyLevelEasy) {
		activeMax = 5;
	} else if ([GRDCore sharedInstance].difficultyLevel == DifficultyLevelMedium) {
		activeMax = 6;
	} else if ([GRDCore sharedInstance].difficultyLevel == DifficultyLevelHard) {
		activeMax = 5;
	}

	for (int i = 0; i <= activeMax; i++) {
		// Clear active flag
		for (GRDSquare *square in [GRDCore sharedInstance].lesserGridSquares) {
			square.isActive = NO;
		}
		int activeCount = 0;
		
		// Select random start point
		GRDSquare *randomlyChosenSquare = [[GRDCore sharedInstance].lesserGridSquares objectAtIndex:arc4random_uniform(15)];
		if (randomlyChosenSquare) { randomlyChosenSquare.isActive = YES; }
		activeCount++;
		
		// New algorithm
		while (activeCount < activeMax) {
			// Determine candidate squares
			[GRDCore sharedInstance].activationCandidates = [[NSMutableArray alloc] init];
			for (unsigned int x = 0; x < [[GRDCore sharedInstance].lesserGridSquares count]; x++) {
				// If the square isn't already active...
				GRDSquare *square = [[GRDCore sharedInstance].lesserGridSquares objectAtIndex:x];
				if (!square.isActive) {
					// But one of its adjacent squares is...
					for (unsigned int y = 0; y < ([GRDCore sharedInstance].difficultyLevel == DifficultyLevelHard ? [square.adjacentAllSquares count] : [square.adjacentStraightSquares count]); y++) {
						GRDSquare *adjacentSquare = [GRDCore sharedInstance].difficultyLevel == DifficultyLevelHard ? [square.adjacentAllSquares objectAtIndex:y] : [square.adjacentStraightSquares objectAtIndex:y];
						if (adjacentSquare.isActive) {
							// It's a candidate
							[[GRDCore sharedInstance].activationCandidates addObject:[NSNumber numberWithInt:x]];
					
							break;
						}
					}
				}
			}
			
			// Activate a random candidate
			u_int32_t idx = arc4random_uniform((u_int32_t)[[GRDCore sharedInstance].activationCandidates count]);
			
			GRDSquare *square = [[GRDCore sharedInstance].lesserGridSquares objectAtIndex:[((NSNumber *)[[GRDCore sharedInstance].activationCandidates objectAtIndex:idx]) intValue]];
			square.isActive = true;
			++activeCount;
		}
		
	}
	
	for (GRDSquare *square in [GRDCore sharedInstance].greaterGridSquares) {
		square.isActive = NO;
	}
	[GRDCore sharedInstance].activationCandidates = nil;
	
}

#pragma mark -
#pragma mark TUTORIAL
#pragma mark -
//
//- (void)setIsTutorialMode:(BOOL)isTutorialMode {
//    _isTutorialMode = isTutorialMode;
//    
//    if (isTutorialMode) {
//        if (!self.tutorialTransitionView) {
//            [self tutorialSetupGui];
//        } else {
//            [self.view addSubview:self.tutorialTransitionView];
//            [self.view bringSubviewToFront:self.tutorialTransitionView];
//        }
//    } else {
//        if (self.tutorialTransitionView) {
//            [self.tutorialTransitionView removeFromSuperview];
//        }
//    }
//}
//
//- (void)tutorialSetupGui {
//    self.tutorialTransitionView = [[UIView alloc] initWithFrame:self.view.frame];
//    self.tutorialTransitionView.backgroundColor = [UIColor darkGrayColor];
//    self.tutorialTransitionView.alpha = ALPHA_LEVEL;
//    self.tutorialTransitionView.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *dismissTutorialGestureRecogniser = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tutorialDismiss)];
//    
//    dismissTutorialGestureRecogniser.numberOfTapsRequired = 1;
//    
//    [self.tutorialTransitionView addGestureRecognizer:dismissTutorialGestureRecogniser];
//    
//    UILabel *tapHereText = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, self.primeView.primeGreaterGrid.frame.size.height / 2, self.view.frame.size.width, 60)];
//    
//    [tapHereText setText:@"TAP HERE"];
//    
//    [self.tutorialTransitionView addSubview:tapHereText];
//    
//    [self.view addSubview:self.tutorialTransitionView];
//    [self.view bringSubviewToFront:self.tutorialTransitionView];
//}
//
//- (void)tutorialDismiss {
//    self.isTutorialMode = NO;
//}


@end
