//
//  MusicalStaff.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "ReadWriteMusicalNote.h"
#import "GameData.h"
#import "SuperPopUp.h"
#import "Language.h"

// making it similar to the MusicalGrid class, to have control of the positions
@interface MusicalStaff : CCSprite

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int numberOfNotes;
@property (nonatomic, retain) NSMutableArray *notesInGame;
@property (nonatomic, assign) CCTime delayInMove;
@property (nonatomic, assign) CCTime durationMove;
@property (nonatomic, assign) BOOL movingFirst;

- (void)settingWithLevel:(int)level;

@end
