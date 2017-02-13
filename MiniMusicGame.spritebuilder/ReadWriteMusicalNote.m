//
//  ReadWriteMusicalNote.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ReadWriteMusicalNote.h"
#import "NoteNameBubble.h"
#import "Language.h"

#pragma mark - COMPONENTS AND VARIABLES

@implementation ReadWriteMusicalNote {
    NSArray *_notesData;
    NSString *_soundFile; NSString *_name;
}

#pragma mark - INITIALIZING

// initializing the MusicalNote
- (id)initWithNumberOfNote:(int)numberOfNote optionalNoteName:(NSString *)noteName andBubble:(BOOL)showIt {
    
    // getting the soundFileName
    // Choosing language
    if ([Language sharedData].language == 0) {  // ENGLISH
        _notesData = [Language sharedData].englishNotes;
    } else {    // SPANISH
        _notesData = [Language sharedData].spanishNotes;

    }
    
    if (noteName != Nil) {
        // getting the data
        NSString *compareName;
        int thisIndex = 0;
        BOOL found = FALSE;
        while (!found && thisIndex < [_notesData count]) {
            compareName = [[_notesData objectAtIndex:thisIndex] objectForKey:@"noteName"];
            if ([compareName isEqualToString:noteName]) {
                found = TRUE;
                _soundFile = [[_notesData objectAtIndex:thisIndex] objectForKey:@"soundFileName"];
                numberOfNote = thisIndex;
            } else {
                thisIndex++;
            }
        }
        // calling the super init with the correct data
        self = [super initWithNoteName:noteName andSoundFileName:_soundFile];
        
    } else {
        
        _name = [[_notesData objectAtIndex:numberOfNote] objectForKey:@"noteName"];
        _soundFile = [[_notesData objectAtIndex:numberOfNote] objectForKey:@"soundFileName"];
        // calling the super init with the correct data
        self = [super initWithNoteName:_name andSoundFileName:_soundFile];
    }
    
    // changing the image for this MiniGame
    if (numberOfNote == 3 || numberOfNote == 6 || numberOfNote == 8 || numberOfNote == 13) {
        [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"ReadWriteSceneAssets/Sostenido.png"]];
        self.anchorPoint = ccp(0.1, 0.1);
    } else if (numberOfNote == 10) {
        [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"ReadWriteSceneAssets/Bemol.png"]];
        self.anchorPoint = ccp(0.04, 0.04);
    } else if (numberOfNote == 1) {
        [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"ReadWriteSceneAssets/DoSostenido.png"]];
        self.anchorPoint = ccp(0.1, 0.1);
    } else if (numberOfNote == 0) {
        [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"ReadWriteSceneAssets/c_note.png"]];
    } else if (numberOfNote == 14) {
        [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"ReadWriteSceneAssets/silence.png"]];
        self.anchorPoint = ccp(0.5, 0.5);
    } else {
        [self setSpriteFrame:[CCSpriteFrame frameWithImageNamed:@"ReadWriteSceneAssets/note.png"]];
    }
    
    if (showIt) {
        CGPoint forBubble;
        if (numberOfNote == 3 || numberOfNote == 6 || numberOfNote == 8 || numberOfNote == 13 || numberOfNote == 10
            || numberOfNote == 1) {
            forBubble = ccp(55, 50);
        } else if (numberOfNote == 0) {
            forBubble = ccp(45, 30);
        } else {
            forBubble = ccp(35, 30);
        }
        NoteNameBubble *bubbleThis = (NoteNameBubble *)[CCBReader load:@"NoteNameBubble"];
        [bubbleThis setLabelText:_name];
        bubbleThis.position = forBubble;
        bubbleThis.scale = 0.3;
        [self addChild:bubbleThis];
        [bubbleThis settingBubbleVisibility:showIt];
        _hasBubble = TRUE;
    } else {
        _hasBubble = FALSE;
    }
    
    return self;
}

@end
