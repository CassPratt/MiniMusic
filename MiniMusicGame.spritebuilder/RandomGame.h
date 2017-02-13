//
//  RandomGame.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/2/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperMiniGameClass.h"

// Brief explanation of the MiniGame:
// Tap the musical notes of a certain color without failing
@interface RandomGame : SuperMiniGameClass <CCPhysicsCollisionDelegate>

@property (nonatomic, assign) int chosenColor;
@property (nonatomic, assign) int numberOfColorNotes;
@property (nonatomic, assign) int numberOfOtherNotes;
@property (nonatomic, assign) int numberOfLifes;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) CCTime timeForLife;

- (void)settingLevel:(int)level;

@end
