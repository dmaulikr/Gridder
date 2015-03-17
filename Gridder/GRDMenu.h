//
//  GRDMenu.h
//  Gridder
//
//  Created by Joshua James on 12/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRDAppDelegate.h"
#import <GameKit/GameKit.h>
#import "GameCenterManager.h"
#import "AppSpecificValues.h"
#import <MessageUI/MessageUI.h>

@class GRDAppDelegate;
@interface GRDMenu : UIViewController <UIActionSheetDelegate, GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate, MFMailComposeViewControllerDelegate> {
	GameCenterManager *gameCenterManager;
    NSString *currentLeaderBoard;
	GRDAppDelegate *delegate;
}

@property (strong, nonatomic) IBOutlet UIImageView *gridderLogo;
@property (strong, nonatomic) IBOutlet UIButton *goButton;
@property (strong, nonatomic) IBOutlet UIButton *tutorialButton;
@property (strong, nonatomic) IBOutlet UIButton *highScoresButton;
@property (strong, nonatomic) IBOutlet UIButton *creditsButton;
@property (strong, nonatomic) IBOutlet UIButton *soundButton;
@property (strong, nonatomic) IBOutlet UIButton *leaderboardButton;
@property (strong, nonatomic) IBOutlet UIButton *achievementsButton;
@property (strong, nonatomic) IBOutlet UIButton *rateButton;
@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, retain) NSString* currentLeaderBoard;

- (IBAction)emailTouched:(id)sender;
- (IBAction)rateTouched:(id)sender;
- (IBAction)goButtonTouched:(id)sender;
- (IBAction)tutorialButtonTouched:(id)sender;
- (IBAction)highScoresButtonTouched:(id)sender;
- (IBAction)creditsButtonTouched:(id)sender;
- (IBAction)soundTouched:(id)sender;
- (void)styleTheMenuGrid:(NSArray *)menuItems;

- (IBAction) showLeaderboard:(id)sender;
- (IBAction) showAchievements:(id)sender;

@end
