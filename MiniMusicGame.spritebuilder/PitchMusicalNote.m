//
//  PitchMusicalNote.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PitchMusicalNote.h"
#import "NoteNameBubble.h"
#import "Language.h"

@implementation PitchMusicalNote {
    int _rndValue;
    NSArray *_notesData;
}

// initializing with a random musical note

- (id)init {
    
    if (self = [super initWithImageNamed:@"PublicMusicalNotes/notaNegra.png"]) {
        
        self.scale = 0.5;
        
        // Choosing language
        if ([Language sharedData].language == 0) {  // ENGLISH
            _notesData = [Language sharedData].englishNotes;
        } else {    // SPANISH
            _notesData = [Language sharedData].spanishNotes;
        }
           
        // choosing a random musical note sound when it is initialized
        // the Audio folder contains the sounds
        _rndValue = 0 + arc4random() % (13);
        [self setNoteName:[[_notesData objectAtIndex:_rndValue] objectForKey:@"noteName"]];
        [self setSoundFileName:[[_notesData objectAtIndex:_rndValue] objectForKey:@"soundFileName"]];
        
        // setting the anchor point of the musical note
        [self setAnchorPoint:ccp(0, 0)];
        
        _specialChange = FALSE;
    }
    return self;
}

- (void)addBubble {
    // initialized with bubble but it's invisible
    _bubbleThis = (NoteNameBubble *)[CCBReader load:@"NoteNameBubble"];
    [_bubbleThis setLabelText:self.noteName];
    if (_rndValue == 13) {
        [_bubbleThis setFontSize:15];
    }
    if ([Language sharedData].language == 1) {
        if (_rndValue == 1 || _rndValue == 3 || _rndValue == 6 || _rndValue == 8 || _rndValue == 12 || _rndValue == 13)
            [_bubbleThis setFontSize:60];
        else
            [_bubbleThis setFontSize:62];
    }
    
    CGPoint effectPosition = [self.parent convertToWorldSpace:self.positionInPoints];
    effectPosition = ccp(effectPosition.x+25, effectPosition.y+35);
    _bubbleThis.positionType = CCPositionTypePoints;
    _bubbleThis.position = [self convertToNodeSpace:effectPosition];
    
    _bubbleThis.scale = 0.4;
    [self addChild:_bubbleThis];
    [_bubbleThis settingBubbleVisibility:FALSE];
}

#pragma mark - PITCH NOTE METHODS

// we change the image so the user recognize the MusicalNote he touched
- (void)settingTouchedImage:(BOOL)touched {
    if (!_specialChange) { // normal game
       if (touched == TRUE) {
           [self setTexture:[CCTexture textureWithFile:@"PublicMusicalNotes/notaNegrailu2.png"]];
           self.scale = 0.5;
       }
       else {
           [self setTexture:[CCTexture textureWithFile:@"PublicMusicalNotes/notaNegra.png"]];
       }
    } else { // special methods
        if (touched == TRUE) {
            [self setTexture:[CCTexture textureWithFile:_imageLight]];
        }
        else {
            [self setTexture:[CCTexture textureWithFile:_imageChange]];
        }
    }
    
}

#pragma mark - SPECIAL METHODS

- (void)chooseRandomImage {
    int rndImage = 0 + arc4random() % 2;
    if (rndImage == 0) {
        [self setTexture:[CCTexture textureWithFile:@"PublicMusicalNotes/blue_note_scaled.png"]];
        _imageChange = @"PublicMusicalNotes/blue_note_scaled.png";
        _imageLight = @"PublicMusicalNotes/blue_note_ilu.png";
    } else if (rndImage == 1) {
        [self setTexture:[CCTexture textureWithFile:@"PublicMusicalNotes/red_note_scaled.png"]];
        _imageChange = @"PublicMusicalNotes/red_note_scaled.png";
        _imageLight = @"PublicMusicalNotes/red_note_ilu.png";
    } else {
        [self setTexture:[CCTexture textureWithFile:@"PublicMusicalNotes/violet_note_scaled.png"]];
        _imageChange = @"PublicMusicalNotes/violet_note_scaled.png";
        _imageLight = @"PublicMusicalNotes/violet_note_ilu.png";
    }
    self.scale = 0.5;
    _specialChange = TRUE;
}

- (void)pairRandomImage {
    [self setTexture:[CCTexture textureWithFile:_imageChange]];
    if ([_imageChange isEqualToString:@"PublicMusicalNotes/blue_note_scaled.png"]) {
        _imageLight = @"PublicMusicalNotes/blue_note_ilu.png";
    } else if ([_imageChange isEqualToString:@"PublicMusicalNotes/red_note_scaled.png"]) {
        _imageLight = @"PublicMusicalNotes/red_note_ilu.png";
    } else {
        _imageLight = @"PublicMusicalNotes/violet_note_ilu.png";
    }
    self.scale = 0.5;
    _specialChange = TRUE;
}

@end
