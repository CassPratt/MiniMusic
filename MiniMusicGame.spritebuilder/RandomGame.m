//
//  RandomGame.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RandomGame.h"
#import "GameData.h"
#import "RandomMusicalNote.h"
#import "InstructionsPopUp.h"
#import "LifeMusic.h"
#import "MiniGameScene.h"
#import "Language.h"

#pragma mark - COMPONENETS AND VARIABLES

@implementation RandomGame {
    CCLabelTTF *_colorLabel, *_scoreLabel, *_specialLabel, *_scoreTitleLabel;
    CCButton *_specialButton;
    CCPhysicsNode *_physicsNode; // <-- TO TURN THE NOTES INTO PHYSICS OBJECTS
    NSMutableArray *_notesInGame; // <-- EVERY NOTE IN THE GAME
    float _rndValue, _rndDirection; // <-- FOR SETTING THE VELOCITY AND DIRECTION OF EACH NOTE
    int _numSpecial, _foundNotes; // <-- NUMBER OF COLOR NOTES
    MiniGameScene *_miniGameScene;
    int _language;
    
    // for golden notes
    CCLabelTTF *_plusLabel; CCSprite *_goldImage;
}

#pragma mark - INITIALIZING

// Initializing the Scene
- (id)init {
    if (self = [super init]) {
        CCLOG(@"RandomGame loaded with default");
        // setting level
        self.numberOfGame = 1;
        self.level = [GameData sharedData].level;
        self.score = [GameData sharedData].score;
        _language = [Language sharedData].language;

        _numberOfLifes = 3; // <-- USER CHANCES TO TAP THE CORRECT NOTES
        _numberOfColorNotes = 1; _numberOfOtherNotes = 0; // <-- FOR DEFAULT IN THE FIRST LEVELS
        
        _timeForLife = 2.0f; // <-- THINKING ABOUT CHANGING WITH THE LEVELS?
        
    }
    return  self;
}

#pragma mark - SETTING THE GAME

- (void)didLoadFromCCB {
    // Checking language
    [self checkLanguage:_language];
    
    _plusLabel.visible = FALSE;
    _goldImage.visible = FALSE;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"specialNotes"] == Nil) {
        _specialButton.visible = FALSE;
        _specialLabel.visible = FALSE;
    } else {
        _numSpecial = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"];
        _specialButton.visible = TRUE;
        _specialLabel.string = [NSString stringWithFormat:@"x %i",_numSpecial];
    }
    
    _miniGameScene.numberOfGame = 1;
}

- (void)onEnter {
    [super onEnter];
    
    // setting the game
    [self settingLevel:self.level];
    
    
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

// For language
- (void)checkLanguage:(int)language {
    if (language == 1) {
        NSString *labelText = [[[Language sharedData].startMenuLang objectAtIndex:1] objectForKey:@"puntos"];
        _scoreTitleLabel.string = labelText;
        _scoreLabel.position = ccp(160, 10);
    }
}


// setting the level <-- METHOD TO BE CALLED EACH TIME THE GAME IS STARTED
- (void)settingLevel:(int)level {
    
    // setting physics
    _physicsNode.collisionDelegate = self;
    
    // no touch at the beginning
    self.userInteractionEnabled = FALSE;
    
    // setting the color for the level <-- EACH TIME IS RANDOM
    [self settingChosenColor];
    
    // difficulty depending on the level
    if (self.level == 0) { // <-- JUST STARTED
        _foundNotes = _numberOfColorNotes;
        _numberOfOtherNotes = 0;
        
    } else if (self.level == 1) { // <-- INTRODUCING OTHER COLORS
        _foundNotes = _numberOfColorNotes;
        _numberOfOtherNotes = 1;
        
    } else if (self.level == 2) { // <-- INTRODUCING MORE NOTES
        _foundNotes = _numberOfColorNotes;
        _numberOfOtherNotes = 3;
        
    } else if (self.level == 3 || self.level == 4) { // <-- NOW LET'S HAVE MORE NOTES
        _numberOfColorNotes = 2;
        _foundNotes = _numberOfColorNotes; // <-- FOR UPDATE THE LABEL
        _numberOfOtherNotes = _numberOfColorNotes * 2;
        
    } else if (self.level == 5 || self.level == 6) {
        _numberOfColorNotes = 3;
        _foundNotes = _numberOfColorNotes;
        _numberOfOtherNotes = _numberOfColorNotes + 2;
        
    } else if (self.level >= 7 && self.level <= 9) {
        _numberOfColorNotes = 3;
        _foundNotes = _numberOfColorNotes;
        _numberOfOtherNotes = _numberOfColorNotes * 2;
        
    } else if (self.level >= 10 && self.level <= 15) {
        _numberOfColorNotes = 4;
        _foundNotes = _numberOfColorNotes;
        _numberOfOtherNotes = _numberOfColorNotes * 2;
    } else if (self.level >= 16 && self.level <= 20) {
        _numberOfColorNotes = 5;
        _foundNotes = _numberOfColorNotes;
        _numberOfOtherNotes = _numberOfColorNotes + 4;
    } else if (self.level >= 21 /* && self.level <= 25 */) { // <--- MUST TEST REACTIONS
        _numberOfColorNotes = 6;
        _foundNotes = _numberOfColorNotes;
        _numberOfOtherNotes = _numberOfColorNotes + 4;
    } else if (self.level >= 26) {
        _numberOfColorNotes = 7;
        _foundNotes = _numberOfColorNotes;
        _numberOfOtherNotes = _numberOfColorNotes + 3;
    }
    
    // score Label
    [_scoreLabel setString:[NSString stringWithFormat:@"%i",self.score]];
    
    // showing the MusicalNotes
    [self showingNotesOfChosenColor];
    
    // dealing with the PopUps
    [super miniGameSceneOnTop];
}

// setting the color for the game
- (void)settingChosenColor {
    
    // sets a random color for the game
    CCColor *notesColor, *auxColor;
    NSString *colorName;
    int rndValue = 1 + arc4random() % (7);
    
    // some problems figuring out the randoms...
    if (rndValue == 1) {
        rndValue += 1;
    }
    
    switch (rndValue) {
        case 7: // SEVEN so we don't have problems with the (a % b)
            auxColor = [CCColor colorWithRed:250.f/255.f green:152.f/255.f blue:152.f/255.f];
            notesColor = auxColor;
            if (_language == 0)
                colorName = @"Red";
            else
                colorName = @"Rojo";
            break;
        case 2:
            notesColor = [CCColor colorWithRed:250.f/255.f green:208.f/255.f blue:135.f/255.f];
            if (_language == 0)
                colorName = @"Orange";
            else
                colorName = @"Naranja";
            break;
        case 3:
            auxColor = [CCColor colorWithRed:247.f/255.f green:250.f/255.f blue:157.f/255.f];
            notesColor = auxColor;
            if (_language == 0)
                colorName = @"Yellow";
            else
                colorName = @"Amarillo";
            break;
        case 4:
            auxColor = [CCColor colorWithRed:214.f/255.f green:235.f/255.f blue:162.f/255.f];
            notesColor = auxColor;
            if (_language == 0)
                colorName = @"Green";
            else
                colorName = @"Verde";
            break;
        case 5:
            auxColor = [CCColor colorWithRed:186.f/255.f green:247.f/255.f blue:255.f/255.f];
            notesColor = auxColor;
            if (_language == 0)
                colorName = @"Blue";
            else
                colorName = @"Azul";
            break;
        case 6:
            auxColor = [CCColor colorWithRed:202.f/255.f green:181.f/255.f blue:255.f/255.f];
            notesColor = auxColor;
            if (_language == 0)
                colorName = @"Purple";
            else
                colorName = @"Morado";
            break;
        default:
            break;
    }
    // setting the chosenColor
    _chosenColor = rndValue;
    
    // the color is shown in a label
    [_colorLabel setString:colorName];
    [_colorLabel setColor:notesColor];
    
}

// adding MusicalNotes and saving them in an array
- (void)showingNotesOfChosenColor {
    
    // Initializing the array for the notes
    _notesInGame = [NSMutableArray array];
    
    // selecting the notes of the chosen color
    for (int i = 0; i < _numberOfColorNotes; i++) {  // <--- CHANGE THIS TO TEST
        RandomMusicalNote *randomNote = [[RandomMusicalNote alloc] initWithColor:_chosenColor];
        [_notesInGame addObject:randomNote];
        // the sound that they'll do when disappearing
        [randomNote setSoundFileName:@"Audio/disappearing_note.wav"];
    }
    
    // selecting the other notes (different colors)
    int soRandom;
    while ([_notesInGame count] < (_numberOfColorNotes + _numberOfOtherNotes)) {
        soRandom = 1 + arc4random() % (7);
        if (soRandom % _chosenColor != 0 && soRandom != 1) {
            RandomMusicalNote *anotherNote = [[RandomMusicalNote alloc] initWithColor:soRandom];
            [_notesInGame addObject:anotherNote];
            // the sound that they'll do when disappearing
            [anotherNote setSoundFileName:@"Audio/fail_touched_note.wav"];
        }
    }
    
    // for the position of the note
    float x = 0;
    float y = 0;
    
    // adding the notes as children
    for (int m = 0; m < [_notesInGame count]; m++) {

        // no gravity in this game
        _physicsNode.gravity = ccp(0, 0);
        
        int rndPosition;
        // random position for the MusicalNotes
        rndPosition = 0 + arc4random() % (440);
        x = rndPosition;
        rndPosition = 0 + arc4random() % (250);
        y = rndPosition;
        
        // Initializing the note
        RandomMusicalNote *thisOne = (RandomMusicalNote *)[_notesInGame objectAtIndex:m];
        // no special names for this game
        [thisOne setNoteName:@"Random Note"];
        
        // setting the position
        CGPoint thisPosition = ccp(x, y);
        thisOne.anchorPoint = ccp(0, 0);
        thisOne.position = thisPosition;
        // setting the new position in the note
        [thisOne setNotePosition:thisPosition];
        // adding the notes to the scene
        thisOne.name = [NSString stringWithFormat:@"note%i",m]; // to recognize it easily
        [_physicsNode addChild:thisOne];
        
        // we want the note to have physics enabled
        CGFloat radius = ccpDistance(ccp(0, 0), ccp(thisOne.boundingBox.size.width/2, thisOne.boundingBox.size.height/2)) - 8;
        thisOne.physicsBody = [CCPhysicsBody bodyWithCircleOfRadius:radius andCenter:ccp(thisOne.boundingBox.size.width/2, thisOne.boundingBox.size.height/2)];
        thisOne.physicsBody.collisionType = @"musicalNote";
        thisOne.physicsBody.elasticity = 1;
        thisOne.physicsBody.friction = 0;
    }
}

#pragma mark - UPDATING THE GAME
//CAN BE IMPROVED, A LOT OF WEIRD THINGS HAPPENING HERE!
//TODO: remove the is paused code from the update method
- (void)update:(CCTime)delta {
    
    [self updateLabels];
    
//    if (self.started) {
//        [self schedule:@selector(startingGame) interval:0.05f];
//        [self schedule:@selector(endingGame) interval:0.5f];
//        [self schedule:@selector(userLosingLifes) interval:_timeForLife];
//        self.started = FALSE;
//    }
    
    // DELETE THIS WHEN YOU IMPLEMENT PAUSES -CORRECTLY- WITH CCDIRECTOR...!!! <--------------------
    if (!_miniGameScene.showingExit) { // not showing the Exit PopUp
        if (self.started) {
            
            // starting the game, checking ending
            [self playGame];
            
            self.started = FALSE;
            self.gamePaused = FALSE;
        }
        // checking the score PopUp is not showing
        if ([self getChildByName:@"score" recursively:TRUE] != Nil && !self.gamePaused) {
            // pausing the "start" and "check"
            [self pauseGame];
            self.gamePaused = TRUE;
        }
        
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"] < 1) {
            _specialButton.enabled = FALSE;
        }
        _specialLabel.string = [NSString stringWithFormat:@"x %i",_numSpecial];
    
    } else { // pausing the game (in case that is not already paused by the Score PopUp
        if (!self.gamePaused) {
            [self pauseGame];
            self.gamePaused = TRUE;
            self.started = TRUE;
            _miniGameScene.showingExit = TRUE;
        }
    }
}

#pragma mark - METHODS TO BE CALLED IN THE UPDATE

// playing the game
- (void)playGame {
    _specialButton.enabled = TRUE;
    [self schedule:@selector(startingGame) interval:0.05f];
    [self schedule:@selector(userLosingLifes) interval:_timeForLife];
    // enabling interaction on each MusicalNote <-- FOR NOW, COULD'VE DISABLED VELOCITY
    for (int i = 0; i < [_notesInGame count]; i++) {
        RandomMusicalNote *thisNow = (RandomMusicalNote *)[_notesInGame objectAtIndex:i];
        thisNow.userInteractionEnabled = TRUE;
    }
}

// pausing the game
- (void)pauseGame {
    _specialButton.enabled = FALSE;
    [self unschedule:@selector(startingGame)];
    [self unschedule:@selector(userLosingLifes)];// enabling interaction on each MusicalNote <-- FOR NOW, COULD'VE DISABLED VELOCITY
    for (int i = 0; i < [_notesInGame count]; i++) {
        RandomMusicalNote *thisNow = (RandomMusicalNote *)[_notesInGame objectAtIndex:i];
        thisNow.userInteractionEnabled = FALSE;
    }
    [[CCDirector sharedDirector] pause];
}

// updating labels
- (void)updateLabels {

    [_scoreLabel setString:[NSString stringWithFormat:@"%i",self.score]];
    // getting the number of golden notes
    int special = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"];
    _specialLabel.string = [NSString stringWithFormat:@"x %i", special];;
    
}

// method that does everything for the game
- (void)startingGame {
    
    if (_foundNotes <= 0) {
        [self endingGame];
    }
    
    for (int i = 0; i < [_notesInGame count]; i++) {
        RandomMusicalNote *thisNow = (RandomMusicalNote *)[_notesInGame objectAtIndex:i];
        // applying an inicial impulse
        if (!thisNow.firstTimeImpulsed) {
            if (self.level <= 9) {
                _rndDirection = (0) + arc4random() % (200);
                _rndValue = (0) + arc4random() % (150);
            } else {
                _rndDirection = (0) + arc4random() % (200);
                _rndValue = (0) + arc4random() % (200);
            }
            [thisNow.physicsBody applyImpulse:ccp(_rndValue, _rndDirection)];
            thisNow.firstTimeImpulsed = TRUE;
        }
        // updating each MusicalNote _notePosition
        thisNow.notePosition = thisNow.position;
        
        // touching the correct note
        if (thisNow.touched == TRUE && thisNow.noteColor == _chosenColor) {
            [thisNow touchStatus];
            
            // making it look good
            CCParticleSystem *foundOne = (CCParticleSystem *)[CCBReader load:@"LittleEfect"];
            foundOne.autoRemoveOnFinish = TRUE;
            foundOne.positionType = CCPositionTypePoints;
            float x = thisNow.position.x + 20;
            float y = thisNow.position.y + 30;
            foundOne.position = ccp(x,y);
            [thisNow.parent addChild:foundOne];
            
            // removing the note
            [thisNow removeFromParentAndCleanup:TRUE];
            _foundNotes--;
            
            // updating the score
            self.score += 2;
            
            if (self.score % 20 == 0 && self.score > 0) {
                int plusOne = (int)([[NSUserDefaults standardUserDefaults] integerForKey:@"goldenNotes"] + 1);
                [[NSUserDefaults standardUserDefaults] setInteger:plusOne forKey:@"goldenNotes"];
                
                _plusLabel.visible = TRUE;
                _goldImage.visible = TRUE;
                
//                // adding effect of golden note <-- MAYBE LATER <--------------------------------
//                RandomMusicalNote *golden = [[RandomMusicalNote alloc] initWithColor:8];
//                golden.position = ccp(x, y);
//                [self addChild:golden];
//                [self removeChild:golden cleanup:TRUE];
            }
            
            // touching the incorrect note
        } else if (thisNow.touched == TRUE && thisNow.noteColor != _chosenColor) {
                thisNow.failedTouch = TRUE;
        }
        // you miss, you lose one life
        if (thisNow.failedTouch == TRUE && _numberOfLifes > 0) {
            // removing life
            [self removeLifeAddingEffectTo:thisNow.parent];
            [self unschedule:@selector(userLosingLifes)];
            [self schedule:@selector(userLosingLifes) interval:_timeForLife];
            
            // reseting the values of the note
            [thisNow touchStatus];
            thisNow.failedTouch = FALSE;
            
        } else if (_numberOfLifes <= 0 || _foundNotes <= 0) {
            thisNow.userInteractionEnabled = FALSE;
        }
    }
}

// after certain time, the user loses one life
- (void)userLosingLifes {
    if (_numberOfLifes > 0) {
        [self removeLifeAddingEffectTo:self];
        OALSimpleAudio *audio = [OALSimpleAudio sharedInstance];
        [audio playEffect:@"Audio/fail_touched_note.wav"];
    }
}

// endingGame update
- (void)endingGame {
    NSString *message;
    if (_numberOfLifes <= 0) { // ENDING
        [self unschedule:@selector(update:)];
        if (_language == 0)
            message = @"Try Again!";
        else
            message = @"¡Intenta de nuevo!";
            [self showingScore:1 withText:message actualLevel:self.level userSuccess:FALSE andCurrentScore:self.score];
    } else  if (_foundNotes <= 0){
        if (_language == 0)
            message = @"Good job!";
        else
            message = @"¡Buen trabajo!";
        [self showingScore:1 withText:message actualLevel:self.level userSuccess:TRUE andCurrentScore:self.score];
    }

    [self miniGameSceneOnTop];
}

// method for removing lifes
- (void)removeLifeAddingEffectTo:(CCNode *)thisNow {
    // getting the life
    CCNode *life = [self getChildByName:[NSString stringWithFormat:@"life%i",_numberOfLifes] recursively:TRUE];

    CCParticleSystem *minusOne = (CCParticleSystem *)[CCBReader load:@"LosingLife"];
    minusOne.autoRemoveOnFinish = TRUE;
    float x = 0;
    float y = 0;
    if (_numberOfLifes == 3) {
        x = life.position.x - 80;
    } else if (_numberOfLifes == 2){
        x = life.position.x - 50;
    } else {
        x = life.position.x + 5;
    }
    y = life.position.y;
    
    CGPoint effectPosition = [life convertToWorldSpace:ccp(x, y)];
    minusOne.positionType = CCPositionTypePoints;
    minusOne.position = [_physicsNode convertToNodeSpace:effectPosition];
    [thisNow addChild:minusOne];
    [self removeChild:life cleanup:TRUE];
    
    _numberOfLifes--;
    
    if (_numberOfLifes <= 0) {
        [self endingGame];
    }
}

#pragma mark - SUPER SPECIAL METHODS

- (void)showSpecial {
    
    for (int i = 0; i < [_notesInGame count]; i++) {
        RandomMusicalNote *thisNow = (RandomMusicalNote *)[_notesInGame objectAtIndex:i];
        if (thisNow.noteColor != _chosenColor) {
            thisNow.physicsBody.velocity = ccp(0, 0);
        }
    }
    
    _numSpecial = (int)([[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"] - 1);
    [[NSUserDefaults standardUserDefaults] setInteger:_numSpecial forKey:@"specialNotes"];

    // making it look good
    CCParticleSystem *superOne = (CCParticleSystem *)[CCBReader load:@"SuperSpecial"];
    superOne.autoRemoveOnFinish = TRUE;
    superOne.positionType = CCPositionTypePoints;
    superOne.position = ccp(self.boundingBox.size.width/2, self.boundingBox.size.height/2);
    superOne.opacity = 0.0;
    
    [[OALSimpleAudio sharedInstance] playEffect:@"Audio/specialSound.wav"];
    [self addChild:superOne];
    
    _specialButton.enabled = FALSE;
}

#pragma mark - PHYSICS ON THE GAME / COLLISIONS

// we don't want MusicalNotes bouncing against each other
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair musicalNote:(RandomMusicalNote *)musicalNote musicalNote:(RandomMusicalNote *)anotherNote {
    return FALSE;
}

// checking the collision with the borders
- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair musicalNote:(RandomMusicalNote *)musicalNote border:(CCSprite *)border {
    return TRUE;
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
