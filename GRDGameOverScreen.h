//
//  GRDGameOverScreen.h
//  Gridder
//
//  Created by Joshua James on 12/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRDAppDelegate.h"

@interface GRDGameOverScreen : UIViewController {
	GRDAppDelegate *delegate;
}

@property (strong, nonatomic) IBOutlet UIButton *menuButton;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *streaksLabel;

- (IBAction)pressedReturnToMenu:(id)sender;

@end
