//
//  MiniGameScene.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/3/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MiniGameScene.h"
#import "YesNoPopUp.h"
#import "GameData.h"
#import "Language.h"

// only contains the backButton that is shown in all the MiniGames
@implementation MiniGameScene {
    CCButton *_backButton;
    YesNoPopUp *_exitPopUp;
}

// Initializing the Scene with the number of the MiniGame
- (id)init {
    if (self = [super init]) {
        CCLOG(@"MiniGame Scene loaded.");
        _showingExit = FALSE;
    }
    return self;
}

// Checks the PopUp's status
- (void)update:(CCTime)delta {
    if (_exitPopUp.parent != Nil) {
//        [[CCDirector sharedDirector] pause]; <--------- FOR LATER
        _backButton.visible = FALSE;
        _showingExit = TRUE;
    } else {
        _showingExit = FALSE;
        _backButton.visible = TRUE;
    }
}

// showing the exit options
- (void)back {

    _showingExit = TRUE;
    CCLOG(@"Exit Options");
    _exitPopUp = (YesNoPopUp *)[CCBReader load:@"YesNoPopUp"];
    // still need to deal with pauses
    _exitPopUp.positionType = CCPositionTypeNormalized;
    _exitPopUp.position = ccp(0.5, 0.5);
    _exitPopUp.name = @"_exitPopUp";
    if ([Language sharedData].language == 1) {
        [_exitPopUp setLabelText:@"¿Continuar?"];
        [_exitPopUp setTextLeftButton:@"No" rightButton:@"Sí"];
    }
    [self.parent addChild:_exitPopUp];
    _exitPopUp.numberOfGame = _numberOfGame;
    
}

#pragma mark - AT THE END

- (void)dealloc {
    // Clean up memory allocations from sprites
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
}

@end
