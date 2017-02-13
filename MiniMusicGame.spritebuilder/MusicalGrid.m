//
//  MusicalGrid.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MusicalGrid.h"

#pragma mark - COMPONENTS AND VARIABLES

@implementation MusicalGrid {
    NSArray *_notesData;
    float _cellWidth;
    float _cellHeight;
    NSMutableDictionary *_trackOfNotesInGame;
    NSMutableArray *_touchedNotesInGame;
    BOOL _failed;
}

#pragma mark - INITIALIZING

// initializing the CCSprite
- (id)init {
    self = [super init];FALSE;
    _showBubbleAtTouch = FALSE;
    _failed = TRUE;
    return self;
}

#pragma mark - SETTING THE MUSICAL GRID

// for setting the number of rows and columns
- (void)settingGridRows:(int)rows andColumns:(int)columns {
    
    // initializing values
    _grid_rows = rows;
    _grid_columns = columns;
    _pairsInGame = (_grid_columns * _grid_rows) / 2;
    
    // tell this class to accept touches
    self.userInteractionEnabled = TRUE;
    
    // initializing values
    _numberOfNotesTouched = 0;
    _paired = 0;
    _touchedNote = Nil;
    
    // calling the musical notes
    [self twoOfEachRandomSound];
    
    // initializing variables for the game update
    _touchedNotesInGame = [[NSMutableArray alloc] init];
}

// generating the correct amount of each random musical note
// as it is a memory game, there must be two of each one
- (void)twoOfEachRandomSound {
    
    // divide the grid's size by the number of columns/rows to figure out the right
    // and height of each cell
    _cellWidth = self.contentSize.width / _grid_columns;
    _cellHeight = self.contentSize.height / _grid_rows;
    
    float x = 0;
    float y = 0;
    
    // initialize the arrays as a blank NSMutableArray
    _gridArray = [NSMutableArray array]; // for the grid
    _keysArray = [NSMutableArray array]; // for the keys generated in the next step
    
    // initialize the dictionary as a blank NSMutableDictionary
    _trackOfNotesInGame = [NSMutableDictionary dictionary];
    
    // creating the notes for the game
    // number of notes in game
    int _numberOfNotesInGame = _pairsInGame;
    int byTwo = _numberOfNotesInGame * 2;
    
    // we choose random musical notes
    for (int m = 0; m < byTwo; m++) {
        PitchMusicalNote *note = [[PitchMusicalNote alloc] init];
        if ([_trackOfNotesInGame objectForKey:note.noteName] == Nil && _numberOfNotesInGame > 0) {
            [_trackOfNotesInGame setObject:note forKey:note.noteName];
            _numberOfNotesInGame--;
        }
    }
    
    // now we have the basic notes for the game, we need to have two of each one
    // we save the names of the notes so we can access them in the dictionary
    _keysArray = [[_trackOfNotesInGame allKeys] mutableCopy];
    
    // the method is random so it might happen that there are not enough MusicalNotes
    if ([_keysArray count] < _pairsInGame) {
        
        // access to the .plist with the musical notes data
        if ([Language sharedData].language == 0)    // ENGLISH
            _notesData = [Language sharedData].englishNotes;
        else    // SPANISH
            _notesData = [Language sharedData].spanishNotes;
        
        NSString *name, *sound;
        
        // finding the missing notes
        int counting = (int)[_keysArray count];
        int tracking = 0;
        while (counting < _pairsInGame){
            name = [[_notesData objectAtIndex:tracking] objectForKey:@"noteName"];
            sound = [[_notesData objectAtIndex:tracking] objectForKey:@"soundFileName"];
            if ([_trackOfNotesInGame objectForKey:name] == Nil) {
                PitchMusicalNote *note = [[PitchMusicalNote alloc] initWithNoteName:name andSoundFileName:sound];
                [_trackOfNotesInGame setObject:note forKey:note.noteName];
                counting++;
            }
            tracking++;
        }
        
        // Now we have the correct amount of notes
        _keysArray = [[_trackOfNotesInGame allKeys] mutableCopy];
    }
    
    // duplicating the size of the _keysArray
    int tam = (int)[_keysArray count];
    for(int i = 0 ;i < tam;i++) {
        [_keysArray addObject:[_keysArray objectAtIndex:i]];
    }
    
    // randomizing the _keysArray
    int randomIndex;
    int edge = (int)[_keysArray count] - 1;
    for (int j = 0; j < 10; j++){
        for(int i = 0; i < edge ; i++) {
            // generate a random index between the actual element and the length of the array
            randomIndex = i + arc4random() % (edge - i);
            // swapping the two elements
            [_keysArray exchangeObjectAtIndex:i withObjectAtIndex:randomIndex];
        }
    }
    
    // creating the array in which we will add the musical notes
    int weAreInThisKey = 0;

    for (int i = 0; i < _grid_rows; i++){
        _gridArray[i] = [NSMutableArray array];
        x = 0;
        
        for (int j = 0; j < _grid_columns; j++) {
            // creating new notes
            PitchMusicalNote *note = [_trackOfNotesInGame objectForKey:_keysArray[weAreInThisKey]];
            
            // the tempNote allows to add the child
            PitchMusicalNote *tempNote = [[PitchMusicalNote alloc] initWithNoteName:note.noteName andSoundFileName:note.soundFileName];
            tempNote.scale = 0.5;
            tempNote.anchorPoint = ccp(0, 0);
            tempNote.position = ccp(x, y);
            [self addChild:tempNote];
            [tempNote addBubble];
            
            weAreInThisKey++;
            _gridArray[i][j] = tempNote;
            x += _cellWidth;
        }
        y += _cellHeight;
    }
    
    [_keysArray removeAllObjects];
    
}

#pragma mark - STARTING THE GAME WITH A TOUCH

// getting the note that was touched
- (void)touchBegan:(CCTouch *)touch withEvent:(UIEvent *)event {
    //get the x,y coordinates of the touch
    CGPoint touchLocation = [touch locationInNode:self];
    _touchedNote = [self noteForTouchPosition:touchLocation];
    if (_touchedNote != Nil && _touchedNote.hasBeenTouched == TRUE) {
        if (_failed && _showBubbleAtTouch) {
            for (int i = 0; i < _grid_rows; i++) {
                for (int j = 0; j < _grid_columns; j++) {
                    PitchMusicalNote *withBubble = (PitchMusicalNote *)(_gridArray[i][j]);
                    if (withBubble.bubbleThis.visible) {
                        [withBubble.bubbleThis settingBubbleVisibility:FALSE];
                    }
                }
            }
        }
        if (_showBubbleAtTouch) { // <-- WHEN SPECIAL
            _touchedNote.bubbleThis.visible = TRUE;
        }
        [_touchedNote touchStatus];
        [_touchedNote settingTouchedImage:TRUE];
        _touchedNote.hasBeenTouched = FALSE;
    } else {
        CCLOG(@"MusicalNote already removed");
    }
}

#pragma mark - TOUCH ENDED, LET'S COMPARE THE NOTES

// checking the status of the game
- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // beginning of the game or status reset
    if (_numberOfNotesTouched == 0 && _touchedNote != Nil) {
        
        _touchedNote.hasBeenTouched = TRUE;
        [_touchedNotesInGame addObject:_touchedNote];
        _numberOfNotesTouched = 1; // one note touched
        
    } else if (_touchedNote != Nil) { // there's already a note to compare with
        PitchMusicalNote *toCompare = (PitchMusicalNote *)[_touchedNotesInGame objectAtIndex:0];
        
        // if they have the same name (no that they are the same note touched twice)
        if (toCompare != _touchedNote && toCompare.noteName == _touchedNote.noteName) {
            
            // making it look good
            CCParticleSystem *minusOne = (CCParticleSystem *)[CCBReader load:@"LittleEfect"];
            minusOne.autoRemoveOnFinish = TRUE;
            float x = toCompare.position.x + 20;
            float y = toCompare.position.y + 30;
            minusOne.position = ccp(x,y);
            [toCompare.parent addChild:minusOne];
            CCParticleSystem *minusOneCopy = (CCParticleSystem *)[CCBReader load:@"LittleEfect"];
            minusOneCopy.autoRemoveOnFinish = TRUE;
            x = _touchedNote.position.x + 20;
            y = _touchedNote.position.y + 30;
            minusOneCopy.position = ccp(x,y);
            [toCompare.parent addChild:minusOneCopy];
            
            // removing from the scene and the grid
            [self removeChild:toCompare];
            [self removeChild:_touchedNote];
            [_gridArray removeObject:toCompare];
            [_gridArray removeObject:_touchedNote];
            
            // changing note properties
            toCompare.hasBeenRemoved = TRUE;
            _touchedNote.hasBeenRemoved = TRUE;
            
            // you found one pair!
            _paired++;
            self.score += 10;
        } else if (toCompare != _touchedNote && self.score > 0) {
            self.score -= 2;
        }
        
        _failed = TRUE;
        [_touchedNote settingTouchedImage:FALSE];
        [toCompare settingTouchedImage:FALSE];
        [_touchedNotesInGame removeAllObjects];
        _numberOfNotesTouched = 0;
    }
    CCLOG(@"notes: %i",(int)_numberOfNotesTouched);
}

#pragma mark - RETURNING THE POSITION OF THE NOTES

// check the MusicalNote that was touched
- (PitchMusicalNote *)noteForTouchPosition:(CGPoint)touchPosition {
    
    //get the row and column that was touched, return the MusicalNote inside the corresponding cell
    int row = touchPosition.y / _cellHeight;
    int column = touchPosition.x / _cellWidth;

    PitchMusicalNote *_noteToSend = _gridArray[row][column];
    if (_noteToSend.hasBeenRemoved) {
        return Nil;
    } else {
        _noteToSend.hasBeenTouched = TRUE;
        return _noteToSend;
    }
}

#pragma mark - SUPER SPECIAL METHODS

// for special note
- (void)showBubbles:(BOOL)show {
    if (show) {
        for (int i = 0; i < _grid_rows; i++) {
            for (int j = 0 ; j < _grid_columns; j++) {
                PitchMusicalNote *bubbleThis = (PitchMusicalNote *)(_gridArray[i][j]);
                [bubbleThis.bubbleThis settingBubbleVisibility:TRUE];
            }
        }
    } else {
        for (int i = 0; i < _grid_rows; i++) {
            for (int j = 0 ; j < _grid_columns; j++) {
                PitchMusicalNote *bubbleThis = (PitchMusicalNote *)(_gridArray[i][j]);
                [bubbleThis.bubbleThis settingBubbleVisibility:FALSE];
            }
        }
    }
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
