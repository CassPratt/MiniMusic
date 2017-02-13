//
//  RandomMusicalNote.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RandomMusicalNote.h"
#import "RandomNoteView.h"

@implementation RandomMusicalNote

// Initializing the MusicalNote
- (id)init {
    if (self = [super init]) {
        CCLOG(@"RandomMusicalNote loaded.");
        _notePosition = ccp(0, 0);
        _firstTimeImpulsed = FALSE;
        _failedTouch = FALSE;
        _scaleChanged = FALSE;
    }
    return self;
}

// Initializing according to the colorChosen in RandomGame
- (id)initWithColor:(int)color {
    
    if (self = [super initWithImageNamed:@"PublicMusicalNotes/notaNegra.png"]) {
        // the same color as the color chosen
        _noteColor = color;
        
        switch (_noteColor) {
            case 7: // red
                _imageFileName = @"PublicMusicalNotes/red_note.png";
                self.scaleX = 0.4;
                self.scaleY = 0.6;
                break;
            case 2: // orange
                _imageFileName = @"PublicMusicalNotes/orange_note.png";
                self.scale = 0.6;
                break;
            case 3: // yellow
                _imageFileName = @"PublicMusicalNotes/yellow_note.png";
                self.scaleX = 0.4;
                self.scaleY = 0.7;
                break;
            case 4: // green
                _imageFileName = @"PublicMusicalNotes/green_note_2.png";
                self.scale = 0.6;
                break;
            case 5:  // blue
                _imageFileName = @"PublicMusicalNotes/blue_note.png";
                self.scaleX = 0.4;
                self.scaleY = 0.6;
                break;
            case 6: // purple
                _imageFileName = @"PublicMusicalNotes/purple_note.png";
                self.scale = 0.6;
                break;
            case 8: // GOLDEN NOTE
                _imageFileName = @"PublicMusicalNotes/coin_note.png";
                self.scaleX = 0.4;
                self.scaleY = 0.6;
                break;
            case 9: // SPECIAL NOTE
                break;
            default:
                break;
        }
        // setting the image of the note
        [self setTexture:[CCTexture textureWithFile:_imageFileName]];
    }
    return self;
}

// let's see if it's touched, checking some things
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    self.touched = TRUE;
}

@end
