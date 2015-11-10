//
//  GRDWizard.h
//  gridder
//
//  Created by Joshua James on 1/10/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRDViewController.h"
#import "GRDAppDelegate.h"

typedef enum : int {
	DifficultyLevelEasy = 0,
	DifficultyLevelMedium = 1,
	DifficultyLevelHard = 2
} DifficultyLevel;

@protocol GRDWizardProtocol <NSObject>

- (void)wizardDidAdjustDifficultyLevel:(DifficultyLevel)difficultyLevel;

@end

@class GRDPrimeViewController;

@interface GRDWizard : NSObject

@property (weak, nonatomic) id<GRDWizardProtocol> delegate;

@property (nonatomic, strong) NSMutableArray *lesserGridSquares;
@property (nonatomic, strong) NSMutableArray *greaterGridSquares;
@property (nonatomic, strong) NSMutableArray *activationCandidates;

@property (nonatomic, strong) UIColor *gridColour;
@property (nonatomic, strong) UIColor *gridTransitionColour;

@property (nonatomic) int score;
@property (nonatomic) int rounds;
@property (nonatomic) int lives;
@property (nonatomic) int streak;
@property (nonatomic) int onTheEdgeStreak;
@property (nonatomic) DifficultyLevel difficultyLevel;

// Instance methods
- (void)startNewGame;

// Static methods
+ (GRDWizard *)sharedInstance;
+ (void)gainPoints:(GRDPrimeViewController *)vc;
+ (void)loseALife:(GRDPrimeViewController *)vc;
+ (void)gainALife:(GRDPrimeViewController *)vc;
+ (BOOL)gridComparisonMatches:(NSMutableArray *)greaterGrid compareWith:(NSMutableArray *)lesserGrid;
+ (GRDSquare *)squareForPosition:(NSInteger)pos fromGrid:(NSMutableArray *)grid;
+ (void)populateAdjacentAllSquares:(NSMutableArray *)squares;
+ (void)populateStraightAdjacentSquares:(NSMutableArray *)squares;

/*
+ (void)gainALife:(GRDViewController *)grdVC;
+ (void)loseALife:(GRDViewController *)grdVC;
+ (void)gainStreak:(GRDViewController *)grdVC;
+ (void)gainPoints:(GRDViewController *)grdVC;
+ (void)gainTime:(GRDSquare *)square withGrdVC:(GRDViewController *)grdVC;
+ (void)styleButtonAsASquare:(UIButton *)button;*/


@end
