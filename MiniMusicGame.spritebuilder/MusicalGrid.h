//
//  MusicalGrid.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "PitchMusicalNote.h"
#import "NoteNameBubble.h"
#import "Language.h"

// it's better to have the musical notes in a 2D array
@interface MusicalGrid : CCSprite

@property (nonatomic, assign) int paired;
@property (nonatomic, assign) int score;
@property (nonatomic, strong) PitchMusicalNote *touchedNote;
@property (nonatomic, assign) int numberOfNotesTouched;
@property (nonatomic, assign) int grid_rows;
@property (nonatomic, assign) int grid_columns;
@property (nonatomic, assign) int pairsInGame;
@property (nonatomic, strong) NSMutableArray *gridArray;
@property (nonatomic, strong) NSMutableArray *keysArray;

@property (nonatomic, assign) BOOL showBubbleAtTouch;

- (void)settingGridRows:(int)rows andColumns:(int)columns;
- (void)showBubbles:(BOOL)show;

@end
