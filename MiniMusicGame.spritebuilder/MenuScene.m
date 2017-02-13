//
//  MenuScene.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MenuScene.h"
#import "GameData.h"
#import "MiniGameScene.h"
#import "PitchGame.h"
#import "RandomGame.h"
#import "ReadWriteGame.h"
#import "NoteNameBubble.h"
#import "YesNoPopUp.h"
#import "AppDelegate.h"
#import "LanguageOptions.h"
#import "Language.h"

// From here you go to the MiniGames

#pragma mark - COMPONENTS AND VARIABLES

@implementation MenuScene {
    CCSprite *_bubbleCoin; CCLabelTTF *_chooseLabel;
    CCButton *_pitchButton, *_randomButton, *_readWriteButton,
                *_scoresButton, *_storeButton, *_configButton,
                *_musicButton;
    NSMutableArray *_buttons;
}

#pragma mark - INITIALIZING

// Initializing the Scene
- (id)init {
    if (self = [super init]) {
        CCLOG(@"MenuScene loaded.");
        _buttonsEnabled = TRUE;
    }
    return  self;
}

// adding the buttons to an array
- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    _buttons = [NSMutableArray array];
    [_buttons addObject:_pitchButton]; [_buttons addObject:_randomButton];
    [_buttons addObject:_readWriteButton]; [_buttons addObject:_scoresButton];
    [_buttons addObject:_storeButton]; [_buttons addObject:_configButton];
    [_buttons addObject:_musicButton];
    
    // Starting again the levels and score
    [GameData sharedData].level = 0;
    [GameData sharedData].score = 0;
    [GameData sharedData].wasSuccessful = FALSE;
    
    [self menuLanguage];    // LANGUAGE
    // Observer for Language
    [[Language sharedData] addObserver:self forKeyPath:@"language" options:0 context:NULL];
    
    BOOL global = [[NSUserDefaults standardUserDefaults] boolForKey:@"globalPause"];
    
    if (global) {
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sinSonido.png"]
                                       forState:CCControlStateNormal];
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sinSonido2.png"]
                                       forState:CCControlStateHighlighted];
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sinSonido2.png"]
                                       forState:CCControlStateDisabled];
    } else {
        [OALSimpleAudio sharedInstance].bgPaused = FALSE;
    }
    
    // checking unlocks
    [self checkRWLocked];
}

#pragma mark - MENUSCENE METHODS

// For language observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"language"])
        [self menuLanguage];
}

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

// showing scores
- (void)showScores {
    [self buttonsEnable:FALSE];
    
    CCLOG(@"Showing scores");
    CCScene *scores = [CCBReader loadAsScene:@"GameHighScores"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.4f];
    [[CCDirector sharedDirector] replaceScene:scores withTransition:transition];
}

// Transition to the ReadWrite MiniGame
- (void)showStore {
    [self buttonsEnable:FALSE];
    
    CCLOG(@"Going to Store");
    CCScene *store = [CCBReader loadAsScene:@"StoreScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
    [[CCDirector sharedDirector] replaceScene:store withTransition:transition];
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
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sinSonido2.png"]
                                      forState:CCControlStateSelected];
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
        [_musicButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"GameButtons/sonido2.png"]
                                      forState:CCControlStateSelected];
        [OALSimpleAudio sharedInstance].bgPaused = FALSE;
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"globalPause"];
    }
}

- (void)checkRWLocked {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"rwUnlocked"] == Nil) {
        _bubbleCoin.visible = TRUE;
        _readWriteButton.enabled = FALSE;
    } else {
        _readWriteButton.enabled = TRUE;
        _bubbleCoin.visible = FALSE;
    }
}

- (void)dealloc {
    // Clean up memory allocations from sprites
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    [[Language sharedData] removeObserver:self forKeyPath:@"language" context:NULL];
}

#pragma mark - PUSHING THE MINIGAME'S BUTTONS

// Transition to the Pitch MiniGame
- (void)pitchMG {
    [self buttonsEnable:FALSE];
//    [[OALSimpleAudio sharedInstance] playEffect:@"Audio/press_button.wav"];
    
    CCLOG(@"Going to Pitch MiniGame");
    CCScene *pitch = [CCBReader loadAsScene:@"PitchGame"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.6f];
    [[CCDirector sharedDirector] replaceScene:pitch withTransition:transition];
}

// Transition to the Random MiniGame
- (void)randomMG {
    [self buttonsEnable:FALSE];
//    [[OALSimpleAudio sharedInstance] playEffect:@"Audio/press_button.wav"];
    
    CCLOG(@"Going to Random MiniGame");
    CCScene *randomGame = [CCBReader loadAsScene:@"RandomGame"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.6f];
    [[CCDirector sharedDirector] replaceScene:randomGame withTransition:transition];
}

// Transition to the ReadWrite MiniGame
- (void)readWriteMG {
    [self buttonsEnable:FALSE];
//    [[OALSimpleAudio sharedInstance] playEffect:@"Audio/press_button.wav"];
    
    YesNoPopUp *levelSelection = (YesNoPopUp *)[CCBReader load:@"YesNoPopUp"];
    // still need to deal with pauses
    levelSelection.positionType = CCPositionTypeNormalized;
    levelSelection.position = ccp(0.5, 0.5);
    levelSelection.name = @"_exitPopUp";
    levelSelection.numberOfGame = 20;
    int lang = [Language sharedData].language;
    if (lang == 0) {
        [levelSelection setLabelText:@"Choose your level:"];
        [levelSelection setTextLeftButton:@"Beginner" rightButton:@"Advanced"];
    } else {
        [levelSelection setLabelText:@"Elige tu nivel:"];
        [levelSelection setTextLeftButton:@"Principiante" rightButton:@"Avanzado"];
    }
    [self addChild:levelSelection];
}

#pragma mark UPDATE FOR POPUP

// revisando PopUp
- (void)update:(CCTime)delta {
    if (![self getChildByName:@"_exitPopUp" recursively:TRUE] && ![self getChildByName:@"_langPopUp" recursively:TRUE])
        [self buttonsEnable:TRUE];
    [self checkRWLocked];
}

// Cool way to remove exitPopUp
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    CCNode *child;
    CGPoint touchLocation = [touch locationInNode:self];
    // For levels in RWGame
    child = [self getChildByName:@"_exitPopUp" recursively:TRUE];
    if (child != Nil) {
        if (!CGRectContainsPoint(child.boundingBox, touchLocation)) {
            [child removeFromParentAndCleanup:TRUE];
        }
    }
    // For LanguageOptions
    child = [self getChildByName:@"_langPopUp" recursively:TRUE];
    if ([self getChildByName:@"_langPopUp" recursively:TRUE] != Nil) {
        if (!CGRectContainsPoint(child.boundingBox, touchLocation)) {
            [child removeFromParentAndCleanup:TRUE];
        }
    }
}

// Showing language options
- (void)languageOptions {
    [self buttonsEnable:FALSE];
    
    LanguageOptions *langOption = (LanguageOptions *)[CCBReader load:@"LanguageOptions"];
    // still need to deal with pauses
    langOption.positionType = CCPositionTypeNormalized;
    langOption.position = ccp(0.5, 0.5);
    langOption.name = @"_langPopUp";
    [self addChild:langOption];
    
}

// Setting language
- (void)menuLanguage {
    int chosenLang = [Language sharedData].language;
    NSDictionary *dictLan = [[Language sharedData].startMenuLang objectAtIndex:chosenLang];
    if (chosenLang == 0) {
        [_chooseLabel setString:[dictLan objectForKey:@"chooseGame"]];
        [_pitchButton setTitle:[dictLan objectForKey:@"pitch"]];
        [_readWriteButton setTitle:[dictLan objectForKey:@"readWrite"]];
        [_randomButton setTitle:[dictLan objectForKey:@"random"]];
    } else {
        [_chooseLabel setString:[dictLan objectForKey:@"eligeJuego"]];
        [_pitchButton setTitle:[dictLan objectForKey:@"tono"]];
        [_readWriteButton setTitle:[dictLan objectForKey:@"leeEscribe"]];
        [_randomButton setTitle:[dictLan objectForKey:@"azar"]];
    }
}

@end
