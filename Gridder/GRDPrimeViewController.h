//
//  GRDPrimeViewController.h
//  gridder
//
//  Created by sithrex on 22/03/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YLProgressBar.h>
#import "GRDSquare.h"
#import "GRDWizard.h"

#define LESSERGRID_SQUARE_SIZE 9
#define GREATERGRID_SQUARE_SIZE 4

@interface GRDPrimeViewController : UIViewController <GRDSquareProtocol, GRDWizardProtocol>

// Views
@property (strong, nonatomic) IBOutlet UIView *greaterGrid;
@property (strong, nonatomic) IBOutlet UIView *lesserGrid;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UILabel *livesLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;

// Objects
@property (nonatomic, strong) UIColor *gridColour;
@property (nonatomic, strong) UIColor *gridTransitionColour;

// Timer related
@property (nonatomic, strong) YLProgressBar *progressBar;
@property (nonatomic) NSInteger timeUntilNextPulse;
@property (nonatomic) NSInteger maximumTimeAllowed;
@property (nonatomic, strong) NSTimer *pulseTimer;

@end
