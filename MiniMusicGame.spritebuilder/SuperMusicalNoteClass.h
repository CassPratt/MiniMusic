//
//  MusicalNote.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface SuperMusicalNoteClass : CCSprite

@property (nonatomic, strong) NSString *noteName;
@property (nonatomic, strong) NSString *soundFileName;
@property (nonatomic, assign) BOOL touched;

- (void)touchStatus;
- (id)initWithNoteName:(NSString*)noteName andSoundFileName:(NSString *)soundFile;

@end
