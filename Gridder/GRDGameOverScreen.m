//
//  GRDGameOverScreen.m
//  Gridder
//
//  Created by Joshua James on 12/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDGameOverScreen.h"
#import "GRDMenu.h"
#import <QuartzCore/QuartzCore.h>

@interface GRDGameOverScreen ()

@end

@implementation GRDGameOverScreen
@synthesize highScoreLabel, streaksLabel, menuButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
	highScoreLabel.text = [NSString stringWithFormat:@"High Score: %d", [delegate.currentHighScore intValue]];
	streaksLabel.text = [NSString stringWithFormat:@"Longest Streak: %d", delegate.highestStreak];

}

- (void)addHighScore {
	[delegate.top5Scores addObject:delegate.currentHighScore];
	NSSortDescriptor *highestToLowest = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:NO];
	[delegate.top5Scores sortUsingDescriptors:[NSArray arrayWithObject:highestToLowest]];

}

- (void)viewDidLoad {
	[super viewDidLoad];
	delegate = (GRDAppDelegate *)[[UIApplication sharedApplication] delegate];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"inactive.png"]];
	if ([delegate.currentHighScore intValue] > 0) [self addHighScore];
	[GRDWizard styleButtonAsASquare:menuButton];
	int64_t scoreForSubmission = [delegate.currentHighScore longValue];
	
	if (scoreForSubmission > 0) {
		[delegate.menuVC.gameCenterManager reportScore:scoreForSubmission forCategory:delegate.menuVC.currentLeaderBoard];
		if (scoreForSubmission >= 30000) {
			[delegate.menuVC.gameCenterManager submitAchievement:kAchievementGrandMasterGridder percentComplete:100];
			[delegate.menuVC.gameCenterManager submitAchievement:kAchievementSkillz percentComplete:100];
			[delegate.menuVC.gameCenterManager submitAchievement:kAchievement4000Club percentComplete:100];
			[delegate.menuVC.gameCenterManager submitAchievement:kAchievement2000Club percentComplete:100];
		} else if (scoreForSubmission >= 10000) {
			[delegate.menuVC.gameCenterManager submitAchievement:kAchievementSkillz percentComplete:100];
			[delegate.menuVC.gameCenterManager submitAchievement:kAchievement4000Club percentComplete:100];
			[delegate.menuVC.gameCenterManager submitAchievement:kAchievement2000Club percentComplete:100];
		} else if (scoreForSubmission >= 6000) {
			[delegate.menuVC.gameCenterManager submitAchievement:kAchievement4000Club percentComplete:100];
				[delegate.menuVC.gameCenterManager submitAchievement:kAchievement2000Club percentComplete:100];
		} else if (scoreForSubmission >= 4000) {
			[delegate.menuVC.gameCenterManager submitAchievement:kAchievement2000Club percentComplete:100];
		}
	}
	
	if (delegate.highestStreak >= 60) {
		[delegate.menuVC.gameCenterManager submitAchievement:kAchievementMasterStreaker percentComplete:100];
		[delegate.menuVC.gameCenterManager submitAchievement:kAchievementHighStreaker percentComplete:100];
		[delegate.menuVC.gameCenterManager submitAchievement:kAchievementStreaker percentComplete:100];
	} else if (delegate.highestStreak >= 40) {
		[delegate.menuVC.gameCenterManager submitAchievement:kAchievementHighStreaker percentComplete:100];
		[delegate.menuVC.gameCenterManager submitAchievement:kAchievementStreaker percentComplete:100];
	} else if (delegate.highestStreak >= 30) {
		[delegate.menuVC.gameCenterManager submitAchievement:kAchievementStreaker percentComplete:100];

	}

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)pressedReturnToMenu:(id)sender {
	if (delegate.soundIsActive) [delegate.soundPlayer.menuThemePlayer play];
	[self performSegueWithIdentifier:@"returnToMenu" sender:nil];
}
@end
