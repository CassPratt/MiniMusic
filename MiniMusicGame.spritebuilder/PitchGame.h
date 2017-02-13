//
//  PitchGame.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperMiniGameClass.h"

// Brief explanation of the MiniGame:
// Memory Game with sounds
@interface PitchGame : SuperMiniGameClass

@property (nonatomic, assign) int countTime;
@property (nonatomic, assign) int gridRows;
@property (nonatomic, assign) int gridColumns;
@property (nonatomic, assign) BOOL showingSpecial;

- (void)settingWithLevel:(int)level NumberOfRows:(int)rows andColumns:(int)columns;

@end
