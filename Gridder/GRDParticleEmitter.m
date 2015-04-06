//
//  GRDParticleEmitter.m
//  gridder
//
//  Created by sithrex on 6/04/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import "GRDParticleEmitter.h"
#import <QuartzCore/QuartzCore.h>

@implementation GRDParticleEmitter {
	CAEmitterLayer* fireEmitter;
}

- (void)awakeFromNib {
	fireEmitter = (CAEmitterLayer*)self.layer;
	
	//configure the emitter layer
	fireEmitter.emitterPosition = CGPointMake(50, 50);
	fireEmitter.emitterSize = CGSizeMake(10, 10);
	fireEmitter.renderMode = kCAEmitterLayerAdditive;

	CAEmitterCell* fire = [CAEmitterCell emitterCell];
	fire.birthRate = 0;
	fire.lifetime = 3.0;
	fire.lifetimeRange = 0.5;
	fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]
				  CGColor];
	fire.contents = (id)[[UIImage imageNamed:@"v3_particle"] CGImage];
	fire.velocity = 10;
	fire.velocityRange = 20;
	fire.emissionRange = M_PI_2;
	fire.scaleSpeed = 0.3;
	fire.spin = 0.5;
	[fire setName:@"fire"];
 
	//add the cell to the layer and we're done
	fireEmitter.emitterCells = [NSArray arrayWithObject:fire];
}


+ (Class) layerClass {
	//configure the UIView to have emitter layer
	return [CAEmitterLayer class];
}

-(void)setEmitterPositionFromTouch: (UITouch*)t {
	//change the emitter's position
	fireEmitter.emitterPosition = [t locationInView:self];
}

- (void)setIsEmitting:(BOOL)isEmitting {
	//turn on/off the emitting of particles
	[fireEmitter setValue:[NSNumber numberWithInt:isEmitting?200:0]
      forKeyPath:@"emitterCells.fire.birthRate"];
}


@end
