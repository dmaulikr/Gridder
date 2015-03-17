//
//  GRDAppDelegate.m
//  Gridder
//
//  Created by Joshua James on 10/07/13.
//  Copyright (c) 2013 Joshua James. All rights reserved.
//

#import "GRDAppDelegate.h"

@implementation GRDAppDelegate
@synthesize soundPlayer, millisecondsFromGridPulse, window, top5Scores, gameIsCurrentlyPaused, pulseTimer, maxMilliseconds, gameVC, menuVC, gameInProgress, numRounds, iceBreaks;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	iceBreaks = 0;
	soundPlayer = [[GRDSoundPlayer alloc] init];
	[soundPlayer setupPlayers];
	gameInProgress = NO;
	gameIsCurrentlyPaused = NO;
	millisecondsFromGridPulse = 0;
	self.inverseModeActive = NO;
	self.difficultyLevel = 1;
	self.soundIsActive = YES;
	top5Scores = [[NSMutableArray alloc] init];
	
	[self setupPlayers];
		
	[self loadHighScores];
	
	gameIsCurrentlyPaused = NO;
	numRounds = 0;
	
    return YES;
}

- (void)setupPlayers {
	
}

- (void)loadHighScores {
	NSString *myPath = [self saveFilePath];
	
	BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:myPath];
	
	if (fileExists) {
		top5Scores = [[NSMutableArray alloc] initWithContentsOfFile:myPath];
	}
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
	
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	NSLog(@"App is resigning active...");
	gameIsCurrentlyPaused = YES;
	[soundPlayer.menuThemePlayer stop];
	[soundPlayer.gameThemePlayer stop];
	[pulseTimer invalidate];
	
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSArray *values = [[NSArray alloc] initWithArray:top5Scores];
	
	[values writeToFile:[self saveFilePath] atomically:YES];
}

- (NSString *)saveFilePath {
	NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	
	return [[path objectAtIndex:0] stringByAppendingPathComponent:@"savefile.plist"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	//[self applyGridBGLayerAnimation];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"appWillEnterForeground" object:nil];

}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	//pulseTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"appDidBecomeActive" object:nil];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*-(void)bgScroll {
	UIImage *bgImage = [UIImage imageNamed:@"active.png"];
    UIColor *bgPattern = [UIColor colorWithPatternImage:bgImage];
    gridBGLayer = [CALayer layer];
    gridBGLayer.backgroundColor = bgPattern.CGColor;
	
    gridBGLayer.transform = CATransform3DMakeScale(1, -1, 1);
	
    gridBGLayer.anchorPoint = CGPointMake(0, 1);
	
    CGSize viewSize = window.bounds.size;
    gridBGLayer.frame = CGRectMake(0, 0, bgImage.size.width + viewSize.width, viewSize.height);
	
    [window.layer addSublayer:gridBGLayer];
	
	
    CGPoint startPoint = CGPointZero;
    CGPoint endPoint = CGPointMake(-bgImage.size.width, 0);
    gridBGLayerAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    gridBGLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    gridBGLayerAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    gridBGLayerAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    gridBGLayerAnimation.repeatCount = HUGE_VALF;
    gridBGLayerAnimation.duration = 20.0;
    [self applyGridBGLayerAnimation];
}*/

/*- (void)applyGridBGLayerAnimation {
    [gridBGLayer addAnimation:gridBGLayerAnimation forKey:@"position"];
}*/

@end
