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
#import "GRDCore.h"
#import "GRDPrimeView.h"

#define GREATERGRID_SQUARE_OFFSET_TO_DIVIDE_BY 4
#define GREATERGRID_GAP_SIZE 2
#define LESSERGRID_SQUARE_OFFSET_TO_DIVIDE_BY 4
#define LESSERGRID_GAP_SIZE 2

@interface GRDPrimeViewController : UIViewController <GRDSquareProtocol, GRDWizardProtocol>

// Views
@property (strong, nonatomic) IBOutlet GRDPrimeView *primeView;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIView *transitionFader;
@property (nonatomic, strong) UILabel *scoreGainedFader;
@property (nonatomic, strong) UILabel *lifeFader;

// Misc
@property (nonatomic) CGRect scoreFaderFrame;
@property (nonatomic) CGRect lifeFaderFrame;

// Timer related
@property (nonatomic, strong) YLProgressBar *progressBar;
@property (nonatomic) NSInteger timeElapsed;
@property (nonatomic) NSInteger maximumTimeAllowed;
@property (nonatomic, strong) NSTimer *pulseTimer;

// Methods
- (void)randomiseLesserGrid;

@end
