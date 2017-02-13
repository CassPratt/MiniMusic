//
//  GameData.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/28/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

/* SINGLETON... */

@interface GameData : NSObject

//@property (nonatomic) NSMutableDictionary* levelsData;
@property (nonatomic) int level;
@property (nonatomic) int score;
@property (nonatomic) BOOL wasSuccessful;
@property (nonatomic) int numberOfGame;
@property (nonatomic) int rwLevel;

//Static (class) method:
+(GameData*) sharedData;

@end
