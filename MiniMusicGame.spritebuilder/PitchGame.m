//
//  PitchGame.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PitchGame.h"
#import "GameData.h"
#import "MiniGameScene.h"
#import "PitchMusicalNote.h"
#import "MusicalGrid.h"
#import "PitchScorePopUp.h"
#import "YesNoPopUp.h"
#import "Language.h"

#pragma mark - COMPONENTS AND VARIABLES

@implementation PitchGame {
    CCLabelTTF *_timerLabel, *_specialLabel, *_scoreTitleLabel, *_timeTitleLabel;
    CCButton *_specialButton;
    CCLabelTTF *_scoreLabel, *_highscoreLabel, *_highscoreTitleLabel;
    MiniGameScene *_miniGameScene;
    MusicalGrid *_musicalGrid;
    OALSimpleAudio *_tickTock;
    int _timeForSpecial, _language;
    
    // for golden notes
    CCLabelTTF *_plusLabel; CCSprite *_goldImage;
}

#pragma mark - INITIALIZING

// Initializing the Scene
- (id)init {
    self = [super init];
    self.numberOfGame = 0;
    // ACCESS TO THE DATA IN GAME DATA
    self.level = [GameData sharedData].level;
    if (self.level == 0) {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"maxReached"];
    }
    _timeForSpecial = 4.0;
    _tickTock = [OALSimpleAudio sharedInstance];
    return self;
}

- (void)didLoadFromCCB {
    
    _language = [Language sharedData].language;
    [self checkLanguage:_language];
    
    // for golden notes
    _plusLabel.visible = FALSE;
    _goldImage.visible = FALSE;
    
    if (self.level != 4) {
        _highscoreLabel.visible = FALSE;
        _highscoreTitleLabel.visible = FALSE;
    } else {
        _highscoreTitleLabel.visible = TRUE;
        _highscoreLabel.visible = TRUE;
        _highscoreLabel.string = [NSString stringWithFormat:@"%li",(long)[[NSUserDefaults standardUserDefaults] integerForKey:@"pitchHighscore"]];
    }
    
    _showingSpecial = FALSE;
    _specialLabel.visible = FALSE;
    _specialButton.visible = FALSE;
}

// At the beginning
- (void)onEnter {
    [super onEnter];
    
    // changing the size of the MusicalGrid
    if (self.level <= 4) {
        switch (self.level) {
            case 0: // 2 x 2
                [self settingWithLevel:0 NumberOfRows:2 andColumns:2];
                break;
            case 1: // 2 x 3
                [self settingWithLevel:1 NumberOfRows:2 andColumns:3];
                break;
            case 2: // 2 x 4
                [self settingWithLevel:2 NumberOfRows:2 andColumns:4];
                break;
            case 3: // 3 x 4
                [self settingWithLevel:3 NumberOfRows:3 andColumns:4];
                break;
            case 4:
                [self settingWithLevel:4 NumberOfRows:3 andColumns:6];
                break;
            default:
                break;
        }
    } else { // the maximum is 3 x 6
        [self settingWithLevel:self.level NumberOfRows:3 andColumns:6];
    }
    
    // loading the user score
    _musicalGrid.score = [GameData sharedData].score;
    _scoreLabel.string = [NSString stringWithFormat:@"%i",_musicalGrid.score];
    
    // dealing with PopUps
    if (self.level == 0) {
        [super instructionsPopUpGoingUp];
    }
    [super miniGameSceneOnTop];
    
    // For unlocking specialNotes
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"roundsPlayed"] == Nil) {
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"roundsPlayed"];
    } else {
        int rounds = (int)([[NSUserDefaults standardUserDefaults] integerForKey:@"roundsPlayed"] + 1);
        if (rounds < 4) { // you can unlock special notes after X number of games
            [[NSUserDefaults standardUserDefaults] setInteger:rounds forKey:@"roundsPlayed"];
        } else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"specialUnlocked"] == Nil) {
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"specialUnlocked"];
        }
    }
    
    [OALSimpleAudio sharedInstance].bgPaused = TRUE;
}

// Language
- (void)checkLanguage:(int)language {
    NSString *labelText;
    if (language == 1) {
        labelText = [[[Language sharedData].startMenuLang objectAtIndex:1] objectForKey:@"puntos"];
        _scoreTitleLabel.string = labelText;
        _scoreLabel.position = ccp(62, 10);
        [_scoreLabel setFontSize:27];
        labelText = [[[Language sharedData].startMenuLang objectAtIndex:1] objectForKey:@"tiempo"];
        _timeTitleLabel.string = labelText;
        _timerLabel.position = ccp(160, 8);
        [_timerLabel setFontSize:27];
        labelText = [[[Language sharedData].startMenuLang objectAtIndex:1] objectForKey:@"maxPuntos"];
        _highscoreTitleLabel.string = labelText;
        _highscoreLabel.position = ccp(165, 40);
    }
}

#pragma mark - SETTING THE GAME

// Setting values for the MusicalGrid
- (void)settingWithLevel:(int)level NumberOfRows:(int)rows andColumns:(int)columns {
    
    // setting values for the game
    self.level = level;
    _gridRows = rows;
    _gridColumns = columns;
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // showing the InstructionsPopUp
    if (self.level == 0) {
        if (_language == 0) // ENGLISH
            [self showingInstructions:@"Pair the sounds!" NumberOfGame:10];
        else    // SPANISH
            [self showingInstructions:[NSString stringWithFormat:@"%@\r%@", @"¡Haz pares con",@"los sonidos!"] NumberOfGame:10];
    }
    
    // setting the MusicalGrid
    _musicalGrid = (MusicalGrid *)[CCBReader load:@"MusicalGrid"];
    [_musicalGrid settingGridRows:_gridRows andColumns:_gridColumns];
    CGSize screen = [[CCDirector sharedDirector] viewSize];
    
    // setting the timer data and position of the grid
    // saving switches :P
    switch (self.level) {
        case 0: // 2 x 2
            _countTime = 10;
            _musicalGrid.position = ccp(screen.width/2+90, screen.height/2+25);
            break;
        case 1: // 2 x 3
            _countTime = 10;
            _musicalGrid.position = ccp(screen.width/2+50, screen.height/2+15);
            break;
        case 2: // 2 x 4
            _countTime = 20;
            _musicalGrid.position = ccp(screen.width/2+40, screen.height/2+15);
            break;
        case 3: // 3 x 4
            _countTime = 30;
            _musicalGrid.position = ccp(screen.width/2+35, screen.height/2+5);
            break;
        case 4: // 3 x 6
            _countTime = 45;
            break;
        default:
            break;
    }
    
    // position for higher levels is the same
    if (self.level >= 4) {
        _musicalGrid.position = ccp(screen.width/2+15, screen.height/2+5);
    }
    // higher levels countTime
    if (self.level > 4 && self.level <= 6) {
        _countTime = 40;
    } else if (self.level == 6) {
        _countTime = 35;
    } else if (self.level >= 7) {
        _countTime = 30;
    }
    
    // continue with the grid
    // in the center of the screen
    _musicalGrid.anchorPoint = ccp(0.5, 0.5);
    // adding it to the scene
    [self addChild:_musicalGrid];
    // at the beginning
    _musicalGrid.userInteractionEnabled = FALSE;
    
}

#pragma mark -  UPDATING THE GAME
//TODO: CAN BE IMPROVED, A LOT OF WEIRD THINGS HAPPENING HERE!

// Cool way to remove exitPopUp
- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    YesNoPopUp *child = (YesNoPopUp*)[self getChildByName:@"_exitPopUp" recursively:TRUE];
    if (child != Nil) {
        CGPoint touchLocation = [touch locationInNode:self];
        if (!CGRectContainsPoint(child.boundingBox, touchLocation)) {
            [child removeFromParentAndCleanup:TRUE];
        }
    }
}

// updating the game
- (void)update:(CCTime)delta {
    
    [self updateLabels];
    
    if (_countTime >= 1) {
        if ((self.level == 1 && _countTime <= 5 && !_showingSpecial) || (self.level == 2 && _countTime <= 8 && !_showingSpecial)
            || (self.level == 3 && _countTime <= 15 && !_showingSpecial) || (self.level >= 4 &&_countTime <= 20 && !_showingSpecial)) {
            _specialButton.visible = TRUE;
            _specialLabel.visible = TRUE;
            _showingSpecial = TRUE;
        }
    }
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"] <= 0) {
        _specialButton.enabled = FALSE;
    }
    
    if (self.level == 4 && _countTime <= 21) {
        _highscoreLabel.visible = FALSE;
        _highscoreTitleLabel.visible = FALSE;
    }
    
//    if (self.started) {
//        [self schedule:@selector(updatePairs) interval:0.1f];
//        [self startTimer];
//        self.started = FALSE;
//    }

    // FOR THE GAME
    // updating the end of the game
    if (!_miniGameScene.showingExit) {
        if ([self getChildByName:@"_instPopUp" recursively:TRUE] == Nil && [self getChildByName:@"score" recursively:TRUE] == Nil) {
            if (self.started) {
                [self playGame];
                self.started = FALSE;
                self.gamePaused = FALSE;
            }
        } else {
            if (!self.gamePaused) {
                [self pauseGame];
                self.gamePaused = TRUE;
            }
        }
    } else { // pausing the game (in case that is not already paused by the Score PopUp)
        if (!self.gamePaused) {
            [self pauseGame];
            self.gamePaused = TRUE;
            self.started = TRUE;
            _miniGameScene.showingExit = TRUE;
        }
    }
}

#pragma mark - METHODS TO BE CALLED IN THE UPDATE

// for PLAYING the game
- (void)playGame {
    [self schedule:@selector(updatePairs) interval:0.1f];
    [self startTimer];
    _specialButton.enabled = TRUE;
    _musicalGrid.userInteractionEnabled = TRUE;
}

// for PAUSING the game
- (void)pauseGame {
    [self unschedule:@selector(updatePairs)];
    [self unschedule:@selector(countingTimeForSpecial)];
    [self pauseTimer];
    _specialButton.enabled = FALSE;
    _musicalGrid.userInteractionEnabled = FALSE;
}

- (void)updateLabels {
    
    // updating the timerLabel
    NSString *langTimer;
    if ([Language sharedData].language == 0)    // ENGLISH
        langTimer = @"%i sec";
    else    // SPANISH
        langTimer = @"%i seg";
    [_timerLabel setString:[NSString stringWithFormat:langTimer , self.countTime]];
    // getting the number of golden notes
    int special = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"];
    _specialLabel.string = [NSString stringWithFormat:@"x %i", special];;
    
}

// updating the user advance
- (void)updatePairs {
    _scoreLabel.string = [NSString stringWithFormat:@"%i",_musicalGrid.score];
    if (_musicalGrid.paired == ((_musicalGrid.grid_columns * _musicalGrid.grid_rows) / 2 )) {
        [self endingGame];
    }
}

// starts the timer (first time or again)
- (void)startTimer {
    [self schedule:@selector(countDown) interval:1.0f];
}

// pauses the timer
- (void)pauseTimer {
    [self unschedule:@selector(countDown)];
}

// countDown for the time in the level
- (void)countDown {
    self.countTime--;
    if (self.countTime <= 0) {
        [self unschedule:@selector(countDown)];
        [self endingGame];
    }
    [super miniGameSceneOnTop];
}

- (void)endingGame {
    NSString *roundScore;
    _specialButton.visible = FALSE;
    _specialLabel.visible = FALSE;
    BOOL nextLevel = FALSE;
    if (_musicalGrid.paired > 0 && _musicalGrid.paired <= _musicalGrid.pairsInGame - 1) {
        if (_language == 0) // ENGLISH
            roundScore = [NSString stringWithFormat:@"%@\r%@", @"So close!",@"Ready?"];
        else // SPANISH
            roundScore = [NSString stringWithFormat:@"%@\r%@", @"¡Estuviste cerca!",@"¿Listo?"];
    } else {
        if (_musicalGrid.paired == _musicalGrid.pairsInGame) {
            if (_language == 0) // ENGLISH
                roundScore = @"Good job!";
            else // SPANISH
                roundScore = @"¡Buen trabajo!";
            nextLevel = TRUE;
        } else {
            if (_language == 0) // ENGLISH
                roundScore = [NSString stringWithFormat:@"%@\r%@", @"Try again",@"You can do it!"];
            else
                roundScore = [NSString stringWithFormat:@"%@\r%@", @"Intenta de nuevo",@"¡Puedes lograrlo!"];
        }
    }
    
    // for scores
    if (self.level >= 4 && nextLevel) {
        int plusOne = (int)([[NSUserDefaults standardUserDefaults] integerForKey:@"goldenNotes"] + 1);
        [[NSUserDefaults standardUserDefaults] setInteger:plusOne forKey:@"goldenNotes"];
        _plusLabel.visible = TRUE;
        _goldImage.visible = TRUE;
    }
    
    [self showingScore:self.numberOfGame withText:roundScore actualLevel:self.level userSuccess:nextLevel andCurrentScore:_musicalGrid.score];
    
    if (self.level == 4 && ![[NSUserDefaults standardUserDefaults] boolForKey:@"maxReached"]) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"maxReached"];
    }
}

#pragma mark - SUPER SPECIAL METHODS

- (void)specialNotesVisible {
    _specialButton.visible = TRUE;
    _specialLabel.visible = TRUE;
    
}

// two random options
- (void)showSpecial {
    
    // score reduced
    self.score -= 30;
    
    int goodBadLuck = 0 + arc4random() % (99);
    
    // first option: bad luck, show one pair
    if (goodBadLuck % 33 == 0) {
        int rndRow = 0 + arc4random() % (_musicalGrid.grid_rows - 1);
        int rndColumn = 0 + arc4random() % (_musicalGrid.grid_columns - 1);
        PitchMusicalNote *isThis = (PitchMusicalNote *)(_musicalGrid.gridArray[rndRow][rndColumn]);
        if (!isThis.hasBeenRemoved) {
            [self changingNote:isThis];
        } else {
            isThis = [self lookingForOne];
            [self changingNote:isThis];
        }
        
    } else if (goodBadLuck % 20 == 0) { // second option: good luck, show names! :)
        [_musicalGrid showBubbles:TRUE];
        _tickTock = [[OALSimpleAudio sharedInstance] playEffect:@"Audio/timeSec.wav"];
        [self schedule:@selector(countingTimeForSpecial) interval:1.0f];
        
    } else { // common option: names of the ones you touch
        _musicalGrid.showBubbleAtTouch = TRUE;
    }
    // just once per level
    _specialButton.visible = FALSE;
    _specialLabel.visible = FALSE;
    
    int minusOne = (int)([[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"] - 1);
    [[NSUserDefaults standardUserDefaults] setInteger:minusOne forKey:@"specialNotes"];
}

// until we get one
- (PitchMusicalNote *)lookingForOne {
    BOOL found = FALSE;
    PitchMusicalNote *isThis;
    while (!found) {
        int rndRow = 0 + arc4random() % (_musicalGrid.grid_rows - 1);
        int rndColumn = 0 + arc4random() % (_musicalGrid.grid_columns - 1);
        isThis = (PitchMusicalNote *)(_musicalGrid.gridArray[rndRow][rndColumn]);
        if (!isThis.hasBeenRemoved) {
            found = TRUE;
        }
    }
    return isThis;
}

// for second option
- (void)changingNote:(PitchMusicalNote *)isThis {
    NSString *nameForChange = isThis.noteName;
    [isThis chooseRandomImage];
    
    for (int i = 0; i < _musicalGrid.grid_rows; i++) {
        for (int j = 0; j < _musicalGrid.grid_columns; j++) {
            PitchMusicalNote *thisOther = (PitchMusicalNote *)(_musicalGrid.gridArray[i][j]);
            if ([thisOther.noteName isEqualToString:nameForChange] && !thisOther.specialChange) {
                thisOther.imageChange = isThis.imageChange;
                [thisOther pairRandomImage];
                
            }
        }
    }
}

- (void)countingTimeForSpecial {
    _timeForSpecial--;
    if (_timeForSpecial <= 0) {
        [self unschedule:@selector(countingTimeForSpecial)];
        _tickTock.paused = TRUE;
        [[OALSimpleAudio sharedInstance] playEffect:@"Audio/fail_touched_note.wav"];
        [_musicalGrid showBubbles:FALSE];
    }
}

@end
