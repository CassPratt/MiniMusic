//
//  PitchMusicalNote.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperMusicalNoteClass.h"
#import "NoteNameBubble.h"

@interface PitchMusicalNote : SuperMusicalNoteClass

@property (nonatomic, assign) BOOL hasBeenRemoved;
@property (nonatomic, assign) BOOL hasBeenTouched;
@property (nonatomic, strong) NoteNameBubble *bubbleThis;
@property (nonatomic, assign) BOOL specialChange;
@property (nonatomic, strong) NSString *imageChange;
@property (nonatomic, strong) NSString *imageLight;

- (void)settingTouchedImage:(BOOL)touched;
- (void)addBubble;
- (void)chooseRandomImage;
- (void)pairRandomImage;

@end
