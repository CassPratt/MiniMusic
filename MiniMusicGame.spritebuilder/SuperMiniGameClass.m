//
//  SuperMiniGameClass.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperMiniGameClass.h"
#import "GameData.h"
#import "SuperPopUp.h"
#import "InstructionsPopUp.h"
#import "PitchScorePopUp.h"
#import "Language.h"

@implementation SuperMiniGameClass {
    CCNode *_OnTop;
    int _language;
}

// Initializing the Class
- (id)init {
    self = [super init];
    _level = -1;
    _score = 0;
    _showingInstPopUp = TRUE;
    _showingScore = FALSE;
    _started = TRUE;
    _gamePaused = FALSE;
    _language = [Language sharedData].language;
    return self;
}

// at the beginning
- (void)onEnter {    // tell this scene to accept touches
    [super onEnter];
    self.userInteractionEnabled = TRUE;
}

// we want the MiniGame Scene being always on top of the others
- (void)miniGameSceneOnTop {
    _OnTop = [self getChildByName:@"_miniScene" recursively:TRUE];
    [self removeChild:_OnTop];
    [self addChild:_OnTop];
}

// the Instructions PopUp follows the MiniGame Scene
- (void)instructionsPopUpGoingUp {
    _OnTop = [self getChildByName:@"_instPopUp" recursively:TRUE];
    [self removeChild:_OnTop];
    [self addChild:_OnTop];
}

// shows the InstructionsPopUp with the instructions for a certain MiniGame
// only the RandomGame uses an special method for the instructions
- (void)showingInstructions:(NSString*)instructions NumberOfGame:(int)game {
    // initializing the InstructionsPopUp
    SuperPopUp *_instPopUp = (SuperPopUp *)[CCBReader load:@"InstructionsPopUp"];
    _instPopUp.positionType = CCPositionTypeNormalized;
    _instPopUp.position = ccp(0.5, 0.5);
    _instPopUp.name = @"_instPopUp";
    _instPopUp.numberOfGame = 10;
    [_instPopUp setLabelText:instructions];
    [self addChild:_instPopUp];
}

// showing the ScorePopUp
- (void)showingScore:(int)typeOfPopUp withText:(NSString*)labelText actualLevel:(int)level userSuccess:(BOOL)success andCurrentScore:(int)score {
    
    // let's update the level of the game (the correct game) in the GameData
    [GameData sharedData].wasSuccessful = success;
    if (success) { // the user advanced in the level
        [GameData sharedData].level++;
        if (typeOfPopUp != 1) {
            [[OALSimpleAudio sharedInstance] playEffect:@"Audio/successful.wav"];
        }
        // updating score
        [GameData sharedData].score = score;
        
    } else { // no score
        if (typeOfPopUp == 0) {
            int scoreNow = [GameData sharedData].score - 10;
            if (scoreNow > 0) {
                [GameData sharedData].score = scoreNow;
            } else {
                [GameData sharedData].score = 0;
            }
            
        } else if (typeOfPopUp != 2) {
            [GameData sharedData].score = 0;
        }
        
        if (typeOfPopUp == 1) {
            [GameData sharedData].level = 0;
        }
        
        if (typeOfPopUp != 1){
            [[OALSimpleAudio sharedInstance] playEffect:@"Audio/failure.wav"];
        }
    }
    
    // now let's check the score
    [self setHighscoreWithScore:score andType:typeOfPopUp inString:labelText withSuccess:success];
    
        // initializing a PopUp
    SuperPopUp *_superPopUp = (SuperPopUp *)[CCBReader load:@"InstructionsPopUp"];
    
    if (typeOfPopUp == 2 && level == 14 && success && [GameData sharedData].rwLevel == 0) {
        if (_language == 0) // ENGLISH
            labelText = [NSString stringWithFormat:@"%@\r%@", @"You're ready!",@"Go to Advanced"];
        else // SPANISH
            labelText = [NSString stringWithFormat:@"%@\r%@", @"¡Estás listo!",@"Eres Avanzado"];
        
        CCLOG(@"Going to MenuScene");
        _superPopUp.level = level;
    }

    // position
    _superPopUp.positionType = CCPositionTypeNormalized;
    _superPopUp.position = ccp(0.5, 0.5);
    [_superPopUp setLabelText:labelText];
    // info for the MiniGame
    _superPopUp.numberOfGame = typeOfPopUp;
    _superPopUp.name = @"score";
    // adding the PopUp
    [self addChild:_superPopUp];
    if (_numberOfGame == 2) {
        NSString *totalNotes = [NSString stringWithFormat:@"%i", _totalNotes];
        NSString *correctNotes = [NSString stringWithFormat:@"%i", _userNotes];
        [_superPopUp setTotalNotes:totalNotes andCorrectNotes:correctNotes];
    }
    if (_level > 0) {
        [self setButtonContinueTitle:success inPopUp:_superPopUp];
    }
    
//    // pausing the game <------------------------ FOR LATER
//    [[CCDirector sharedDirector] pause];
}

// Method to set the Highscores
- (void)setHighscoreWithScore:(int)score andType:(int)typeOfPopUp inString:(NSString*)labelText withSuccess:(BOOL)success{
    if (typeOfPopUp != 10) {
        int highScore = 0;
        NSString *nameOfGame;
        switch (typeOfPopUp) {
            case 0: // Pitch Game
                highScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"pitchHighscore"];
                nameOfGame = @"pitchHighscore";
                break;
            case 1:
                highScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"randomHighscore"];
                nameOfGame = @"randomHighscore";
                break;
            case 2:
                highScore = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"dragHighscore"];
                nameOfGame = @"dragHighscore";
            default:
                break;
        }
        
        if (score > highScore) {
            if (typeOfPopUp != 0 || (typeOfPopUp == 0 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"maxReached"])) {
                [[NSUserDefaults standardUserDefaults] setInteger:score forKey:nameOfGame];
                [self setLabelString:labelText withType:typeOfPopUp andSuccess:success];
            }
        }
    }
}
// Methods for setting strings
- (void)setButtonContinueTitle:(BOOL)success inPopUp:(SuperPopUp*)_superPopUp{
    if (!success) {
        if (_language == 0)
            [_superPopUp setButtonTitle:@"Try Again"];
        else
            [_superPopUp setButtonTitle:@"Intenta otra vez"];
    } else {
        if (_language == 0)
            [_superPopUp setButtonTitle:@"Next Level"];
        else
            [_superPopUp setButtonTitle:@"Siguiente"];
    }
}
- (void)setLabelString:(NSString*)labelText withType:(int)typeOfPopUp andSuccess:(BOOL)success {
    if (!success && typeOfPopUp != 2) {
        if (_language == 0) // ENGLISH
            labelText = [NSString stringWithFormat:@"%@\r%@", @"You lose but...",@"Highscore!"];
        else // SPANISH
            labelText = [NSString stringWithFormat:@"%@\r%@", @"Pierdes pero...",@"¡Máx. Puntos!"];
    } else if (!success && typeOfPopUp == 2) {
        if (_language == 0) // ENGLISH
            labelText = [NSString stringWithFormat:@"%@\r%@", @"You can improve but...",@"Highscore!"];
        else // SPANISH
            labelText = [NSString stringWithFormat:@"%@\r%@", @"Puedes mejorar pero...",@"¡Máx. Puntos!"];
    } else if (success) {
        if (_language == 0) // ENGLISH
            labelText = [NSString stringWithFormat:@"%@\r%@", @"Excellent!",@"Highscore!"];
        else // SPANISH
            labelText = [NSString stringWithFormat:@"%@\r%@", @"¡Excelente!",@"¡Máx. Puntos!"];
    }
}

#pragma mark - AT THE END

- (void)dealloc {
    [self removeAllChildrenWithCleanup:TRUE];
    // Clean up memory allocations from sprites
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
}

@end
