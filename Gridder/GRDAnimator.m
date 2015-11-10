//
//  GRDAnimator.m
//  gridder
//
//  Created by sithrex on 6/04/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import "GRDAnimator.h"
#import "GRDCore.h"
#import "GRDSquare.h"

@implementation GRDAnimator

+ (void)animateBox:(UIView *)boxToWiggle {
    [UIView animateWithDuration:0.2f animations:^{
        boxToWiggle.transform = CGAffineTransformMakeRotation(-270);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f animations:^{
            boxToWiggle.transform = CGAffineTransformMakeRotation(270);
        } completion:^(BOOL finished) {
            boxToWiggle.transform = CGAffineTransformMakeRotation(0);
            
        }];
    }];
}

+ (void)animateMatch {
	for (GRDSquare *greaterSquare in [GRDCore sharedInstance].greaterGridSquares) {
		if (greaterSquare.isActive) {
			[UIView animateWithDuration:0.2
								  delay:0.0
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^{
								 greaterSquare.backgroundColor = [GRDCore sharedInstance].gridTransitionColour;
							 }
							 completion:^(BOOL finished){
								 [UIView animateWithDuration:0.2
													   delay:0.0
													 options: UIViewAnimationOptionCurveEaseIn
												  animations:^{
													  greaterSquare.backgroundColor = [GRDCore sharedInstance].gridColour;
												  }
												  completion:^(BOOL finished) {
													  
												  }];
							 }];
		} else {
			[UIView animateWithDuration:0.2
								  delay:0.0
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^{
								 greaterSquare.alpha = 0.1f;
							 }
							 completion:^(BOOL finished){
								 [UIView animateWithDuration:0.2
													   delay:0.0
													 options: UIViewAnimationOptionCurveEaseIn
												  animations:^{
													  greaterSquare.alpha = 0.3f;
												  }
												  completion:^(BOOL finished) {
													  
												  }];
							 }];
		}
	}
	
	for (GRDSquare *lesserSquare in [GRDCore sharedInstance].lesserGridSquares) {
		if (lesserSquare.isActive) {
			[UIView animateWithDuration:0.2
								  delay:0.0
								options: UIViewAnimationOptionCurveEaseIn
							 animations:^{
								 lesserSquare.backgroundColor = [GRDCore sharedInstance].gridTransitionColour;
							 }
							 completion:^(BOOL finished) {
								 [UIView animateWithDuration:0.2
													   delay:0.0
													 options: UIViewAnimationOptionCurveEaseIn
												  animations:^{
													  lesserSquare.backgroundColor = [GRDCore sharedInstance].gridColour;
												  }
												  completion:^(BOOL finished) {
												  }];
							 }];
		} else {
			[UIView animateWithDuration:0.2
								  delay:0.0
								options:UIViewAnimationOptionCurveEaseIn
							 animations:^{
								 lesserSquare.alpha = 0.1f;
							 }
							 completion:^(BOOL finished){
								 [UIView animateWithDuration:0.2
													   delay:0.0
													 options: UIViewAnimationOptionCurveEaseIn
												  animations:^{
													  lesserSquare.alpha = 0.3f;
												  }
												  completion:^(BOOL finished) {
													  
												  }];
							 }];
		}
		
	}
}

+ (void)animatePulse:(UIView *)transitionFader {
	transitionFader.backgroundColor = [UIColor redColor];
	transitionFader.hidden = NO;
	[UIView animateWithDuration:0.2
						  delay:0.0
						options:0
					 animations:^{
						 transitionFader.alpha = 1.0f;
					 } completion:^(BOOL finished) {
						 transitionFader.hidden = YES;
						 transitionFader.alpha = 0;
					 }
	 ];
}

+ (void)animatePointsGained:(GRDPrimeViewController *)vc {
	[UIView beginAnimations:@"ScrollPointsGainedAnimation" context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 1.5];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	vc.scoreGainedFader.frame = CGRectMake(vc.scoreGainedFader.frame.origin.x, vc.scoreGainedFader.frame.origin.y - 100, vc.scoreGainedFader.frame.size.width, vc.scoreGainedFader.frame.size.height);
	[UIView commitAnimations];
	
	[UIView animateWithDuration:1.5 animations:^{ vc.scoreGainedFader.alpha = 0.0f;} completion:^(BOOL finished) {
		vc.scoreGainedFader.frame = vc.scoreFaderFrame;
	}];
}

+ (void)animateLifeFade:(GRDPrimeViewController *)vc {
	vc.lifeFader.alpha = 1.0f;
	
	[UIView beginAnimations:@"ScrollLifeAnimation" context:nil];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDuration: 1.5];
	[UIView setAnimationCurve: UIViewAnimationCurveLinear];
	vc.lifeFader.frame = CGRectMake(vc.lifeFader.frame.origin.x, vc.lifeFader.frame.origin.y - 100, vc.lifeFader.frame.size.width, vc.lifeFader.frame.size.height);
	[UIView commitAnimations];
	
	[UIView animateWithDuration:1.5 animations:^{ vc.lifeFader.alpha = 0.0f; } completion:^(BOOL finished) {
		vc.lifeFader.frame = vc.lifeFaderFrame;
	}];
	
}


@end
