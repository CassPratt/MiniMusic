//
//  BackButton.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "BackButton.h"

@implementation BackButton

// Return to the MenuScene
- (void)back {
    CCLOG(@"Going to MenuScene");
    CCScene *menu = [CCBReader loadAsScene:@"MenuScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] presentScene:menu withTransition:transition];
}

@end
