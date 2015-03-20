//
//  GRDMenu.m
//  Gridder
//
//  Created by Joshua James on 12/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDMenu.h"
#import <QuartzCore/QuartzCore.h>
#import "GRDViewController.h"

@interface GRDMenu () 

@end

@implementation GRDMenu
@synthesize goButton, tutorialButton, creditsButton, gridderLogo, highScoresButton, soundButton, leaderboardButton, achievementsButton, currentLeaderBoard, rateButton, emailButton, gameCenterManager;

-(BOOL)prefersStatusBarHidden{
	return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)squareTouched:(UIGestureRecognizer *)gestureRecogniser {
	if (delegate.soundIsActive) [delegate.soundPlayer.squareTouchedSoundPlayer play];
	GRDSquare *touchedSquare = (GRDSquare *)gestureRecogniser.view;

	if(!touchedSquare.isActive) {
		[touchedSquare setBackgroundColor:[UIColor whiteColor]];
		touchedSquare.isActive = YES;
	} else {
		[touchedSquare setBackgroundColor:[UIColor blueColor]];
		touchedSquare.isActive = NO;
	}
}

- (void)styleTheMenuGrid:(NSArray *)menuItems {
	for (int i = 0; i < [menuItems count]; i++) {
		UIButton *menuItem = [menuItems objectAtIndex:i];
		
		[GRDWizard styleButtonAsASquare:menuItem];
	}
}

- (void)setupGameCenter {
	self.currentLeaderBoard = kLeaderboardID;
    if ([GameCenterManager isGameCenterAvailable]) {
        self.gameCenterManager = [[GameCenterManager alloc] init];
        [self.gameCenterManager setDelegate:self];
        [self authenticateLocalUser];
    } else {
		NSLog(@"Game Center Unavailable");
        // The current device does not support Game Center.
    }
	
	[GKAchievement loadAchievementsWithCompletionHandler: ^(NSArray *scores, NSError *error)
	{
		if(error != NULL) { /* error handling */ }
		for (GKAchievement* achievement in scores) {
			if ([achievement.identifier isEqual:kAchievementIceBreaker]) {
				NSInteger achievementProgress = achievement.percentComplete;
				if (delegate.iceBreaks == 0) {
					switch (achievementProgress) {
						case 0:
							delegate.iceBreaks = 0;
							break;
						case 20:
							delegate.iceBreaks = 10;
							break;
						case 40:
							delegate.iceBreaks = 20;
							break;
						case 60:
							delegate.iceBreaks = 30;
							break;
						case 80:
							delegate.iceBreaks = 40;
							break;
						case 100:
							delegate.iceBreaks = 50;
						default:
							break;
					}
				}
			}
		}
		
	}];
}

- (void)viewDidLoad {
	delegate = (GRDAppDelegate *)[[UIApplication sharedApplication] delegate];
	delegate.menuVC = self;
	
	[self setupGameCenter];
	
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(reopen)
												 name:@"appDidBecomeActive"
											   object:nil];
	
	UIImage *logoFrame1 = [UIImage imageNamed:@"gridder1.png"];
	UIImage *logoFrame2 = [UIImage imageNamed:@"gridder2.png"];
	UIImage *logoFrame3 = [UIImage imageNamed:@"gridder3.png"];
	UIImage *logoFrame4 = [UIImage imageNamed:@"gridder4.png"];
	UIImage *logoFrame5 = [UIImage imageNamed:@"gridder5.png"];
	UIImage *logoFrame6 = [UIImage imageNamed:@"gridder6.png"];
	
	gridderLogo.animationImages = [[NSArray alloc] initWithObjects:logoFrame1, logoFrame2, logoFrame3, logoFrame4, logoFrame5, logoFrame6, nil];
	gridderLogo.animationRepeatCount = -1;
	gridderLogo.animationDuration = 5.0;
	[gridderLogo startAnimating];
	
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"inactive.png"]];
	
	
	[self styleTheMenuGrid:[[NSArray alloc]initWithObjects:goButton, tutorialButton, creditsButton, highScoresButton, soundButton, leaderboardButton, achievementsButton, rateButton, emailButton, nil]];
	goButton.backgroundColor = [UIColor whiteColor];
	goButton.titleLabel.textColor = [UIColor blackColor];
	
	soundButton.backgroundColor = delegate.soundIsActive ? [UIColor blueColor] : [UIColor whiteColor];
	[soundButton setImage:delegate.soundIsActive ? [UIImage imageNamed:@"speaker-on.png"] : [UIImage imageNamed:@"speaker-off.png"] forState:UIControlStateNormal];

	
    [super viewDidLoad];
	
	if (delegate.soundIsActive && ![delegate.soundPlayer.menuThemePlayer isPlaying]) [delegate.soundPlayer.menuThemePlayer play];
}

- (void)reopen {
	if(!delegate.gameInProgress) {
		if(delegate.soundIsActive && ![delegate.soundPlayer.menuThemePlayer isPlaying]) [delegate.soundPlayer.menuThemePlayer play];
	} else if(!delegate.gameIsCurrentlyPaused && delegate.soundIsActive) {
		[delegate.soundPlayer.gameThemePlayer play];
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goButtonTouched:(id)sender {
	delegate.soundPlayer.menuBlip2SoundPlayer.currentTime = 0;
	if (delegate.soundIsActive) [delegate.soundPlayer.menuBlip2SoundPlayer play];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Prepare yourself!" message:@"Are you really ready?" delegate:self cancelButtonTitle:@"Wait a sec..." otherButtonTitles:@"Yeah!", nil];
	alert.tag = 0;
	alert.alertViewStyle = UIAlertViewStyleDefault;
	[alert show];
	
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 0) { // Go button
		if(buttonIndex != 0) {
			[delegate.soundPlayer.menuThemePlayer stop];
			delegate.gameInProgress = YES;
			delegate.difficultyLevel = 0;
			[delegate.soundPlayer.gameThemePlayer stop];
			delegate.numRounds = 0;
			[self performSegueWithIdentifier:@"startGame" sender:nil];
		}
	} else if (alertView.tag == 1) { // Feedback button
		if(buttonIndex != 0) { 
			if ([MFMailComposeViewController canSendMail]) {
				MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
				mailer.mailComposeDelegate = self;
				[mailer setSubject:@"Gridder Feedback"];
				NSArray *toRecipients = [NSArray arrayWithObjects:@"jjvarghese@gmail.com", nil];
				[mailer setToRecipients:toRecipients];
				NSString *emailBody = @"";
				[mailer setMessageBody:emailBody isHTML:NO];
				[self presentViewController:mailer animated:YES completion:nil];
			} else {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops!"
															message:@"Your device can't send email."
														   delegate:nil
												  cancelButtonTitle:@"Ok"
												  otherButtonTitles:nil];
				[alert show];
			}
		}
	} else if (alertView.tag == 2) {
		if(buttonIndex != 0) {
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=673989684&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"]];
		}
	}
}

- (IBAction)tutorialButtonTouched:(id)sender {
	delegate.soundPlayer.menuBlipSoundPlayer.currentTime = 0;
	if (delegate.soundIsActive) [delegate.soundPlayer.menuBlipSoundPlayer play];
	[self performSegueWithIdentifier:@"howToPlay" sender:nil];
}

- (IBAction)highScoresButtonTouched:(id)sender {
	delegate.soundPlayer.menuBlipSoundPlayer.currentTime = 0;
	if (delegate.soundIsActive) [delegate.soundPlayer.menuBlipSoundPlayer play];
	[self performSegueWithIdentifier:@"openHighScores" sender:nil];
}

- (IBAction)creditsButtonTouched:(id)sender {
	delegate.soundPlayer.menuBlipSoundPlayer.currentTime = 0;
	if (delegate.soundIsActive) [delegate.soundPlayer.menuBlipSoundPlayer play];
	[self performSegueWithIdentifier:@"openCredits" sender:nil];
}

- (void)soundTouched:(id)sender {
	delegate.soundPlayer.menuBlipSoundPlayer.currentTime = 0;
	[delegate.soundPlayer.menuBlipSoundPlayer play];
	if (delegate.soundIsActive) {
		delegate.soundIsActive = NO;
		[delegate.soundPlayer.menuThemePlayer pause];
		soundButton.backgroundColor = [UIColor whiteColor];
		
	
		[soundButton setImage:[UIImage imageNamed:@"speaker-off.png"] forState:UIControlStateNormal];
	} else {
		delegate.soundIsActive = YES;
		[delegate.soundPlayer.menuThemePlayer play];
		soundButton.backgroundColor = [UIColor blueColor];
		[soundButton setImage:[UIImage imageNamed:@"speaker-on.png"] forState:UIControlStateNormal];

	}
}

- (IBAction)emailTouched:(id)sender {
	if (delegate.soundIsActive) [delegate.soundPlayer.menuBlipSoundPlayer play];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Send Feedback?" message:@"Got a suggestion or bug report? Send it over!" delegate:self cancelButtonTitle:@"Nope..." otherButtonTitles:@"Write!", nil];
	alert.tag = 1;
	alert.alertViewStyle = UIAlertViewStyleDefault;
	[alert show];
}

- (IBAction)rateTouched:(id)sender {
	if (delegate.soundIsActive) [delegate.soundPlayer.menuBlipSoundPlayer play];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Rate Gridder?" message:@"If you like Gridder, please rate it!" delegate:self cancelButtonTitle:@"Later..." otherButtonTitles:@"Rate!", nil];
	alert.tag = 2;
	alert.alertViewStyle = UIAlertViewStyleDefault;
	[alert show];
}

- (IBAction)showLeaderboard:(id)sender {
	
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL)
    {
        leaderboardController.category = self.currentLeaderBoard;
        leaderboardController.timeScope = GKLeaderboardTimeScopeWeek;
        leaderboardController.leaderboardDelegate = self;
        [self presentViewController:leaderboardController animated:YES completion:nil];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showAchievements:(id)sender {
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != NULL) {
        achievements.achievementDelegate = self;
        [self presentViewController:achievements animated:YES completion:nil];
    }
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
	// Remove the mail view
	[self dismissViewControllerAnimated:YES completion:nil];
}


#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] \
compare:v options:NSNumericSearch] == NSOrderedAscending)

- (void)authenticateLocalUser {
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    if (SYSTEM_VERSION_LESS_THAN(@"6.0"))
    {
        // ios 5.x and below
        /*[localPlayer authenticateWithCompletionHandler:^(NSError *error)
         {
             [self checkLocalPlayer];
         }];*/
    }
    else
    {
        // ios 6.0 and above
        [localPlayer setAuthenticateHandler:(^(UIViewController* viewcontroller, NSError *error) {
            if (!error && viewcontroller)
            {
				[self presentViewController:viewcontroller animated:YES completion:nil];
				
            }
            else
            {
                [self checkLocalPlayer];
            }
        })];
    }
}

- (void)checkLocalPlayer
{
    GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    if (localPlayer.isAuthenticated)
    {
        /* Perform additional tasks for the authenticated player here */
    }
    else
    {
        /* Perform additional tasks for the non-authenticated player here */
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}

@end
