//
//  MusicalNote.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperMusicalNoteClass.h"

@implementation SuperMusicalNoteClass {
    OALSimpleAudio *sound;
}

// Initializing the super class
- (id)init {
    if (self = [super init]) {
        _touched = FALSE;
    }
    return self;
}

// initializing with a given note name and sound file name
- (id)initWithNoteName:(NSString*)noteName andSoundFileName:(NSString *)soundFile {
    
    if (self = [super initWithImageNamed:@"PublicMusicalNotes/notaNegra.png"]) {
        
        // setting the note name and the sound file name for the MusicalNote
        [self setNoteName:noteName];
        [self setSoundFileName:soundFile];
        
        // setting the anchor point of the musical note
        [self setAnchorPoint:ccp(0, 0)];
        
        _touched = FALSE;
    }
    return self;
}

// at the beginning
- (void)onEnter {
    
    [super onEnter];
    
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // access audio object
    sound = [OALSimpleAudio sharedInstance];
}

// setting touch
- (void)touchStatus {
    if (_touched == FALSE) {
        [self setTouched:TRUE];
    } else {
        [self setTouched:FALSE];
    }
    CCLOG(@"Playing %@",_noteName);
    [sound playEffect:_soundFileName];
}

#pragma mark - AT THE END

- (void)dealloc {
    // Clean up memory allocations from sprites
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeUnusedSpriteFrames];
    [[CCDirector sharedDirector] purgeCachedData];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
}

@end
