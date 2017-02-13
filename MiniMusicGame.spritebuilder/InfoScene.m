//
//  InfoScene.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/30/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "InfoScene.h"

@implementation InfoScene

- (void)hideInfo {
    CCLOG(@"Going to MainScene");
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.4f];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:transition];
}

- (void)dealloc {
    // Clean up memory allocations from sprites
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
}

@end
