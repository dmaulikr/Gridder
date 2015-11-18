//
//  GRDFunctionBox.m
//  gridder
//
//  Created by Joshua James on 10/11/2015.
//  Copyright (c) 2015 Joshua James. All rights reserved.
//

#import "GRDFunctionBox.h"
#import "GRDCore.h"

#define ALPHA_LEVEL 0.3

@implementation GRDFunctionBox

- (void)awakeFromNib {
    self.backgroundColor = [GRDCore sharedInstance].gridColour;
    self.backgroundColor = [[GRDCore sharedInstance].gridColour colorWithAlphaComponent:ALPHA_LEVEL];
}

@end
