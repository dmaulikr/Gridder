//
//  GRDAppDelegate.h
//  Gridder
//
//  Created by Joshua James on 10/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRDViewController.h"
#import "GRDMenu.h"
#import "GRDSoundPlayer.h"

@class GRDViewController;
@class GRDMenu;

@interface GRDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSInteger millisecondsFromGridPulse;
@property (nonatomic, assign) NSInteger maxMilliseconds;
@property (nonatomic, strong) NSNumber *currentHighScore;
@property (nonatomic) NSInteger currentStreak;
@property (nonatomic) NSInteger highestStreak;
@property (nonatomic) NSInteger numLives;
@property (strong, nonatomic) NSMutableArray *top5Scores;
@property (nonatomic) BOOL soundIsActive;
@property (nonatomic) BOOL inverseModeActive;
@property (nonatomic) NSInteger difficultyLevel;
@property (nonatomic) NSInteger numRounds;
@property int64_t iceBreaks;

@property (nonatomic, strong) NSTimer *pulseTimer;
@property (nonatomic, strong) GRDViewController *gameVC;
@property (nonatomic, strong) GRDMenu *menuVC;

@property (nonatomic, strong) GRDSoundPlayer *soundPlayer;

@property BOOL gameInProgress;
@property BOOL gameIsCurrentlyPaused;

- (NSString *)saveFilePath;

@end
