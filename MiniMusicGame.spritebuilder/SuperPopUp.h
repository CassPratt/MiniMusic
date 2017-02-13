//
//  SuperPopUp.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/15/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"
#import "PitchGame.h"
#import "RandomGame.h"
#import "GameData.h"
#import "Language.h"

@interface SuperPopUp : CCNode

@property (nonatomic, assign) int level; // <---- FOR NOW, REMOVE AFTER DOING MORE LEVELS FOR RWG
@property (nonatomic, assign) int numberOfGame;
@property (nonatomic, assign) BOOL showingPopUp;

- (void)setLabelText:(NSString*)instructions;
- (void)setButtonTitle:(NSString*)title;
- (void)setPopUpBackColor:(CCColor*)newColor;
- (void)setLabelColor:(CCColor*)newColor;
- (void)setTotalNotes:(NSString*)total andCorrectNotes:(NSString*)correct;
- (void)changeBackFrame;
- (void)continueMG;

@end
