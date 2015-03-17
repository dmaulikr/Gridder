//
//  GRDGlassSquare.m
//  gridder
//
//  Created by Joshua James on 5/10/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDGlassSquare.h"

@implementation GRDGlassSquare

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.userInteractionEnabled = YES;
		self.timesTouched = 0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
