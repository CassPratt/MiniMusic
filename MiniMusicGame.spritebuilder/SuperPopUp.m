
//
//  SuperPopUp.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperPopUp.h"

#pragma mark - COMPONENTS AND VARIABLES

@implementation SuperPopUp {
    CCLabelTTF *_instructionsLabel, *_totalLabel, *_correctLabel;
    CCNodeColor *_colorBackground;
    CCSprite *_backFrame;
    CCButton *_continueButton;
}

#pragma mark - INITIALIZING

// Initializing the Layer
- (id)init {
    if (self = [super init]) {
        CCLOG(@"SuperPopUp showing up!");
        _showingPopUp = TRUE;
    }
    return self;
}

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    self.scale = 1.25;
    
    if ([Language sharedData].language == 1)
        [_continueButton setTitle:@"Siguiente"];
}
-(void)onEnter {
    [super onEnter];
    if (_numberOfGame != 2) {
        _totalLabel.visible = FALSE;
        _correctLabel.visible = FALSE;
    } else _instructionsLabel.visible = FALSE;
}

#pragma mark - POPUP METHODS

// The instructions changes depending on the MiniGame
- (void)setLabelText:(NSString *)instructions {
    [_instructionsLabel setString:instructions];
}

// The background color changes depending on the MiniGame
- (void)setPopUpBackColor:(CCColor *)newColor {
    [_colorBackground setColor:newColor];
}

// The text color changes depending on the MiniGame
- (void)setLabelColor:(CCColor *)newColor {
    [_instructionsLabel setColor:newColor];
}

// changing button title
- (void)setButtonTitle:(NSString*)title {
    [_continueButton setTitle:title];
}

- (void)changeBackFrame {
    [_backFrame setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"Messages/message_exit.png"]];
}
// Setting message for RWGame
- (void)setTotalNotes:(NSString *)total andCorrectNotes:(NSString *)correct {
    if ([Language sharedData].language == 1) {
        _totalLabel.string = [NSString stringWithFormat:@"Notas totales: %@", total];
        _correctLabel.string = [NSString stringWithFormat:@"Notas correctas: %@", correct];
    } else {
        _totalLabel.string = [NSString stringWithFormat:@"%@ %@", _totalLabel.string, total];
        _correctLabel.string = [NSString stringWithFormat:@"%@ %@", _correctLabel.string, correct];
    }
}

#pragma mark - GOING TO THE NEXT LEVEL IN EACH GAME

- (void)touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event {
    [self continueMG];
}

// Removing the PopUp from the actual scene
- (void)continueMG {
    
    if (_numberOfGame == 2 || _numberOfGame == 1) {
        [[CCDirector sharedDirector] resume];
    }
    
    _continueButton.enabled = FALSE;
    switch (_numberOfGame) {

        // ***************************** PITCH GAME *******************************
            
        case 0: {
            CCScene *pitch = [CCBReader loadAsScene:@"PitchGame"];
            CCTransition *transition = [CCTransition transitionFadeWithDuration:0.6f];
            [[CCDirector sharedDirector] replaceScene:pitch withTransition:transition];
        }
            break;
            
        // ***************************** RANDOM GAME *******************************

        case 1: { // RandomGame
            CCScene *random = [CCBReader loadAsScene:@"RandomGame"];
            CCTransition *transition = [CCTransition transitionFadeWithDuration:0.6f];
            [[CCDirector sharedDirector] replaceScene:random withTransition:transition];
        }
            break;
        
        // *************************** READ-WRITE GAME *****************************
            
        case 2: { // ReadWriteGame
            if (_level != 14) {
                CCScene *readWrite = [CCBReader loadAsScene:@"ReadWriteGame"];
                CCTransition *transition = [CCTransition transitionFadeWithDuration:0.6f];
                [[CCDirector sharedDirector] replaceScene:readWrite withTransition:transition];
            } else {
                CCScene *menuScene = [CCBReader loadAsScene:@"MenuScene"];
                CCTransition *transition = [CCTransition transitionFadeWithDuration:0.4f];
                [[CCDirector sharedDirector] replaceScene:menuScene withTransition:transition];
            }
            
        }
            break;
            
        case 10:
            [self removeFromParentAndCleanup:TRUE];
            break;
        default:
            break;
    }
}

@end
