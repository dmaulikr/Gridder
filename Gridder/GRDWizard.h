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

@class GRDViewController;
@interface GRDWizard : NSObject

@property (weak, nonatomic) id<GRDWizardProtocol> delegate;

@property (nonatomic, strong) NSMutableArray *lesserGridSquares;
@property (nonatomic, strong) NSMutableArray *greaterGridSquares;
@property (nonatomic, strong) NSMutableArray *activationCandidates;

@property (nonatomic) int score;
@property (nonatomic) int rounds;
@property (nonatomic) int lives;
@property (nonatomic) int streak;
@property (nonatomic) int onTheEdgeStreak;
@property (nonatomic) DifficultyLevel difficultyLevel;

+ (GRDWizard *)sharedInstance;
- (void)startNewGame;

+ (void)addBlurToView:(UIView *)view;
+ (BOOL)gridComparisonMatches:(NSMutableArray *)greaterGrid compareWith:(NSMutableArray *)lesserGrid;
+ (GRDSquare *)squareForPosition:(NSInteger)pos fromGrid:(NSMutableArray *)grid;
+ (void)gainALife:(GRDViewController *)grdVC;
+ (void)loseALife:(GRDViewController *)grdVC;
+ (void)gainStreak:(GRDViewController *)grdVC;
+ (void)gainPoints:(GRDViewController *)grdVC;
+ (void)gainTime:(GRDSquare *)square withGrdVC:(GRDViewController *)grdVC;
+ (void)styleButtonAsASquare:(UIButton *)button;
+ (void)populateAdjacentAllSquares:(NSMutableArray *)squares;
+ (void)populateStraightAdjacentSquares:(NSMutableArray *)squares;

@end
