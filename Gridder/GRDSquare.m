//
//  GRDSquare.m
//  Gridder
//
//  Created by Joshua James on 10/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDSquare.h"
#import "GRDViewController.h"
#import "GRDSoundPlayer.h"

@interface GRDSquare ()

@property (nonatomic, strong) AVAudioPlayer *activationSound;

@end

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
	[super awakeFromNib];
	self.userInteractionEnabled = YES;
	
	self.activationSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"pop" ofType:@"wav"]] error:nil];
	[self.activationSound setVolume:0.03f];
	
	
}

- (BOOL)getIsActive {
	return self.isActive;
}

- (void)setIsActive:(BOOL)isActive {
	
	_isActive = isActive;
	if (isActive) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.1];
		
		self.alpha = 1.0f;
		
		[UIView commitAnimations];

		if (self.isGreaterSquare) {
			[self.activationSound prepareToPlay];
			[self.activationSound play];
		}
	} else {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.1];
		
		self.alpha = 0.3f;
		
		[UIView commitAnimations];
	}
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.delegate squareDidBeginTouching:touches withEvent:event];
	[super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	id<GRDSquareProtocol> strongDelegate = self.delegate;
	
	if ([strongDelegate respondsToSelector:@selector(squareDidTouchesMove:withEvent:)]) {
		[strongDelegate squareDidTouchesMove:touches withEvent:event];
	}
	
	[super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self.delegate squareDidEndTouching:touches withEvent:event];
	
	[super touchesEnded:touches withEvent:event];
}

@end
