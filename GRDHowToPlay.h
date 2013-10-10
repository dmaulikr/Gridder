//
//  GRDHowToPlay.h
//  Gridder
//
//  Created by Joshua James on 13/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRDAppDelegate.h"
#import "GRDGlassSquare.h"

@interface GRDHowToPlay : UIViewController {
	GRDAppDelegate *delegate;

}

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIScrollView *howToScroller;


- (IBAction)backPressed:(id)sender;
@end
