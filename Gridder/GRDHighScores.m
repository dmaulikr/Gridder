//
//  GRDHighScores.m
//  Gridder
//
//  Created by Joshua James on 13/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDHighScores.h"
#import <QuartzCore/QuartzCore.h>
#import "GRDMenu.h"
/*
@interface GRDHighScores ()

@end

@implementation GRDHighScores
@synthesize backButton, highScoreLabel1, highScoreLabel2, highScoreLabel3, highScoreLabel4,highScoreLabel5;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	delegate = (GRDAppDelegate *)[[UIApplication sharedApplication] delegate];
	// Do any additional setup after loading the view.
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"inactive.png"]];

	[GRDWizard styleButtonAsASquare:backButton];

	NSLog(@"trying to add scores into list");
	for (int i = 0; i < [delegate.top5Scores count]; i++) {
		NSLog(@"rotation %d", i);
		NSNumber *score = [delegate.top5Scores objectAtIndex:i];
		if (i == 0) {
			highScoreLabel1.text = [NSString stringWithFormat:@"%d", [score intValue]];
		} else if (i == 1) {
			highScoreLabel2.text = [NSString stringWithFormat:@"%d", [score intValue]];
		} else if (i == 2) {
			highScoreLabel3.text = [NSString stringWithFormat:@"%d", [score intValue]];
		} else if (i == 3) {
			highScoreLabel4.text = [NSString stringWithFormat:@"%d", [score intValue]];
		} else if (i == 4) {
			highScoreLabel5.text = [NSString stringWithFormat:@"%d", [score intValue]];
		}
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {
	if(delegate.soundIsActive) [delegate.soundPlayer.menuBlipSoundPlayer play];
	[self performSegueWithIdentifier:@"returnToMenu" sender:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
	return UIStatusBarStyleLightContent;
}


@end*/
