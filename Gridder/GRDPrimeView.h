//
//  GRDPrimeView.h
//  gridder
//
//  Created by Joshua James on 10/11/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRDParticleEmitter.h"
#import "GRDFunctionBox.h"

@interface GRDPrimeView : UIView

@property (strong, nonatomic) IBOutlet GRDParticleEmitter *primeParticleEmitter;
@property (strong, nonatomic) IBOutlet UIView *primeGreaterGrid;
@property (strong, nonatomic) IBOutlet UIView *primeLesserGrid;
@property (strong, nonatomic) IBOutlet UIView *primeFooterView;
@property (strong, nonatomic) IBOutlet UIView *primeTempView;
@property (strong, nonatomic) IBOutlet GRDFunctionBox *primeLifeBox;
@property (strong, nonatomic) IBOutlet GRDFunctionBox *primeScoreBox;
@property (strong, nonatomic) IBOutlet GRDFunctionBox *primePauseBox;
@property (strong, nonatomic) IBOutlet UIImageView *primeLifeBoxIcon;
@property (strong, nonatomic) IBOutlet UIImageView *primeScoreBoxIcon;
@property (strong, nonatomic) IBOutlet UIImageView *primePauseBoxIcon;
@property (strong, nonatomic) IBOutlet UILabel *primeLivesLabel;
@property (strong, nonatomic) IBOutlet UILabel *primeScoreLabel;

@end
