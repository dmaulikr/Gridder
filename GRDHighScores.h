//
//  GRDHighScores.h
//  Gridder
//
//  Created by Joshua James on 13/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRDAppDelegate.h"
@interface GRDHighScores : UIViewController {
	GRDAppDelegate *delegate;
}
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel1;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel2;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel3;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel4;
@property (strong, nonatomic) IBOutlet UILabel *highScoreLabel5;

- (IBAction)backPressed:(id)sender;

@end
