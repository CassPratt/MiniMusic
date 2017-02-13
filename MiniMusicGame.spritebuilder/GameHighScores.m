//
//  GameHighScores.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/29/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameHighScores.h"
#import "Language.h"

@implementation GameHighScores {
    CCLabelTTF *_pitchScoreLabel, *_dragScoreLabel, *_colorScoreLabel,
                *_pitchLabel, *_tapLabel, *_colorLabel, *_sceneTitle;
}

// Initializing the Scene
- (id)init {
    self = [super init];
    return self;
}

- (void)didLoadFromCCB {
    // getting the high scores of the user
    NSInteger score = [[NSUserDefaults standardUserDefaults] integerForKey:@"pitchHighscore"];
    _pitchScoreLabel.string = [NSString stringWithFormat:@"%i",(int)score];
    
    score = [[NSUserDefaults standardUserDefaults] integerForKey:@"dragHighscore"];
    _dragScoreLabel.string = [NSString stringWithFormat:@"%i",(int)score];
    
    score = [[NSUserDefaults standardUserDefaults] integerForKey:@"randomHighscore"];
    _colorScoreLabel.string = [NSString stringWithFormat:@"%i",(int)score];
    
    [self checkLanguage];
}

// For Language
- (void)checkLanguage {
    if ([Language sharedData].language == 1) {
        _pitchLabel.string = [[[Language sharedData].startMenuLang objectAtIndex:1] objectForKey:@"tono"];
        _tapLabel.string = [[[Language sharedData].startMenuLang objectAtIndex:1] objectForKey:@"leeEscribe"];
        _colorLabel.string = [[[Language sharedData].startMenuLang objectAtIndex:1] objectForKey:@"azar"];
        _sceneTitle.string = @"Máximas Puntuaciones";
    }
}

- (void)hideScores {
    CCLOG(@"Going to MenuScene");
    CCScene *menuScene = [CCBReader loadAsScene:@"MenuScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.4f];
    [[CCDirector sharedDirector] replaceScene:menuScene withTransition:transition];
}

- (void)dealloc {
    // Clean up memory allocations from sprites
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
}

@end
