//
//  ReadWriteMusicalNote.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperMusicalNoteClass.h"

@interface ReadWriteMusicalNote : SuperMusicalNoteClass

@property (nonatomic, assign) BOOL hasBubble;

- (id)initWithNumberOfNote:(int)numberOfNote optionalNoteName:(NSString *)noteName andBubble:(BOOL)showIt;

@end
