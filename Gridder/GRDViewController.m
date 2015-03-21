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

@interface GRDViewController ()

@property (nonatomic, assign) int maxMilliseconds;

@end

@implementation GRDViewController

@synthesize sqr1, sqr10, sqr11, sqr12, sqr13, sqr14, sqr15, sqr16, sqr2, sqr3, sqr4, sqr5, sqr6, sqr7, sqr8, sqr9, progressView, grd1, grd10,grd11, grd12, grd13, grd14, grd15, grd16, grd2, grd3, grd4, grd5, grd6, grd7, grd8, grd9, gridder, theSquare, scoreLabel, livesDisplay, outline, pauseButton, pauseMenuButton, pauseTitle, gridderOutline, soundOffButton, glassSquares, onTheEdgeStreak, topSquareHolder, topComponentsHolder;

- (void)viewDidLoad {
	[super viewDidLoad];
	delegate = (GRDAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	delegate.gameVC = self;
	gridder = [[NSArray alloc] initWithObjects:grd1,grd2,grd3,grd4,grd5,grd6,grd7,grd8,grd9,grd10,grd11,grd12,grd13,grd14,grd15,grd16, nil];
	theSquare = [[NSArray alloc] initWithObjects:sqr1,sqr2,sqr3,sqr4,sqr5,sqr6,sqr7,sqr8,sqr9,sqr10,sqr11,sqr12,sqr13,sqr14,sqr15,sqr16, nil];
	glassSquares = [[NSMutableArray alloc] initWithObjects: nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(foregroundTransition)
												 name:@"appWillEnterForeground"
											   object:nil];
	
	[self initStyling];
}

-(BOOL)prefersStatusBarHidden{
	return YES;
}

- (void)initStyling {
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"px.png"]];
	
	topSquareHolder.backgroundColor = [UIColor clearColor];
	topComponentsHolder.backgroundColor = [UIColor clearColor];
	
	pauseButton.layer.cornerRadius = 3;
	[GRDWizard styleButtonAsASquare:soundOffButton];
	[GRDWizard styleButtonAsASquare:pauseMenuButton];
	
	self.transitionView = [[UIView alloc] initWithFrame:self.view.frame];
	self.transitionView.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.transitionView];
	[self.view bringSubviewToFront:self.transitionView];
	
	pauseTitle.hidden = YES;
	pauseMenuButton.hidden = YES;
	soundOffButton.hidden = YES;
	pauseMenuButton.layer.cornerRadius = 5;
	outline.layer.cornerRadius = 6;
	gridderOutline.layer.cornerRadius = 6;
	outline.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"inactive.png"]];
	gridderOutline.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"inactive.png"]];
	
	[self.view sendSubviewToBack:outline];
	[self.view sendSubviewToBack:gridderOutline];
	
	soundOffButton.backgroundColor = delegate.soundIsActive ? [UIColor blueColor] : [UIColor whiteColor];
	
	soundOffButton.backgroundColor = delegate.soundIsActive ? [UIColor blueColor] : [UIColor whiteColor];
	
	[soundOffButton setImage:delegate.soundIsActive ? [UIImage imageNamed:@"speaker-on.png"] : [UIImage imageNamed:@"speaker-off.png"] forState:UIControlStateNormal];
	
	pulseBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
	pulseBar.progressTintColor = [UIColor blueColor];
	pulseBar.center = self.view.center;
	pulseBar.frame = CGRectMake(0, 150, 320, 10);
	
	[self.view addSubview:pulseBar];
}


- (void)viewWillAppear:(BOOL)animated {
	[self setUpNewGame];
}

- (void)viewDidAppear:(BOOL)animated {
	[self setUpGlassSquares];
	[self setUpTheSquare];

}

- (void)setUpNewGame {
	delegate.gameIsCurrentlyPaused = NO;
	delegate.currentHighScore = [NSNumber numberWithInteger:0];
	delegate.currentStreak = 0;
	delegate.highestStreak = 0;
	onTheEdgeStreak = 0;
	glassLevel = 0;
	delegate.numLives = 3;
	delegate.currentStreak = 0;
	self.maxMilliseconds = 800;
	self.transitionView.hidden = YES;
	delegate.millisecondsFromGridPulse = 0;
	[self setupTheGridder];
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
	if(sqr1.isActive != grd1.isActive) return;
	if(sqr2.isActive != grd2.isActive) return;
	if(sqr3.isActive != grd3.isActive) return;
	if(sqr4.isActive != grd4.isActive) return;
	if(sqr5.isActive != grd5.isActive) return;
	if(sqr6.isActive != grd6.isActive) return;
	if(sqr7.isActive != grd7.isActive) return;
	if(sqr8.isActive != grd8.isActive) return;
	if(sqr9.isActive != grd9.isActive) return;
	if(sqr10.isActive != grd10.isActive) return;
	if(sqr11.isActive != grd11.isActive) return;
	if(sqr12.isActive != grd12.isActive) return;
	if(sqr13.isActive != grd13.isActive) return;
	if(sqr14.isActive != grd14.isActive) return;
	if(sqr15.isActive != grd15.isActive) return;
	if(sqr16.isActive != grd16.isActive) return;
	
	[self gridderPulse:YES];
}

- (void)setUpTheSquare {
	for (int i = 0; i < [theSquare count]; i++) {
		
		GRDSquare *square = [theSquare objectAtIndex:i];
		square.layer.cornerRadius = 5;
		square.backgroundColor = [UIColor blueColor];
		square.layer.borderColor = [UIColor blackColor].CGColor;
		square.layer.borderWidth = 3.0;
		square.userInteractionEnabled = YES;
		
		
		[square addTarget:self action:@selector(touchSquare:) forControlEvents:UIControlEventTouchDown];
		//[square addTarget:self action:@selector(touchSquare:) forControlEvents:UICon];
		
		/*UIControl *dragImageControl = [[UIControl alloc] initWithFrame:square.frame];
		[dragImageControl addSubview:square];
		[self.view addSubview:dragImageControl];
		
		[dragImageControl addTarget:self action:@selector(squareTouched:) forControlEvents:UIControlEventTouchDragInside];
		[dragImageControl addTarget:self action:@selector(squareTouched:) forControlEvents:UIControlEventTouchUpInside];*/
		
		/*UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(squareTouched:)];
		touch.numberOfTapsRequired = 1;
		touch.numberOfTouchesRequired = 1;
		[square addGestureRecognizer:touch];*/
		
		
		
		
	}
}

- (void)setUpGlassSquares {
	for (int i = 0; i < [theSquare count]; i++) {
		GRDSquare *square = [theSquare objectAtIndex:i];
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
		
		[glassSquares insertObject:glassSquare atIndex:i];
	}
}


- (void)setupTheGridder {
	for (int i = 0; i < [gridder count]; i++) {
		GRDSquare *square = [gridder objectAtIndex:i];
		square.backgroundColor = [UIColor blueColor];
		square.layer.borderColor = [UIColor blackColor].CGColor;
		square.layer.borderWidth = 2.0;
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

	for (int i = 0; i < [gridder count]; i++) { // Randomise The Gridder
		GRDSquare *square = [gridder objectAtIndex:i];
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
				GRDGlassSquare *glassSquare = [glassSquares objectAtIndex:arc4random() % [glassSquares count]];
				glassSquare.hidden = NO;
			}
		}
	}
	for (int o = 0; o < [theSquare count]; o++) { // Reset The Square
		GRDSquare *square = [theSquare objectAtIndex:o];
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
			onTheEdgeStreak++;
			if (onTheEdgeStreak == 10) {
				[delegate.menuVC.gameCenterManager submitAchievement:kAchievementOnTheEdge percentComplete:100];
			}
		} else {
			onTheEdgeStreak = 0;
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
		if(sqr1.isActive != grd1.isActive) return;
		if(sqr2.isActive != grd2.isActive) return;
		if(sqr3.isActive != grd3.isActive) return;
		if(sqr4.isActive != grd4.isActive) return;
		if(sqr5.isActive != grd5.isActive) return;
		if(sqr6.isActive != grd6.isActive) return;
		if(sqr7.isActive != grd7.isActive) return;
		if(sqr8.isActive != grd8.isActive) return;
		if(sqr9.isActive != grd9.isActive) return;
		if(sqr10.isActive != grd10.isActive) return;
		if(sqr11.isActive != grd11.isActive) return;
		if(sqr12.isActive != grd12.isActive) return;
		if(sqr13.isActive != grd13.isActive) return;
		if(sqr14.isActive != grd14.isActive) return;
		if(sqr15.isActive != grd15.isActive) return;
		if(sqr16.isActive != grd16.isActive) return;
	
	[self gridderPulse:YES];
}

- (void)foregroundTransition {	
	[self.view bringSubviewToFront:outline];
	[self.view bringSubviewToFront:gridderOutline];
	[self.view bringSubviewToFront:pauseMenuButton];
	[self.view bringSubviewToFront:pauseTitle];
	[self.view bringSubviewToFront:soundOffButton];
	delegate.gameIsCurrentlyPaused = YES;
	pauseMenuButton.hidden = NO;
	pauseTitle.hidden = NO;
	soundOffButton.hidden = NO;
	[pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
	pauseButton.backgroundColor = [UIColor whiteColor];
	[delegate.pulseTimer invalidate];
}

- (IBAction)pauseButtonTouched:(id)sender {
	if (delegate.soundIsActive) [delegate.soundPlayer.menuBlip2SoundPlayer play];
	if (!delegate.gameIsCurrentlyPaused) {
		[self.view bringSubviewToFront:outline];
		[self.view bringSubviewToFront:gridderOutline];
		[self.view bringSubviewToFront:pauseMenuButton];
		[self.view bringSubviewToFront:pauseTitle];
		[self.view bringSubviewToFront:soundOffButton];
		[self.view bringSubviewToFront:pauseButton];
		delegate.gameIsCurrentlyPaused = YES;
		pauseMenuButton.hidden = NO;
		pauseTitle.hidden = NO;
		soundOffButton.hidden = NO;
		pauseButton.layer.borderColor = [UIColor blackColor].CGColor;
		pauseButton.layer.borderWidth = 3.0;
		[pauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
		pauseButton.backgroundColor = [UIColor whiteColor];
		[delegate.pulseTimer invalidate];
		if (delegate.soundIsActive) [delegate.soundPlayer.gameThemePlayer pause];
	} else if (delegate.gameIsCurrentlyPaused) {
		[self.view sendSubviewToBack:outline];
		[self.view sendSubviewToBack:gridderOutline];
		delegate.gameIsCurrentlyPaused = NO;
		pauseMenuButton.hidden = YES;
		pauseTitle.hidden = YES;
		soundOffButton.hidden = YES;
		[pauseButton setImage:nil forState:UIControlStateNormal];
		pauseButton.backgroundColor = [UIColor clearColor];
		pauseButton.layer.borderColor = [UIColor clearColor].CGColor;
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
		[soundOffButton setImage:[UIImage imageNamed:@"speaker-off.png"] forState:UIControlStateNormal];
		soundOffButton.backgroundColor = [UIColor whiteColor];
	} else {
		delegate.soundIsActive = YES;
		[soundOffButton setImage:[UIImage imageNamed:@"speaker-on.png"] forState:UIControlStateNormal];
		soundOffButton.backgroundColor = [UIColor blueColor];
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

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
