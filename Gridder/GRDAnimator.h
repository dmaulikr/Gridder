//
//  GRDAnimator.h
//  gridder
//
//  Created by sithrex on 6/04/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GRDPrimeViewController.h"

@interface GRDAnimator : NSObject

+ (void)animateMatch;
+ (void)animatePulse:(UIView *)transitionFader;
+ (void)animatePointsGained:(GRDPrimeViewController *)vc;

@end
