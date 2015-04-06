//
//  GRDParticleEmitter.h
//  gridder
//
//  Created by sithrex on 6/04/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GRDParticleEmitter : UIView

- (void)setEmitterPositionFromTouch:(UITouch *)t;
- (void)setIsEmitting:(BOOL)isEmitting;

@end
