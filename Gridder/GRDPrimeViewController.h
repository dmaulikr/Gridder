//
//  GRDPrimeViewController.h
//  gridder
//
//  Created by sithrex on 22/03/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LESSERGRID_SQUARE_SIZE 9
#define GREATERGRID_SQUARE_SIZE 4

@interface GRDPrimeViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *greaterGrid;
@property (strong, nonatomic) IBOutlet UIView *lesserGrid;
@property (nonatomic, strong) NSMutableArray *lesserGridSquares;
@property (nonatomic, strong) NSMutableArray *greaterGridSquares;

@end
