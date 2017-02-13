//
//  SuperMiniGameClass.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScene.h"

@interface SuperMiniGameClass : CCScene

@property (nonatomic, assign) int numberOfGame;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) BOOL showingInstPopUp;
@property (nonatomic, assign) BOOL showingScore;
@property (nonatomic, assign) BOOL started;
@property (nonatomic, assign) BOOL gamePaused;
@property (nonatomic, assign) int totalNotes;
@property (nonatomic, assign) int userNotes;

- (void)miniGameSceneOnTop;
- (void)instructionsPopUpGoingUp;
- (void)showingInstructions:(NSString*)instructions NumberOfGame:(int)game;
- (void)showingScore:(int)typeOfPopUp withText:(NSString*)labelText actualLevel:(int)level userSuccess:(BOOL)success andCurrentScore:(int)score;

@end
