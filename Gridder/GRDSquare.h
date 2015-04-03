//
//  GRDSquare.h
//  Gridder
//
//  Created by Joshua James on 10/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GRDSquareProtocol <NSObject>

@optional - (void)squareDidBeginTouching:(NSSet *)touches withEvent:(UIEvent *)event;
@optional - (void)squareDidEndTouching:(NSSet *)touches withEvent:(UIEvent *)event;
@optional - (void)squareDidTouchesMove:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface GRDSquare : UIButton

@property (nonatomic) BOOL isGreaterSquare;
@property (nonatomic) BOOL isActive;
@property (weak, nonatomic) id<GRDSquareProtocol> delegate;
@property BOOL isBeingTouchDragged;
@property (nonatomic, strong) NSMutableArray *adjacentAllSquares;
@property (nonatomic, strong) NSMutableArray *adjacentStraightSquares;

@end
