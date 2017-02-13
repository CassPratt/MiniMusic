//
//  Store.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Store.h"
#import "YesNoPopUp.h"
#import "SuperPopUp.h"
#import "GameData.h"
#import "Language.h"

#pragma mark - COMPONENTS AND VARIABLES

@implementation Store {
    CCLabelTTF *_earnedLabel, *_specialLabel; // GOLDEN-SPECIAL NOTES
    CCSprite *_specialSprite;
    CCButton *_readWriteButton, *_specialButton;
    NSMutableArray *_buttons;
    YesNoPopUp *_purchasePopUp;
    int _golden, _special, _language;
}

#pragma mark - INITIALIZING

- (id)init {
    self = [super init];
    return self;
    _buttonsEnabled = FALSE;
}

- (void)didLoadFromCCB {
    
    _buttons = [NSMutableArray array];
    [_buttons addObject:_readWriteButton]; [_buttons addObject:_specialButton];
    
    _language = [Language sharedData].language;
    [self checkLanguage:_language];
    [self updateLabels];
    
    _specialButton.enabled = TRUE;
    
    if (_golden < 1 || (_golden >= 1 && [[NSUserDefaults standardUserDefaults] objectForKey:@"specialUnlocked"] == Nil)) {
        _specialButton.enabled = FALSE;
        _specialLabel.visible = FALSE;
        _specialSprite.visible = FALSE;
    }
    if (_golden < 10) {
        _readWriteButton.enabled = FALSE;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"rwUnlocked"] != Nil) {
        _readWriteButton.visible = FALSE;
    }
}

- (void)checkLanguage:(int)language {
    if (language == 1) {
        // Special notes button
        [_specialButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"StoreAssets/special_purchase_spanish.png"]
                                      forState:CCControlStateNormal];
        [_specialButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"StoreAssets/special_purchase_spanish.png"]
                                      forState:CCControlStateHighlighted];
        [_specialButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"StoreAssets/special_purchase_spanish.png"]
                                      forState:CCControlStateDisabled];
        [_specialButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"StoreAssets/special_purchase_spanish.png"]
                                      forState:CCControlStateSelected];
        // RWGame button
        [_readWriteButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"StoreAssets/readWrite_purchase_spanish.png"]
                                        forState:CCControlStateNormal];
        [_readWriteButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"StoreAssets/readWrite_purchase_spanish.png"]
                                      forState:CCControlStateHighlighted];
        [_readWriteButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"StoreAssets/readWrite_purchase_spanish.png"]
                                      forState:CCControlStateDisabled];
        [_readWriteButton setBackgroundSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"StoreAssets/readWrite_purchase_spanish.png"]
                                      forState:CCControlStateSelected];
    }
}

#pragma mark - GENERAL METHODS

- (void)updateLabels {
    // getting the number of golden notes
    _golden = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"goldenNotes"];
    _earnedLabel.string = [NSString stringWithFormat:@"x %i", _golden];
    _special = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"specialNotes"];
    _specialLabel.string = [NSString stringWithFormat:@"x %i", _special];;
}

// dealing with buttons
- (void)disableButtons {
    for (int i = 0; i < [_buttons count]; i++) {
        CCButton *thisButton = (CCButton *)[_buttons objectAtIndex:i];
        if (thisButton != Nil) {
            thisButton.enabled = FALSE;
        }
    }
    _buttonsEnabled = FALSE;
}

#pragma mark - UPDATING THE STORE

- (void)update:(CCTime)delta {
    [self updateLabels];

    if (![self getChildByName:@"_purchasePopUp" recursively:TRUE] && !_buttonsEnabled) {
        _buttonsEnabled = TRUE;
    }
    if (_buttonsEnabled) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"specialUnlocked"] != Nil) {
            _specialButton.enabled = TRUE;
        }
        if (_readWriteButton != Nil && _golden >= 10) {
            _readWriteButton.enabled = TRUE;
        }
        _buttonsEnabled = FALSE;
    }
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"rwUnlocked"]) {
        [_readWriteButton removeFromParent];
    }
    
    if (_golden < 1) {
        _specialButton.enabled = FALSE;
    }
    
    if ([self getChildByName:@"limit" recursively:TRUE] != Nil) {
        self.userInteractionEnabled = FALSE;
    }
}

#pragma mark - PURCHASING METHODS

- (void)hideInfo {
    CCLOG(@"Going to MenuScene");
    CCScene *menu = [CCBReader loadAsScene:@"MenuScene"];
    CCTransition *transition = [CCTransition transitionFadeWithDuration:0.4f];
    [[CCDirector sharedDirector] replaceScene:menu withTransition:transition];
}

// for special musical notes
- (void)specialPurchase {
    [self disableButtons];
    
    if (_special == 20) {
        // user can't have more than 20 special notes
        SuperPopUp *_superPopUp = (SuperPopUp *)[CCBReader load:@"InstructionsPopUp"];
        // position
        _superPopUp.positionType = CCPositionTypeNormalized;
        _superPopUp.position = ccp(0.5, 0.5);
        if (_language == 0) {
            [_superPopUp setLabelText:[NSString stringWithFormat:@"%@\r%@", @"You can only",@"have 20!"]];
            [_superPopUp changeBackFrame];
        } else {
            [_superPopUp setLabelText:[NSString stringWithFormat:@"%@\r%@", @"¡Sólo puedes",@"tener 20!"]];
            [_superPopUp changeBackFrame];
        }
        
        // info for the MiniGame
        _superPopUp.numberOfGame = 10;
        _superPopUp.name = @"_purchasePopUp";
        // adding the PopUp
        [self addChild:_superPopUp];
    } else {
        _purchasePopUp = (YesNoPopUp *)[CCBReader load:@"YesNoPopUp"];
        // still need to deal with pauses
        _purchasePopUp.numberOfGame = 10;
        _purchasePopUp.positionType = CCPositionTypeNormalized;
        _purchasePopUp.position = ccp(0.5, 0.5);
        if (_language == 0) {
            [_purchasePopUp setLabelText:[NSString stringWithFormat:@"%@\r%@", @"Purchase for",@"1 Gold?"]];
            _purchasePopUp.name = @"_purchasePopUp";
        } else {
            [_purchasePopUp setLabelText:[NSString stringWithFormat:@"%@\r%@", @"¿Comprar por",@"1 Oro?"]];
            _purchasePopUp.name = @"_purchasePopUp";
            [_purchasePopUp setTextLeftButton:@"No" rightButton:@"Sí"];
        }
        
        [self addChild:_purchasePopUp];
    }    
}

// for the ReadWrite MiniGame
- (void)readWritePurchase {
    [self disableButtons];
    
    _purchasePopUp = (YesNoPopUp *)[CCBReader load:@"YesNoPopUp"];
    // still need to deal with pauses
    _purchasePopUp.numberOfGame = 11;
    _purchasePopUp.positionType = CCPositionTypeNormalized;
    _purchasePopUp.position = ccp(0.5, 0.5);
    if (_language == 0) {
        [_purchasePopUp setLabelText:[NSString stringWithFormat:@"%@\r%@", @"Purchase for",@"10 Gold?"]];
        _purchasePopUp.name = @"_purchasePopUp";
    } else {
        [_purchasePopUp setLabelText:[NSString stringWithFormat:@"%@\r%@", @"¿Comprar por",@"10 Oros?"]];
        _purchasePopUp.name = @"_purchasePopUp";
        [_purchasePopUp setTextLeftButton:@"No" rightButton:@"Sí"];
    }
    
    [self addChild:_purchasePopUp];
}

- (void)dealloc {
    // Clean up memory allocations from sprites
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
}

@end
