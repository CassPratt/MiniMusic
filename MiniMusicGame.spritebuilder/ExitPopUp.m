//
//  ExitPopUp.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ExitPopUp.h"

@implementation ExitPopUp

// Method to return to the MenuScene when you press the backButton
- (void)yesExit {
    CCLOG(@"Going to MenuScene");
    CCScene *menu = [CCBReader loadAsScene:@"MenuScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:menu withTransition:transition];}

// Method to keep on playing
- (void)noExit {
    [self removeFromParentAndCleanup:YES];
}

@end
