//
//  GRDCredits.h
//  Gridder
//
//  Created by Joshua James on 13/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GRDAppDelegate.h"

@interface GRDCredits : UIViewController {
	GRDAppDelegate *delegate;
}

@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UITextView *scrollText;

- (IBAction)backPressed:(id)sender;

@end
