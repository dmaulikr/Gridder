//
//  GRDPrimeViewController.m
//  gridder
//
//  Created by sithrex on 22/03/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import "GRDPrimeViewController.h"
#import "GRDSquare.h"

@interface GRDPrimeViewController ()

@end

@implementation GRDPrimeViewController

#pragma mark -
#pragma mark VIEW CONTROLLER DELEGATE
#pragma mark -

- (void)viewDidLoad {
	[super viewDidLoad];
	//[self performSelector:@selector(generateGrids) withObject:nil afterDelay:1.0];
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
	
	//self.greaterGrid.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
	//self.lesserGrid.frame = CGRectMake(0, 0, (self.view.bounds.size.width / LESSERGRID_SQUARE_SIZE) * 4, (self.view.bounds.size.width / LESSERGRID_SQUARE_SIZE) * 4);
	
	[self generateGreaterGridWithXOffset:0 withYOffset:0 fromCount:1];
	[self generateLesserGridWithXOffset:0 withYOffset:0 fromCount:1];
}

- (void)generateGreaterGridWithXOffset:(NSInteger)xOffset withYOffset:(NSInteger)yOffset fromCount:(NSInteger)count {
	GRDSquare *square = [[[NSBundle mainBundle] loadNibNamed:@"GRDSquare"
													   owner:self
													 options:nil] lastObject];
	
	square.frame = CGRectMake(0 + xOffset, yOffset, self.greaterGrid.bounds.size.width / GREATERGRID_SQUARE_SIZE, self.greaterGrid.bounds.size.width / GREATERGRID_SQUARE_SIZE);
	square.layer.shadowColor = (__bridge CGColorRef)([UIColor blueColor]);
	square.layer.shadowRadius = 20.0f;
	square.layer.shadowOpacity = .9;
	square.layer.shadowOffset = CGSizeZero;
	square.layer.masksToBounds = NO;
	square.tag = count;
	square.layer.cornerRadius = 5;
	square.backgroundColor = [UIColor blueColor];
	square.layer.borderColor = [UIColor blackColor].CGColor;
	square.layer.borderWidth = 3.0;
	square.userInteractionEnabled = YES;
	[square addTarget:self action:@selector(touchSquare:) forControlEvents:UIControlEventTouchDown];
	
	[self.greaterGrid addSubview:square];
	[self.greaterGridSquares addObject:square];
	
	if (count % 4 == 0) {
		if(count >= 16) return;
		yOffset += square.bounds.size.height;
		[self generateGreaterGridWithXOffset:0 withYOffset:yOffset fromCount:count + 1];
		return;
	}
	
	[self generateGreaterGridWithXOffset:xOffset + self.greaterGrid.bounds.size.width / 4 withYOffset:yOffset fromCount:count + 1];
}

- (void)generateLesserGridWithXOffset:(NSInteger)xOffset withYOffset:(NSInteger)yOffset fromCount:(NSInteger)count {
	GRDSquare *square = [[[NSBundle mainBundle] loadNibNamed:@"GRDSquare"
													   owner:self
													 options:nil] lastObject];
	
	square.frame = CGRectMake(0 + xOffset, yOffset, self.lesserGrid.frame.size.width / 4, self.lesserGrid.frame.size.width / 4);
	square.layer.shadowColor = (__bridge CGColorRef)([UIColor blueColor]);
	square.layer.shadowRadius = 20.0f;
	square.layer.shadowOpacity = .9;
	square.layer.shadowOffset = CGSizeZero;
	square.tag = count;
	square.layer.cornerRadius = 5;
	square.backgroundColor = [UIColor blueColor];
	square.layer.borderColor = [UIColor blackColor].CGColor;
	square.layer.borderWidth = 2.0;
	
	[self.lesserGrid addSubview:square];
	[self.lesserGridSquares addObject:square];
	
	if (count % 4 == 0) {
		if(count >= 16) return;
		yOffset += square.bounds.size.height;
		[self generateLesserGridWithXOffset:0 withYOffset:yOffset fromCount:count + 1];
		return;
	}
	
	[self generateLesserGridWithXOffset:xOffset + self.lesserGrid.frame.size.width / 4 withYOffset:yOffset fromCount:count + 1];
}

- (BOOL)prefersStatusBarHidden{
	return YES;
}


@end
