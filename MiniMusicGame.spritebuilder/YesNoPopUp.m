//
//  YesNoPopUp.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "YesNoPopUp.h"

@implementation YesNoPopUp {
    CCLabelTTF *_exitLabel;
    Store *_store;
    CCButton *_leftButton, *_rightButton;
}

// Initializing the Layer
- (id)init {
    if (self = [super init]) {
        CCLOG(@"YesNoPopUp showing up!");
    }
    return self;
}
- (void)didLoadFromCCB {
    self.scale = 1.25;
}
-(void)onEnter {
    [super onEnter];
    if (_numberOfGame == 20 && [[NSUserDefaults standardUserDefaults] objectForKey:@"advancedUnlocked"] == Nil) {
        _rightButton.enabled = FALSE;
    } else if (_numberOfGame == 20) {
        _rightButton.enabled = TRUE;
    }
}

// The instructions changes depending on the MiniGame
- (void)setLabelText:(NSString *)something {
    [_exitLabel setString:something];
}

// Changing the buttons' text
- (void)setTextLeftButton:(NSString *)ltext rightButton:(NSString *)rtext {
    [_leftButton setTitle:ltext];
    [_rightButton setTitle:rtext];
}

// Return to the MenuScene
- (void)leftSelection {
    if (_numberOfGame < 10) {
        if (_numberOfGame == 2 || _numberOfGame == 1) {
            [[CCDirector sharedDirector] resume];
        }
        CCLOG(@"Going to the MenuScene");
        CCScene *menu = [CCBReader loadAsScene:@"MenuScene"];
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.8f];
        [[CCDirector sharedDirector] replaceScene:menu withTransition:transition];
    } else if (_numberOfGame != 20) { // for purchases
        [self removeFromParent];
    } else { // selection of level in RW
        [GameData sharedData].rwLevel = 0;
        CCLOG(@"Going to RW MiniGame");
        CCScene *rwGame = [CCBReader loadAsScene:@"ReadWriteGame"];
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.6f];
        [[CCDirector sharedDirector] replaceScene:rwGame withTransition:transition];
    }
}

// Keep on playing the MiniGame
- (void)rightSelection {
    
    if (_numberOfGame < 10) {
        if (_numberOfGame == 2) {
            [[CCDirector sharedDirector] resume];
        }
    } else if (_numberOfGame != 20) { // for purchases
        int minusGold = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"goldenNotes"];
        if (_numberOfGame == 10) {
            // let's check how many special notes the user has
            int special = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"specialNotes"] == Nil) {
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"specialNotes"];
            }
            if (special < 20) {
                int toAdd = special + 10;
                if (toAdd > 20) {
                    [[NSUserDefaults standardUserDefaults] setInteger:20 forKey:@"specialNotes"];
                } else {
                    [[NSUserDefaults standardUserDefaults] setInteger:toAdd forKey:@"specialNotes"];
                }
                minusGold -= 1;
                [[NSUserDefaults standardUserDefaults] setInteger:minusGold forKey:@"goldenNotes"];
            }
        } else {
            minusGold -= 10;
            [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"rwUnlocked"];
        }
        [[NSUserDefaults standardUserDefaults] setInteger:minusGold forKey:@"goldenNotes"];
    } else { // selection of level in RW
        [GameData sharedData].rwLevel = 1;
        CCLOG(@"Going to RW MiniGame");
        CCScene *rwGame = [CCBReader loadAsScene:@"ReadWriteGame"];
        CCTransition *transition = [CCTransition transitionFadeWithDuration:0.6f];
        [[CCDirector sharedDirector] replaceScene:rwGame withTransition:transition];
    }
    [self removeFromParent];
}

@end
