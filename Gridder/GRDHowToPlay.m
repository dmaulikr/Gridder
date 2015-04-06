//
//  GRDHowToPlay.m
//  Gridder
//
//  Created by Joshua James on 13/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDHowToPlay.h"
#import <QuartzCore/QuartzCore.h>
#import "GRDMenu.h"
/*
@interface GRDHowToPlay ()

@end

@implementation GRDHowToPlay

@synthesize backButton, howToScroller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	delegate = (GRDAppDelegate *)[[UIApplication sharedApplication] delegate];

		
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"inactive.png"]];
	
	[GRDWizard styleButtonAsASquare:backButton];

	howToScroller.layer.cornerRadius = 5;
	howToScroller.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"active.png"]];
	howToScroller.layer.borderColor = [UIColor blackColor].CGColor;
	howToScroller.layer.borderWidth = 3.0;
	howToScroller.userInteractionEnabled = NO;
	

}

-(void)viewDidAppear:(BOOL)animated {
	[self freeze];

}
- (void)freeze {
	GRDGlassSquare *glassSquare = [[GRDGlassSquare alloc] initWithFrame:CGRectMake(backButton.frame.origin.x, backButton.frame.origin.y, backButton.frame.size.width, backButton.frame.size.height + 20)];
	glassSquare.image = [UIImage imageNamed:@"Ice1.png"];
	
	glassSquare.alpha = 0.4;
	glassSquare.userInteractionEnabled = YES;
	glassSquare.timesTouched = 0;
	
	[self.view addSubview:glassSquare];
	[self.view bringSubviewToFront:glassSquare];
	
	UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(glassTouched:)];
	touch.numberOfTapsRequired = 1;
	touch.numberOfTouchesRequired = 1;
	[glassSquare addGestureRecognizer:touch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {
	if (delegate.soundIsActive) [delegate.soundPlayer.menuBlipSoundPlayer play];
	[self performSegueWithIdentifier:@"returnToMenu" sender:nil];
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
			//[delegate.menuVC.gameCenterManager submitAchievement:kAchievementGlutton percentComplete:100];

		default:
			break;
	}
	
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}


@end
*/