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

@class GRDViewController;
@interface GRDWizard : NSObject

+ (BOOL)gridComparisonMatches:(NSMutableArray *)greaterGrid compareWith:(NSMutableArray *)lesserGrid;
+ (GRDSquare *)squareForPosition:(NSInteger)pos fromGrid:(NSMutableArray *)grid;
+ (void)gainALife:(GRDViewController *)grdVC;
+ (void)loseALife:(GRDViewController *)grdVC;
+ (void)gainStreak:(GRDViewController *)grdVC;
+ (void)gainPoints:(GRDViewController *)grdVC;
+ (void)gainTime:(GRDSquare *)square withGrdVC:(GRDViewController *)grdVC;
+ (void)styleButtonAsASquare:(UIButton *)button;
+ (void)populateAdjascentSquares:(NSMutableArray *)squares;

@end
