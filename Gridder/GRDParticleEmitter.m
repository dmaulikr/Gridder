//
//  GRDParticleEmitter.m
//  gridder
//
//  Created by sithrex on 6/04/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import "GRDParticleEmitter.h"
#import <QuartzCore/QuartzCore.h>

@implementation GRDParticleEmitter

- (void)awakeFromNib {
	self.fireEmitter = [[CAEmitterLayer alloc] init];
	
	[self.layer addSublayer:self.fireEmitter];
	//(CAEmitterLayer *)self.layer;
	
	//configure the emitter layer
	self.fireEmitter.emitterPosition = CGPointMake(50, 50);
	self.fireEmitter.emitterSize = CGSizeMake(10, 10);
	self.fireEmitter.renderMode = kCAEmitterLayerAdditive;

	[self bringSublayerToFront:self.fireEmitter];
	
	CAEmitterCell* fire = [CAEmitterCell emitterCell];
	fire.birthRate = 0;
	fire.lifetime = 0.2;
	fire.lifetimeRange = 0.5;
	fire.color = [[UIColor colorWithRed:0.4 green:0.4 blue:0.9 alpha:1.0]
				  CGColor];
	fire.contents = (id)[[UIImage imageNamed:@"slice"] CGImage];
	fire.velocity = 10;
	fire.velocityRange = 20;
	fire.emissionRange = M_PI_2;
	fire.scaleSpeed = 0.2;
	fire.spin = 0.1;
	[fire setName:@"fire"];
 
	//add the cell to the layer and we're done
	self.fireEmitter.emitterCells = [NSArray arrayWithObject:fire];
}

- (void)bringSublayerToFront:(CALayer *)layer {
	[layer removeFromSuperlayer];
	[layer.superlayer insertSublayer:layer atIndex:[layer.superlayer.sublayers count]];
}

+ (Class) layerClass {
	//configure the UIView to have emitter layer
	return [CAEmitterLayer class];
}

- (void)setEmitterPositionFromTouch:(UITouch *)t {
	//change the emitter's position
	self.fireEmitter.emitterPosition = [t locationInView:self];
}

- (void)setIsEmitting:(BOOL)isEmitting {
	//turn on/off the emitting of particles
	[self.fireEmitter setValue:[NSNumber numberWithInt:isEmitting?200:0]
      forKeyPath:@"emitterCells.fire.birthRate"];
}


@end
