//
//  ReadWriteGame.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperMiniGameClass.h"
#import "ReadWriteMusicalNote.h"


// Brief explanation of the MiniGame:
// Drag the correct notes to the musical staff
@interface ReadWriteGame : SuperMiniGameClass

@property (nonatomic, assign) int numNotes;
@property (nonatomic, assign) int correctNotes;
@property (nonatomic, strong) NSString *correctOption;
@property (nonatomic, assign) BOOL otherOctave;
@property (nonatomic, assign) int octavePlusNote;
@property (nonatomic, strong) NSString *selectedOption;
@property (nonatomic, assign) BOOL waitingNext;

- (void)settingWithLevel:(int)level;

@end
