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
@synthesize isActive;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.isActive = NO;
		self.userInteractionEnabled = YES;
		    }
    return self;
}

- (void)awakeFromNib {
	self.isActive = NO;
	self.userInteractionEnabled = YES;
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
