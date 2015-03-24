//
//  GRDViewController.m
//  Gridder
//
//  Created by Joshua James on 10/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GRDSquare.h"
#import "GRDMenu.h"

#define LESSERGRID_SQUARE_SIZE 9
#define GREATERGRID_SQUARE_SIZE 4

@interface GRDViewController ()

@property (nonatomic, assign) int maxMilliseconds;

@end

@implementation GRDViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	delegate = (GRDAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	delegate.gameVC = self;
	self.greaterGridCollection = [[NSMutableArray alloc] init];
	self.lesserGridCollection = [[NSMutableArray alloc] init];
	[self generateGreaterGridWithXOffset:0 withYOffset:0 fromCount:1];
	[self generateLesserGridWithXOffset:0 withYOffset:0 fromCount:1];
	
	self.glassSquares = [[NSMutableArray alloc] initWithObjects: nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(foregroundTransition)
												 name:@"appWillEnterForeground"
											   object:nil];
	
	self.greaterGrid.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
	self.lesserGrid.frame = CGRectMake(0, 0, (self.view.bounds.size.width / LESSERGRID_SQUARE_SIZE) * 4, (self.view.bounds.size.width / LESSERGRID_SQUARE_SIZE) * 4);

	[self setupGUI];
}



- (void)viewWillAppear:(BOOL)animated {
	[self setUpNewGame];
}

- (void)viewDidAppear:(BOOL)animated {
	[self setUpGlassSquares];

}

- (void)setUpNewGame {
	delegate.gameIsCurrentlyPaused = NO;
	delegate.currentHighScore = [NSNumber numberWithInteger:0];
	delegate.currentStreak = 0;
	delegate.highestStreak = 0;
	self.onTheEdgeStreak = 0;
	glassLevel = 0;
	delegate.numLives = 3;
	delegate.currentStreak = 0;
	self.maxMilliseconds = 800;
	self.transitionView.hidden = YES;
	delegate.millisecondsFromGridPulse = 0;
	[self randomiseGridder];
	
	delegate.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
	
	if (delegate.soundIsActive) [delegate.soundPlayer.gameThemePlayer play];
	
	self.scoreLabel.text = [NSString stringWithFormat:@"%d", [delegate.currentHighScore intValue]];
	pulseBar.hidden = NO;
	self.livesDisplay.text = [NSString stringWithFormat:@"%d", delegate.numLives];
}

- (IBAction)touchSquare:(id)sender {
	if (delegate.soundIsActive) [delegate.soundPlayer.squareTouchedSoundPlayer play];
	GRDSquare *touchedSquare = (GRDSquare *)sender;
	
	if(!touchedSquare.isActive) {
		int randomPop = arc4random() % 100;
		if(randomPop >= 0 && randomPop <= 3) {
			[touchedSquare setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"clock-icon.png"]]];
			delegate.millisecondsFromGridPulse--;
			[GRDWizard gainTime:touchedSquare withGrdVC:self];
		} else if(randomPop == 100) {
			[touchedSquare setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"heart.png"]]];
			[GRDWizard gainALife:self];
		} else {
			[touchedSquare setBackgroundColor:[UIColor whiteColor]];
		}
		touchedSquare.isActive = YES;
	} else {
		[touchedSquare setBackgroundColor:[UIColor blueColor]];
		touchedSquare.isActive = NO;
	}
	
	if ([GRDWizard gridComparisonMatches:self.greaterGrid compareWithSuperview2:self.lesserGrid]) {
		[self gridderPulse:YES];
	}
}


- (void)setUpGlassSquares {
	for (int i = 0; i < [self.greaterGridCollection count]; i++) {
		GRDSquare *square = [self.greaterGridCollection objectAtIndex:i];
		GRDGlassSquare *glassSquare = [[GRDGlassSquare alloc] initWithFrame:CGRectMake(square.frame.origin.x, square.frame.origin.y, square.frame.size.width, square.frame.size.height + 20)];
		glassSquare.image = [UIImage imageNamed:@"Ice1.png"];
				
		glassSquare.alpha = 0.4;
		glassSquare.userInteractionEnabled = YES;
		glassSquare.timesTouched = 0;
		
		[self.view addSubview:glassSquare];
		[self.view bringSubviewToFront:glassSquare];
		
		
		glassSquare.hidden = YES;
		
		UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(glassTouched:)];
		touch.numberOfTapsRequired = 1;
		touch.numberOfTouchesRequired = 1;
		[glassSquare addGestureRecognizer:touch];
		
		[self.glassSquares insertObject:glassSquare atIndex:i];
	}
}

- (void)timerFireMethod:(NSTimer *)theTimer {
	delegate.millisecondsFromGridPulse += 10;
	if(delegate.millisecondsFromGridPulse >= self.maxMilliseconds) {
		delegate.millisecondsFromGridPulse = 0;
		[self gridderPulse:NO];
	}
	
	[pulseBar setProgress:((float)delegate.millisecondsFromGridPulse / self.maxMilliseconds) animated:YES];
}

- (void)randomiseGridder {
	int totalActive = 0;

	for (int i = 0; i < [self.lesserGridCollection count]; i++) { // Randomise The Gridder
		GRDSquare *square = [self.lesserGridCollection objectAtIndex:i];
		int flip = arc4random() % 2;
		if(flip == 0) {
			square.isActive = NO;
			[square setBackgroundColor: [UIColor blueColor]];
		} else {
			totalActive++;
			if (delegate.difficultyLevel == 0) {
				if(totalActive <= 4) {
					square.isActive = YES;
					[square setBackgroundColor: [UIColor whiteColor]];
				}
			} else if (delegate.difficultyLevel == 1) {
				if(totalActive <= 4) {
					square.isActive = YES;
					[square setBackgroundColor: [UIColor whiteColor]];
				}
			} else if (delegate.difficultyLevel == 2) {
				if(totalActive <= 5) {
					square.isActive = YES;
					[square setBackgroundColor: [UIColor whiteColor]];
				}
			}
		}
		
		
	}
	
	if (glassLevel > 0) {
		if (arc4random() % 2 == 1) {
			for (int i = 0; i < glassLevel; i++) {
				GRDGlassSquare *glassSquare = [self.glassSquares objectAtIndex:arc4random() % [self.glassSquares count]];
				glassSquare.hidden = NO;
			}
		}
	}
	for (int o = 0; o < [self.greaterGridCollection count]; o++) { // Reset The Square
		GRDSquare *square = [self.greaterGridCollection objectAtIndex:o];
		square.isActive = NO;
		[square setBackgroundColor: [UIColor blueColor]];
	}
}

- (void)gridderPulse:(BOOL)successful {
	delegate.numRounds++;
	NSLog (@"NumRounds %d", delegate.numRounds);
	delegate.inverseModeActive = NO;

	self.transitionView.hidden = NO;
	[UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{ self.transitionView.alpha = 1.0f; } completion:^(BOOL finished) { self.transitionView.hidden = YES; self.transitionView.alpha = 0;}];

	[self randomiseGridder];
	
	if(successful) {
		if (delegate.numLives == 1) {
			self.onTheEdgeStreak++;
			if (self.onTheEdgeStreak == 10) {
				[delegate.menuVC.gameCenterManager submitAchievement:kAchievementOnTheEdge percentComplete:100];
			}
		} else {
			self.onTheEdgeStreak = 0;
		}
		
		delegate.soundPlayer.pulseSuccessSoundPlayer.currentTime = 0;
		if (delegate.soundIsActive) [delegate.soundPlayer.pulseSuccessSoundPlayer play];
		
		[GRDWizard gainPoints:self];
		
		delegate.currentStreak++;
		if (delegate.numRounds > 50) {
			NSLog(@"*****INSANITY MODE ACTIVATED");
			delegate.difficultyLevel = 2;
		} else if (delegate.numRounds > 10) {
			delegate.difficultyLevel = 1;
		}
		
		if (glassLevel < 3) {
			glassLevel = (delegate.numRounds + 1) / 6;
		}
		
		if(delegate.currentStreak > delegate.highestStreak) delegate.highestStreak++;
		
		if(delegate.currentStreak % 10 == 0) [GRDWizard gainALife:self];
		
		self.scoreLabel.text = [NSString stringWithFormat:@"%d", [delegate.currentHighScore intValue]];
		
		int newScore = 0;
		if (delegate.difficultyLevel == 0) {
			newScore = [delegate.currentHighScore integerValue] + (50 / (delegate.millisecondsFromGridPulse + 1)+ 5 + (delegate.numRounds * 2));
		} else if (delegate.difficultyLevel == 1) {
			newScore = [delegate.currentHighScore integerValue] + (200 / (delegate.millisecondsFromGridPulse + 1) + 10 + (delegate.numRounds * 2));
		} else if (delegate.difficultyLevel == 2) {
			newScore = [delegate.currentHighScore integerValue] + (400 / (delegate.millisecondsFromGridPulse + 1) + 20);
		}
		delegate.currentHighScore = [NSNumber numberWithInteger:newScore];

		if (delegate.difficultyLevel == 0) {
			if (self.maxMilliseconds > 300) self.maxMilliseconds -= 30;
		} else if (delegate.difficultyLevel == 1) {
			if (self.maxMilliseconds > 280) self.maxMilliseconds -= 30;
		}else if (delegate.difficultyLevel == 2) {
			if (self.maxMilliseconds > 250) self.maxMilliseconds -= 30;
		}
		
		
	} else if (successful == NO) {
		delegate.soundPlayer.pulseFailSoundPlayer.currentTime = 0;
		if (delegate.soundIsActive) [delegate.soundPlayer.pulseFailSoundPlayer play];
		
		delegate.currentStreak = 0;
		self.scoreLabel.text = [NSString stringWithFormat:@"%d", [delegate.currentHighScore intValue]];
		if(self.maxMilliseconds < 600) self.maxMilliseconds += 40;
		[GRDWizard loseALife:self];
	}
	
	self.scoreLabel.text = [NSString stringWithFormat:@"%d", [delegate.currentHighScore integerValue]];

	delegate.millisecondsFromGridPulse = 0;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)glassTouched:(UIGestureRecognizer *)gestureRecogniser {
	GRDGlassSquare *touchedGlass = (GRDGlassSquare *)gestureRecogniser.view;
	
	switch (touchedGlass.timesTouched) {
		case 0:
			touchedGlass.timesTouched++;
			delegate.soundPlayer.bumpSoundPlayer.currentTime = 0;
			delegate.soundPlayer.bumpSoundBackupPlayer.currentTime = 0;
			if(delegate.soundIsActive) {
				if (![delegate.soundPlayer.bumpSoundPlayer isPlaying]) {
					[delegate.soundPlayer.bumpSoundPlayer play];
				} else {
					[delegate.soundPlayer.bumpSoundBackupPlayer play];
				}
			}
			touchedGlass.image = [UIImage imageNamed:@"Ice2.png"];
			break;
		case 1:
			touchedGlass.timesTouched++;
			delegate.soundPlayer.bumpSoundPlayer.currentTime = 0;
			delegate.soundPlayer.bumpSoundBackupPlayer.currentTime = 0;
			if (delegate.soundIsActive) {
				if (![delegate.soundPlayer.bumpSoundPlayer isPlaying]) {
					[delegate.soundPlayer.bumpSoundPlayer play];
				} else {
					[delegate.soundPlayer.bumpSoundBackupPlayer play];
				}
			}
			touchedGlass.image = [UIImage imageNamed:@"Ice3.png"];
			break;
		case 2:
			delegate.iceBreaks++;
			touchedGlass.timesTouched = 0;
			touchedGlass.hidden = YES;
			touchedGlass.image = [UIImage imageNamed:@"Ice1.png"];
			if (delegate.soundIsActive) {
				if (![delegate.soundPlayer.shatterSoundPlayer isPlaying]) {
					[delegate.soundPlayer.shatterSoundPlayer play];
				} else {
					[delegate.soundPlayer.shatterSoundBackupPlayer play];
				}
			}
			[self checkForAchievements];
		default:
			break;
	}
}

- (void)squareTouched:(UIGestureRecognizer *)gestureRecogniser {
	if (delegate.soundIsActive) [delegate.soundPlayer.squareTouchedSoundPlayer play];
	GRDSquare *touchedSquare = (GRDSquare *)gestureRecogniser.view;
	
	if(!touchedSquare.isActive) {
		int randomPop = arc4random() % 100;
		if(randomPop >= 0 && randomPop <= 3) {
			[touchedSquare setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"clock-icon.png"]]];
			delegate.millisecondsFromGridPulse--;
			[GRDWizard gainTime:touchedSquare withGrdVC:self];
		} else if(randomPop == 100) {
			[touchedSquare setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"heart.png"]]];
			[GRDWizard gainALife:self];
		} else {
			[touchedSquare setBackgroundColor:[UIColor whiteColor]];
		}
		touchedSquare.isActive = YES;
	} else {
		[touchedSquare setBackgroundColor:[UIColor blueColor]];
		touchedSquare.isActive = NO;
	}

	if ([GRDWizard gridComparisonMatches:self.greaterGrid compareWithSuperview2:self.lesserGrid]) {
		[self gridderPulse:YES];
	}
}

- (void)foregroundTransition {
	[self.view bringSubviewToFront:self.pauseMenuButton];
	[self.view bringSubviewToFront:self.soundOffButton];
	delegate.gameIsCurrentlyPaused = YES;
	self.pauseMenuButton.hidden = NO;
	self.soundOffButton.hidden = NO;
	[self.pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	self.pauseButton.backgroundColor = [UIColor whiteColor];
	[delegate.pulseTimer invalidate];
}

- (IBAction)pauseButtonTouched:(id)sender {
	if (delegate.soundIsActive) [delegate.soundPlayer.menuBlip2SoundPlayer play];
	if (!delegate.gameIsCurrentlyPaused) {
		[self.view bringSubviewToFront:self.pauseMenuButton];
		[self.view bringSubviewToFront:self.soundOffButton];
		[self.view bringSubviewToFront:self.pauseButton];
		delegate.gameIsCurrentlyPaused = YES;
		self.pauseMenuButton.hidden = NO;
		self.soundOffButton.hidden = NO;
		self.pauseButton.layer.borderColor = [UIColor blackColor].CGColor;
		self.pauseButton.layer.borderWidth = 3.0;
		[self.pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
		self.pauseButton.backgroundColor = [UIColor whiteColor];
		[delegate.pulseTimer invalidate];
		if (delegate.soundIsActive) [delegate.soundPlayer.gameThemePlayer pause];
	} else if (delegate.gameIsCurrentlyPaused) {
		delegate.gameIsCurrentlyPaused = NO;
		self.pauseMenuButton.hidden = YES;
		self.soundOffButton.hidden = YES;
		[self.pauseButton setImage:nil forState:UIControlStateNormal];
		self.pauseButton.backgroundColor = [UIColor clearColor];
		self.pauseButton.layer.borderColor = [UIColor clearColor].CGColor;
		//[pauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
		//pauseButton.backgroundColor = [UIColor blueColor];
		delegate.pulseTimer  = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
		if (delegate.soundIsActive) [delegate.soundPlayer.gameThemePlayer play];
	}

}

- (IBAction)returnToMenu:(id)sender {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Are you sure?"
													message:@"Returning to the main menu will end your current game."
												   delegate:self
										  cancelButtonTitle:@"Cancel"
										  otherButtonTitles:@"Ok", nil];
	alert.alertViewStyle = UIAlertViewStyleDefault;
	[alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
		if (delegate.soundIsActive) [delegate.soundPlayer.menuThemePlayer play];
		delegate.gameInProgress = NO;
		delegate.gameIsCurrentlyPaused = NO;
		[delegate.pulseTimer invalidate];
		[self performSegueWithIdentifier:@"returnToMenu" sender:nil];
    }
}

-(IBAction)soundButtonTouched:(id)sender {
	[delegate.soundPlayer.menuBlipSoundPlayer play];
	if (delegate.soundIsActive) {
		delegate.soundIsActive = NO;
		[self.soundOffButton setImage:[UIImage imageNamed:@"speaker-off.png"] forState:UIControlStateNormal];
		self.soundOffButton.backgroundColor = [UIColor whiteColor];
	} else {
		delegate.soundIsActive = YES;
		[self.soundOffButton setImage:[UIImage imageNamed:@"speaker-on.png"] forState:UIControlStateNormal];
		self.soundOffButton.backgroundColor = [UIColor blueColor];
	}
}

- (void)checkForAchievements {
    NSString* identifier = NULL;
    double percentComplete = 0;
    switch(delegate.iceBreaks) {
        case 10:
            identifier = kAchievementIceBreaker;
            percentComplete = 20.0;
            break;
        case 20:
            identifier = kAchievementIceBreaker;
            percentComplete = 40.0;
            break;
        case 30:
            identifier = kAchievementIceBreaker;
            percentComplete = 60.0;
            break;
        case 40:
            identifier = kAchievementIceBreaker;
            percentComplete = 80.0;
            break;
        case 50:
            identifier = kAchievementIceBreaker;
            percentComplete = 100.0;
            break;
    }
	
    if(identifier != NULL) {
        [delegate.menuVC.gameCenterManager submitAchievement:identifier percentComplete:percentComplete];
    }
}

#pragma mark -
#pragma mark UI Functions
#pragma mark -

- (void)generateGreaterGridWithXOffset:(NSInteger)xOffset withYOffset:(NSInteger)yOffset fromCount:(NSInteger)count {
	GRDSquare *square = [[[NSBundle mainBundle] loadNibNamed:@"GRDSquare"
													   owner:self
													 options:nil] lastObject];
	
	square.frame = CGRectMake(0 + xOffset, yOffset, self.view.bounds.size.width / GREATERGRID_SQUARE_SIZE, self.view.bounds.size.width / GREATERGRID_SQUARE_SIZE);
	square.layer.shadowColor = (__bridge CGColorRef)([UIColor blueColor]);
	square.layer.shadowRadius = 20.0f;
	square.layer.shadowOpacity = .9;
	square.layer.shadowOffset = CGSizeZero;
	square.layer.masksToBounds = NO;
	square.tag = count;
	square.layer.cornerRadius = 5;
	square.backgroundColor = [UIColor blueColor];
	square.layer.borderColor = [UIColor blackColor].CGColor;
	square.layer.borderWidth = 3.0;
	square.userInteractionEnabled = YES;
	//[square addTarget:self action:@selector(touchSquare:) forControlEvents:UIControlEventTouchDown];
	
	[self.greaterGrid addSubview:square];
	[self.greaterGridCollection addObject:square];
	
	if (count % 4 == 0) {
		if(count >= 16) return;
		yOffset += square.bounds.size.height;
		[self generateGreaterGridWithXOffset:0 withYOffset:yOffset fromCount:count + 1];
		return;
	}
	
	[self generateGreaterGridWithXOffset:xOffset + self.view.bounds.size.width / 4 withYOffset:yOffset fromCount:count + 1];
}

- (void)generateLesserGridWithXOffset:(NSInteger)xOffset withYOffset:(NSInteger)yOffset fromCount:(NSInteger)count {
	GRDSquare *square = [[[NSBundle mainBundle] loadNibNamed:@"GRDSquare"
													   owner:self
													 options:nil] lastObject];
	
	square.frame = CGRectMake(0 + xOffset, yOffset, self.view.bounds.size.width / LESSERGRID_SQUARE_SIZE, self.view.bounds.size.width / LESSERGRID_SQUARE_SIZE);
	square.layer.shadowColor = (__bridge CGColorRef)([UIColor blueColor]);
	square.layer.shadowRadius = 20.0f;
	square.layer.shadowOpacity = .9;
	square.layer.shadowOffset = CGSizeZero;
	square.layer.masksToBounds = NO;
	square.tag = count;
	square.layer.cornerRadius = 5;
	square.backgroundColor = [UIColor blueColor];
	square.layer.borderColor = [UIColor blackColor].CGColor;
	square.layer.borderWidth = 3.0;
	
	[self.lesserGrid addSubview:square];
	[self.lesserGridCollection addObject:square];
	
	if (count % 4 == 0) {
		if(count >= 16) return;
		yOffset += square.bounds.size.height;
		[self generateLesserGridWithXOffset:0 withYOffset:yOffset fromCount:count + 1];
		return;
	}
	
	[self generateLesserGridWithXOffset:xOffset + self.view.bounds.size.width / LESSERGRID_SQUARE_SIZE withYOffset:yOffset fromCount:count + 1];
}

- (void)setupGUI {
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"px.png"]];
	
	self.lesserGrid.backgroundColor = [UIColor clearColor];
	self.topComponentsHolder.backgroundColor = [UIColor clearColor];
	
	self.pauseButton.layer.cornerRadius = 3;
	[GRDWizard styleButtonAsASquare:self.soundOffButton];
	[GRDWizard styleButtonAsASquare:self.pauseMenuButton];
	
	self.transitionView = [[UIView alloc] initWithFrame:self.view.frame];
	self.transitionView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.transitionView];
	[self.view bringSubviewToFront:self.transitionView];
	
	self.pauseMenuButton.hidden = YES;
	self.soundOffButton.hidden = YES;
	self.pauseMenuButton.layer.cornerRadius = 5;
	
	self.soundOffButton.backgroundColor = delegate.soundIsActive ? [UIColor blueColor] : [UIColor whiteColor];
	
	self.soundOffButton.backgroundColor = delegate.soundIsActive ? [UIColor blueColor] : [UIColor whiteColor];
	
	[self.soundOffButton setImage:delegate.soundIsActive ? [UIImage imageNamed:@"speaker-on.png"] : [UIImage imageNamed:@"speaker-off.png"] forState:UIControlStateNormal];
	
	pulseBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	pulseBar.progressTintColor = [UIColor blueColor];
	pulseBar.center = self.view.center;
	pulseBar.frame = CGRectMake(0, 150, 320, 10);
	
	[self.view addSubview:pulseBar];
}

- (BOOL)prefersStatusBarHidden{
	return YES;
}


@end
