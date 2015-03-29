//
//  GRDSquare.m
//  Gridder
//
//  Created by Joshua James on 10/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDSquare.h"
#import "GRDViewController.h"

@implementation GRDSquare
@synthesize isActive = _isActive;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		
		self.userInteractionEnabled = YES;
	}
    return self;
}

- (void)awakeFromNib {
	self.userInteractionEnabled = YES;
}

- (BOOL)getIsActive {
	return self.isActive;
}

- (void)setIsActive:(BOOL)isActive {
	_isActive = isActive;
	if (isActive) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		
		self.alpha = 1.0f;
		
		[UIView commitAnimations];
	} else {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.2];
		
		self.alpha = 0.3f;
		
		[UIView commitAnimations];
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.delegate squareDidBeginTouching:touches withEvent:event];

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	id<GRDSquareProtocol> strongDelegate = self.delegate;
	
	if ([strongDelegate respondsToSelector:@selector(squareDidTouchesMove:withEvent:)]) {
		[strongDelegate squareDidTouchesMove:touches withEvent:event];
	}
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.delegate squareDidEndTouching:touches withEvent:event];
}

@end
