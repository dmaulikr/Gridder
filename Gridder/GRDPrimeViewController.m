//
//  GRDPrimeViewController.m
//  gridder
//
//  Created by sithrex on 22/03/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import "GRDPrimeViewController.h"
#import "GRDSquare.h"
#import "GRDWizard.h"

@interface GRDPrimeViewController ()

@end

@implementation GRDPrimeViewController

#pragma mark -
#pragma mark VIEW CONTROLLER DELEGATE
#pragma mark -

- (void)viewDidLoad {
	[super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.lesserGrid.backgroundColor = [UIColor clearColor];
	self.greaterGrid.backgroundColor = [UIColor clearColor];
	
	[self.view bringSubviewToFront:self.greaterGrid];
	[self.view bringSubviewToFront:self.lesserGrid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self generateGrids];
}

#pragma mark -
#pragma mark GUI
#pragma mark -

- (void)generateGrids {
	self.greaterGridSquares = [[NSMutableArray alloc] init];
	self.lesserGridSquares = [[NSMutableArray alloc] init];
	
	[self generateGreaterGridWithXOffset:0 withYOffset:0 fromCount:1];
	[self generateLesserGridWithXOffset:0 withYOffset:0 fromCount:1];
	
}

- (void)generateGreaterGridWithXOffset:(NSInteger)xOffset withYOffset:(NSInteger)yOffset fromCount:(NSInteger)count {
	GRDSquare *square = [[[NSBundle mainBundle] loadNibNamed:@"GRDSquare"
													   owner:self
													 options:nil] lastObject];
	
	square.frame = CGRectMake(0 + xOffset, yOffset, (self.greaterGrid.bounds.size.width / GREATERGRID_SQUARE_SIZE) - 15, (self.greaterGrid.bounds.size.width / GREATERGRID_SQUARE_SIZE) - 15);

	square.layer.masksToBounds = NO;
	square.tag = count;
	square.contentScaleFactor = UIViewContentModeScaleAspectFill;
	square.backgroundColor = [UIColor orangeColor];

	square.userInteractionEnabled = YES;
	//[square addTarget:self action:@selector(touchSquare:) forControlEvents:UIControlEventTouchDown];
	
	[self.greaterGrid addSubview:square];
	[self.greaterGridSquares addObject:square];
	if (count % 4 == 0) {
		if(count >= 16) return;
		yOffset += square.bounds.size.height;
		[self generateGreaterGridWithXOffset:0 withYOffset:yOffset + 15 fromCount:count + 1];
		return;
	}
	
	[self generateGreaterGridWithXOffset:(xOffset + self.greaterGrid.bounds.size.width / 4) + 5 withYOffset:yOffset fromCount:count + 1];
}

- (void)generateLesserGridWithXOffset:(NSInteger)xOffset withYOffset:(NSInteger)yOffset fromCount:(NSInteger)count {
	GRDSquare *square = [[[NSBundle mainBundle] loadNibNamed:@"GRDSquare"
													   owner:self
													 options:nil] lastObject];
	
	square.frame = CGRectMake(0 + xOffset, yOffset, (self.lesserGrid.frame.size.width / 4) - 15, (self.lesserGrid.frame.size.width / 4) - 15);
	square.tag = count;
	square.contentScaleFactor = UIViewContentModeScaleAspectFill;
	square.backgroundColor = [UIColor orangeColor];
	
	[self.lesserGrid addSubview:square];
	[self.lesserGridSquares addObject:square];
	
	if (count % 4 == 0) {
		if(count >= 16) return;
		yOffset += square.bounds.size.height;
		[self generateLesserGridWithXOffset:0 withYOffset:yOffset + 15 fromCount:count + 1];
		return;
	}
	
	[self generateLesserGridWithXOffset:xOffset + (self.lesserGrid.frame.size.width / 4) + 5 withYOffset:yOffset fromCount:count + 1];
}

- (BOOL)prefersStatusBarHidden{
	return YES;
}

#pragma mark -
#pragma mark Actions
#pragma mark -

- (IBAction)touchSquare:(id)sender {
	//if (delegate.soundIsActive) [delegate.soundPlayer.squareTouchedSoundPlayer play];
	GRDSquare *touchedSquare = (GRDSquare *)sender;
	
	if(!touchedSquare.isActive) {
		int randomPop = arc4random() % 100;
		if(randomPop >= 0 && randomPop <= 3) {
			[touchedSquare setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"clock-icon.png"]]];
			//delegate.millisecondsFromGridPulse--;
			//[GRDWizard gainTime:touchedSquare withGrdVC:self];
		} else if(randomPop == 100) {
			[touchedSquare setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"heart.png"]]];
			//[GRDWizard gainALife:self];
		} else {
			[touchedSquare setBackgroundColor:[UIColor whiteColor]];
		}
		touchedSquare.isActive = YES;
	} else {
		[touchedSquare setBackgroundColor:[UIColor blueColor]];
		touchedSquare.isActive = NO;
	}
	
	if ([GRDWizard gridComparisonMatches:self.greaterGrid compareWithSuperview2:self.lesserGrid]) {
		//[self gridderPulse:YES];
	}
}



@end
