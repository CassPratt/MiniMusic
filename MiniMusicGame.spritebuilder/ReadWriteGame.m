//
//  ReadWriteGame.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ReadWriteGame.h"
#import "GameData.h"
#import "MusicalStaff.h"
#import "ReadWriteMusicalNote.h"
#import "DisplayName.h"
#import "MiniGameScene.h"
#import "AppDelegate.h"
#import "YesNoPopUp.h"
#import "Language.h"

@implementation ReadWriteGame {
    MiniGameScene *_miniGameScene;
    MusicalStaff *_musicalStaff;
    CCPhysicsNode *_physicsNode;
    CCSprite *_key;
    CCLabelTTF *_scoreLabel, *_wasThisLabel, *_specialLabel;
    CCButton *_specialButton;
    DisplayName *_optionOne, *_optionTwo, *_optionThree;
    NSArray *_optionsForUser;
    int _weAreInThisNote, _invisibleOption; BOOL _hidden;
    BOOL _removed, _scheduled; int _waiting;
    NSString *temporal;
    int _language;
}

#pragma mark - INITIALIZING

- (id)init {
    if (self = [super init]) {
        self.numberOfGame = 2;
        // ACCESS TO THE DATA IN GAME DATA
        self.level = [GameData sharedData].level;
        self.score = [GameData sharedData].score;
        _selectedOption = [NSString string];
        _correctOption = [NSString string];
        _waitingNext = TRUE;
        _removed = FALSE; _scheduled = FALSE;
        _hidden = FALSE; // for special one
        _otherOctave = FALSE;
        if (self.level == 14) {
            _waiting = 0.2;
        } else {
            _waiting = 0.5;
        }
        _language = [Language sharedData].language;
    }
    return self;
}

- (void)didLoadFromCCB {
    
    // saving the options in an array
    _optionsForUser = [NSArray arrayWithObjects:_optionOne,_optionTwo, _optionThree, nil];
    
    _scoreLabel.string = [NSString stringWithFormat:@"%i",self.score];
    _wasThisLabel.visible = FALSE;
    _miniGameScene.numberOfGame = self.numberOfGame;
    
    // getting the number of special notes
    [self updateLabels];
    
    _specialButton.visible = FALSE;
    _specialLabel.visible = FALSE;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"advancedUnlocked"] == Nil && self.level == 14)
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"advancedUnlocked"];
}

- (void)onEnter {
    [super onEnter];
    
    self.userInteractionEnabled = TRUE;
    
    // setting with level and number of notes
    [self settingWithLevel:self.level];
    
    // dealing with yesNoPopUp
    [self miniGameSceneOnTop];
    
    // for background music
    [OALSimpleAudio sharedInstance].bgPaused = TRUE;
}

#pragma mark - SETTING THE GAME

- (void)settingWithLevel:(int)level {
    
    // setting the MusicalStaff
    [_musicalStaff settingWithLevel:self.level];
    _numNotes = (int)[_musicalStaff.notesInGame count];
    
    // we'll follow the first note in the screen
    _weAreInThisNote = -1;
    [self setNoteOptions:0];
    temporal = _correctOption;
}

#pragma mark - TOUCH METHODS

- (void)touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPosition = [touch locationInWorld];
    
    for (DisplayName *thisOption in _optionsForUser) {
        if (CGRectContainsPoint(thisOption.boundingBox, touchPosition)) {
            _selectedOption = thisOption.labelText;
            if ([_selectedOption isEqualToString:_correctOption]) {
                self.score += 2;
                _correctNotes++;
                [self setNoteOptions:0];
            } else {
                if (self.score > 0) {
                    self.score -= 1;
                }
                [self setNoteOptions:1];
            }
        }
    }
    self.userInteractionEnabled = FALSE;

}

#pragma mark - UPDATING THE GAME

- (void)update:(CCTime)delta {
    
    // checking user special notes
    [self updateLabels];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"] <= 0) {
        _specialButton.enabled = FALSE;
    }
    
    if (self.level >= 4 && self.level <= 9 && _weAreInThisNote == (_numNotes/2)) {
        _specialLabel.visible = TRUE;
        _specialButton.visible = TRUE;
    } else if (self.level > 9 && self.level <= 14 && _weAreInThisNote == (_numNotes/3)) {
        _specialButton.visible = TRUE;
        _specialLabel.visible = TRUE;
    } else if (self.level > 14 && _weAreInThisNote == (_numNotes/5)) {
        _specialLabel.visible = TRUE;
        _specialButton.visible = TRUE;
    }
    
    temporal = _correctOption;
    
   if (_removed && !_scheduled) {
        if (self.level >= 14) {
            [self schedule:@selector(waitForDisappearing) interval:0.2f];
        } else {
            [self schedule:@selector(waitForDisappearing) interval:0.5f];
        }
        _scheduled = TRUE;
        _removed = FALSE;
    }
    
    if (self.score < 0) {
        self.score = 0;
    }
    _scoreLabel.string = [NSString stringWithFormat:@"%i",self.score];
    
    //TODO: CAN BE IMPROVED
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

- (void)playGame {
    [self schedule:@selector(checkStatusOfNotes) interval:0.01f];
    _musicalStaff.userInteractionEnabled = TRUE;
    self.userInteractionEnabled = TRUE;
    
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    appDelegate.userPaused = FALSE;
}

- (void)pauseGame {
    [self unschedule:@selector(checkStatusOfNotes)];
    _musicalStaff.userInteractionEnabled = FALSE;
    self.userInteractionEnabled = FALSE;
    [[CCDirector sharedDirector] pause];
    
    AppController *appDelegate = (AppController *)[[UIApplication sharedApplication] delegate];
    appDelegate.userPaused = TRUE;
}

// for user's special notes
- (void)updateLabels {
    
    // getting the number of special notes
    int special = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"];
    _specialLabel.string = [NSString stringWithFormat:@"x %i", special];;
    
}

// checking the notes position in the game
- (void)checkStatusOfNotes {
    
    // when the notes reach the Key
    NSArray* musicalNotes = [_musicalStaff.notesInGame copy];
    for (ReadWriteMusicalNote *checkThis in musicalNotes) {
        
        if (CGRectIntersectsRect(_key.boundingBox, checkThis.boundingBox) && checkThis.parent != nil) {
            // remove object
            [[OALSimpleAudio sharedInstance] playEffect:@"Audio/fail_touched_note.wav"];
            [self removeType:1 andWithParticleEffect:checkThis];
            
            //TODO: this causes a crash. review if there is a memory performance issue
            //            [_musicalStaff.notesInGame removeObject:checkThis];

            [self setNoteOptions:1];
        }
        
        // enable user touch
        if ([checkThis.noteName isEqualToString:_correctOption] && CGRectIntersectsRect(self.boundingBox, checkThis.boundingBox)
            && _waitingNext) {
            self.userInteractionEnabled = TRUE;
            _waitingNext = FALSE;
        }
    }
}

// Method to set Note Names in displays and arrays
- (void)setNoteOptions:(int)type {
    
    if (type == 0) {
        _weAreInThisNote++;
        NSArray* musicalNotes = [_musicalStaff.notesInGame copy];
        for (ReadWriteMusicalNote *deleteThis in musicalNotes) {
            if (deleteThis.parent != nil && [deleteThis.noteName isEqualToString:_selectedOption]) {
                [deleteThis touchStatus];
                // remove object
                [self removeType:0 andWithParticleEffect:deleteThis];
            }
        }
    } else {
        ReadWriteMusicalNote *failed = (ReadWriteMusicalNote *)[_musicalStaff.notesInGame objectAtIndex:_weAreInThisNote];
        [self removeType:1 andWithParticleEffect:failed];
        [[OALSimpleAudio sharedInstance] playEffect:@"Audio/fail_touched_note.wav"];
        _weAreInThisNote++;
    }
    
    // get correct noteName
    if (_weAreInThisNote < _numNotes) {
        ReadWriteMusicalNote *nowThis = (ReadWriteMusicalNote *)[_musicalStaff.notesInGame objectAtIndex:_weAreInThisNote];
        _correctOption = [NSString stringWithString:nowThis.noteName];
        
        // get other noteName
        // access to the .plist with the musical notes data
        NSArray *_notesData;
        // Choosing language
        if (_language == 0) {  // ENGLISH
            _notesData = [Language sharedData].englishNotes;
        } else {    // SPANISH
            _notesData = [Language sharedData].spanishNotes;
        }
        
        
        int rndNumber;
        NSString *otherName; NSString *thirdName; BOOL foundOther = FALSE;
        while (!foundOther) {
            rndNumber = 0 + arc4random() % (13);
            NSString *compareThis = [NSString stringWithString:[[_notesData objectAtIndex:rndNumber] objectForKey:@"noteName"]];
            if (![compareThis isEqualToString:_correctOption]) {
                otherName = [NSString stringWithString:compareThis];
                while (!foundOther) {
                    rndNumber = 0 + arc4random() % (13);
                    NSString *compareOther = [NSString stringWithString:[[_notesData objectAtIndex:rndNumber] objectForKey:@"noteName"]];
                    if (![compareOther isEqualToString:otherName] && ![compareOther isEqualToString:_correctOption]) {
                        thirdName = [NSString stringWithString:compareOther];
                        foundOther = TRUE;
                    }
                }
            }
        }

        [self randomNamePlace:otherName thirdName:thirdName];
        
    } else {
        self.userInteractionEnabled = FALSE;
        [self performSelector:@selector(endingGame) withObject:NULL afterDelay:0.8f];
    }
    
    self.userInteractionEnabled = FALSE;
    _waitingNext = TRUE;
}

// Method to set Note Names in the displays
-(void)randomNamePlace:(NSString *)otherName thirdName:(NSString*)thirdName {
    // choosing place randomly
    int rndValue = 0;
    DisplayName *changeOne, *changeTwo, *changeThree;
    if (_hidden) { // we have two options
        rndValue = arc4random() % 2;
        if (_invisibleOption == 0) {
            changeOne = (DisplayName *)[_optionsForUser objectAtIndex:1];
            changeTwo = (DisplayName *)[_optionsForUser objectAtIndex:2];
            if (rndValue == 0) {
                [changeOne setText:_correctOption]; [changeOne changeColor];
                [changeTwo setText:otherName]; [changeTwo changeColor];
            } else {
                [changeOne setText:otherName]; [changeOne changeColor];
                [changeTwo setText:_correctOption]; [changeTwo changeColor];
            }
            
        } else if (_invisibleOption == 1) {
            changeOne = (DisplayName *)[_optionsForUser objectAtIndex:0];
            changeTwo = (DisplayName *)[_optionsForUser objectAtIndex:2];
            if (rndValue == 0) {
                [changeOne setText:_correctOption]; [changeOne changeColor];
                [changeTwo setText:otherName]; [changeTwo changeColor];
            } else {
                [changeOne setText:otherName]; [changeOne changeColor];
                [changeTwo setText:_correctOption]; [changeTwo changeColor];
            }
            
        } else {
            changeOne = (DisplayName *)[_optionsForUser objectAtIndex:0];
            changeTwo = (DisplayName *)[_optionsForUser objectAtIndex:1];
            if (rndValue == 0) {
                [changeOne setText:_correctOption]; [changeOne changeColor];
                [changeTwo setText:otherName]; [changeTwo changeColor];
            } else {
                [changeOne setText:otherName]; [changeOne changeColor];
                [changeTwo setText:_correctOption]; [changeTwo changeColor];
            }
        }
        
    } else { // we have three options
        rndValue = 0 + (arc4random() % 3);
        changeOne = (DisplayName *)[_optionsForUser objectAtIndex:0];
        changeTwo = (DisplayName *)[_optionsForUser objectAtIndex:1];
        changeThree = (DisplayName *)[_optionsForUser objectAtIndex:2];
        
        if (rndValue == 0) {
            [changeOne setText:_correctOption]; [changeOne changeColor];
            [changeTwo setText:otherName]; [changeTwo changeColor];
            [changeThree setText:thirdName]; [changeThree changeColor];
            
        } else if (rndValue == 1) {
            [changeOne setText:otherName]; [changeOne changeColor];
            [changeTwo setText:_correctOption]; [changeTwo changeColor];
            [changeThree setText:thirdName]; [changeThree changeColor];
            
        } else {
            [changeOne setText:otherName]; [changeOne changeColor];
            [changeTwo setText:thirdName]; [changeTwo changeColor];
            [changeThree setText:_correctOption]; [changeThree changeColor];
        }
    }
}

// ending game
- (void)endingGame {
    NSString *message;
    if (_correctNotes >= ((_numNotes/2)+1)) {
        if (_language == 0)
            message = @"Good job!";
        else
            message = @"¡Buen trabajo!";
        [self setTotalNotes:_numNotes];
        [self setUserNotes:_correctNotes];
        [self showingScore:self.numberOfGame withText:message actualLevel:self.level userSuccess:TRUE andCurrentScore:self.score];
    } else {
        if (_language == 0)
            message = [NSString stringWithFormat:@"%@\r%@",@"You can do",@"it better!"];
        else
            message = [NSString stringWithFormat:@"%@\r%@",@"¡Puedes hacerlo",@"mejor!"];
        [self setTotalNotes:_numNotes];
        [self setUserNotes:_correctNotes];
        [self showingScore:self.numberOfGame withText:message actualLevel:self.level userSuccess:FALSE andCurrentScore:self.score];
    }
}

// for making it look good
- (void)removeType:(int)type andWithParticleEffect:(ReadWriteMusicalNote *)removeThis {
    CCParticleSystem *foundOne;
    
    if (type == 0) { // removing with particle effect
        foundOne = (CCParticleSystem *)[CCBReader load:@"LittleEfect"];
        // making it look good
        foundOne.autoRemoveOnFinish = TRUE;
        foundOne.positionType = CCPositionTypePoints;
        float x = removeThis.position.x + 20;
        float y = removeThis.position.y + 20;
        foundOne.position = ccp(x,y);
        [_musicalStaff addChild:foundOne];
    } else { // showing the name that was correct
        CCNode *pos = (CCNode *)[_musicalStaff.notesInGame objectAtIndex:_weAreInThisNote];
        CGPoint positions = [_musicalStaff convertToWorldSpace:pos.position];
        _wasThisLabel.positionInPoints = ccp(positions.x,positions.y-20);
//        _wasThisLabel.positionInPoints = ccp(pos.position.x-100,pos.position.y+110);
        _wasThisLabel.string = temporal;
        _wasThisLabel.visible = TRUE;
        _removed = TRUE;
    }

    [removeThis removeFromParent];
}

// for wasThisLabel
- (void)waitForDisappearing {
    if (self.level >= 14) {
        _waiting -= 0.2;
    } else {
        _waiting -= 0.5;
    }
    if (_waiting <= 0) {
        [self unschedule:@selector(waitForDisappearing)];
        _wasThisLabel.visible = FALSE;
        _removed = FALSE;
        _scheduled = FALSE;
    }
}

#pragma mark - SUPER SPECIAL METHODS

- (void)showSpecial {
    
    self.score -= 30;
    
    int numSpecial = (int)([[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"] - 1);
    if (numSpecial >= 0) {
        [[NSUserDefaults standardUserDefaults] setInteger:numSpecial forKey:@"specialNotes"];
    }
    
    int rndOption = 0 + arc4random() % 2;
    DisplayName *tryThis = (DisplayName *)[_optionsForUser objectAtIndex:rndOption];
    NSString *tryName = tryThis.labelText;
    if (![tryName isEqualToString:_correctOption]) {
        tryThis.visible = FALSE;
        [[OALSimpleAudio sharedInstance] playEffect:@"Audio/hideOption.wav"];
        _invisibleOption = rndOption;
        
        // making it look good
        CCParticleSystem *hideOne = (CCParticleSystem *)[CCBReader load:@"LosingLife"];
        hideOne.autoRemoveOnFinish = TRUE;
        CGPoint hidePosition = [tryThis convertToWorldSpace:tryThis.position];
        hidePosition = ccp(hidePosition.x+45, hidePosition.y+15);
        hideOne.position = [self convertToNodeSpace:hidePosition];
        hideOne.opacity = 0.0;
        [self addChild:hideOne];
        
    } else {
        [self showSpecial];
    }
    
    _specialButton.enabled = FALSE;
    _hidden = TRUE;
}

@end
