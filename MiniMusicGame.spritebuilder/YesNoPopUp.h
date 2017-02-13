//
//  YesNoPopUp.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

// this is diferent from the other PopUps
#import "CCNode.h"
#import "Store.h"
#import "SuperPopUp.h"
#import "GameData.h"
#import "Language.h"

@interface YesNoPopUp : CCNode

@property (nonatomic, assign) int numberOfGame;

- (void)setLabelText:(NSString *)something;
- (void)setTextLeftButton:(NSString *)ltext rightButton:(NSString *)rtext;

@end
