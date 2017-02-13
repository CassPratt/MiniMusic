//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//          by Cassandra Pratt Romero on 7/2/14.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "Language.h"
#import "LanguageOptions.h"

#pragma mark - COMPONENTS AND VARIABLES

// First Scene
@implementation MainScene {
    CCButton *_startButton, *_infoButton, *_musicButton;
    NSMutableArray *_buttons;
    int _language;
}

#pragma mark - INITIALIZING

// Initializing the Scene
- (id)init {
    if (self = [super init]) {
        CCLOG(@"MainScene loaded.");
        _language = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"language"];
        [Language sharedData].language = _language;
    }
    return  self;
}

// adding the buttons to an array
- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    [self sceneLanguage];
    
    _buttons = [NSMutableArray array];
    [_buttons addObject:_startButton]; [_buttons addObject:_infoButton];
    [_buttons addObject:_musicButton];
        
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // access audio object
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"playingBG"]) {
        [[OALSimpleAudio sharedInstance] playBgWithLoop:TRUE];
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"playingBG"];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"globalPause"];
}

#pragma mark - MAINSCENE METHODS

// dealing with buttons
- (void)buttonsEnable:(BOOL)enable {
    if (enable) {
        for (int i = 0; i < [_buttons count]; i++) {
            CCButton *thisButton = (CCButton *)[_buttons objectAtIndex:i];
            thisButton.enabled = TRUE;
        }
    } else {
        for (int i = 0; i < [_buttons count]; i++) {
            CCButton *thisButton = (CCButton *)[_buttons objectAtIndex:i];
            thisButton.enabled = FALSE;
        }
    }
}

#pragma mark - PUSHING THE BUTTONS

// Transition to the MenuScene
- (void)start {
    [self buttonsEnable:FALSE];
    
    CCLOG(@"Going to MenuScene");
    CCScene *menuScene = [CCBReader loadAsScene:@"MenuScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.6f];
    [[CCDirector sharedDirector] replaceScene:menuScene withTransition:transition];
}

// Info of the Game
- (void)showInfo {
    [self buttonsEnable:FALSE];
    
    CCLOG(@"Showing Info");
    CCScene *info = [CCBReader loadAsScene:@"GameInfo"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.4f];
    [[CCDirector sharedDirector] replaceScene:info withTransition:transition];
}

// disable music
- (void)configMusic {
    if (![OALSimpleAudio sharedInstance].bgPaused) {
        // no bgMusic
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sinSonido.png"]
                                       forState:CCControlStateNormal];
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sinSonido2.png"]
                                       forState:CCControlStateHighlighted];
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sinSonido2.png"]
                                       forState:CCControlStateDisabled];
        
        [OALSimpleAudio sharedInstance].bgPaused = TRUE;
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"globalPause"];
    } else {
        // no bgMusic
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sonido.png"]
                                       forState:CCControlStateNormal];
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sonido2.png"]
                                       forState:CCControlStateHighlighted];
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sonido2.png"]
                                       forState:CCControlStateDisabled];
        
        [OALSimpleAudio sharedInstance].bgPaused = FALSE;
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"globalPause"];
    }
}

#pragma mark LANGUAGE OPTIONS

// For language
- (void)sceneLanguage {
    NSString *buttonTitle;
    if (_language == 0) {  // ENGLISH
        buttonTitle = [[[Language sharedData].startMenuLang objectAtIndex:0] objectForKey:@"start"];
        [_startButton setTitle:buttonTitle];
    } else {    // SPANISH
        buttonTitle = [[[Language sharedData].startMenuLang objectAtIndex:1] objectForKey:@"comenzar"];
        [_startButton setTitle:buttonTitle];
    }
}

// Cool way to remove exitPopUp
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    LanguageOptions *child = (LanguageOptions*)[self getChildByName:@"_langPopUp" recursively:TRUE];
    if ([self getChildByName:@"_langPopUp" recursively:TRUE] != Nil) {
        CGPoint touchLocation = [touch locationInNode:self];
        if (!CGRectContainsPoint(child.boundingBox, touchLocation)) {
            [child removeFromParentAndCleanup:TRUE];
        }
    }
}

- (void)dealloc {
    // Clean up memory allocations from sprites
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
}

@end
