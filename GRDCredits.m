//
//  GRDCredits.m
//  Gridder
//
//  Created by Joshua James on 13/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDCredits.h"
#import <QuartzCore/QuartzCore.h>
#import "GRDMenu.h"

@interface GRDCredits ()

@end

@implementation GRDCredits
@synthesize backButton, scrollText;

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

	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"px.png"]];
	scrollText.backgroundColor = [UIColor clearColor];
	[GRDWizard styleButtonAsASquare:backButton];
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

@end
