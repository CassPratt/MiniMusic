//
//  MusicalStaff.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "MusicalStaff.h"

#pragma mark - COMPONENTS AND VARIABLES

@implementation MusicalStaff {
    NSArray *_readingLevel; // <-- ARRAY WITH THE DATA OF THE LEVEL PLIST
    NSMutableDictionary *_trackOfNotesInGame;
    float _timeSinceNote;
    int nextOne;
}

#pragma mark - INITIALIZING

- (id)init {
    if (self = [super init]) {
        _numberOfNotes = 0;
        _notesInGame = [NSMutableArray array];
        nextOne = 0.;
        _movingFirst = FALSE;
    }
    return self;
}

#pragma mark - SETTING THE GAME AND POSITION OF NOTES

// method to be called in the MiniGame
- (void)settingWithLevel:(int)level {
    
    if ([GameData sharedData].rwLevel == 0) {
        [self levelsAlreadyMade:level];
    } else {
        [self levelsGenerated:level];
    }
        
    // let's show the first note at the beginning <--- TOTALLY WRONG! FIND ANOTHER WAY TO MAKE THIS WORK, OK?
    CCNode *thisNow = [_notesInGame objectAtIndex:nextOne]; // acces to the notes
    [self addChild:thisNow];
    
    CGPoint finalPoint = ccp(10, thisNow.position.y); // final position
    // action for moving
    CCActionMoveTo *firstMovement = [CCActionMoveTo actionWithDuration:_durationMove position:finalPoint];
    [thisNow runAction:firstMovement];
    
    nextOne++; // for next note
}

// for plist levels
- (void)levelsAlreadyMade:(int)level {
    
    NSString *anotherPlist = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"level%i",level] ofType:@"plist"];
    _readingLevel = [NSArray arrayWithContentsOfFile:anotherPlist];

    // setting the delay between notes and speed of them in the musical staff
    _delayInMove = [[_readingLevel objectAtIndex:0] doubleValue];
    _durationMove = [[_readingLevel objectAtIndex:1] doubleValue];
    
    _numberOfNotes = (int)([_readingLevel count] - 2); // NUMBER OF NOTES IN THE GAME
    
    // data of the notes
    int typeOfNote = 0; BOOL showBubble = FALSE;
    // position of the notes
    float x = self.boundingBox.size.width;
    float y = 0;
    
    for (int i = 2; i < [_readingLevel count]; i++) {
        typeOfNote = [[[_readingLevel objectAtIndex:i] objectForKey:@"soundNumber"] intValue];
        showBubble = [[[_readingLevel objectAtIndex:i] objectForKey:@"bubble"] boolValue];
        
        ReadWriteMusicalNote *rwnote=[[ReadWriteMusicalNote alloc] initWithNumberOfNote:typeOfNote optionalNoteName:Nil andBubble:showBubble];
        y = [self notePosition:typeOfNote optionalNoteName:Nil];
        // for adding the note
        rwnote.position = ccp(x,y);
        
        // saving the note
        [_notesInGame addObject:rwnote];
    }
    
}

// leves generated randomly
- (void)levelsGenerated:(int)level {
    if (level <= 4) {
        _delayInMove = 1.0; _durationMove = 5.0;
    } else if (level > 4 && level <= 7) {
        _delayInMove = 1.0; _durationMove = 4.0;
    } else if (level > 7 && level <= 10) {
        _delayInMove = 1.25; _durationMove = 3.0;
    } else if (level > 10 && level <= 13) {
        _delayInMove = 1.0; _durationMove = 2.5;
    } else
        _delayInMove = 0.8; _durationMove = 2.0;
    
    _numberOfNotes = 12 + (arc4random() % 4);
    
    NSMutableArray *_keysArray = [NSMutableArray array];
    
    // generating random notes
    if ([_keysArray count] < _numberOfNotes) {
        
        // access to the .plist with the musical notes data
        if ([Language sharedData].language == 0)    // ENGLISH
            _readingLevel = [Language sharedData].englishNotes;
        else    // SPANISH
            _readingLevel = [Language sharedData].spanishNotes;
    
        NSString *name;
        
        // finding the missing notes
        int counting = (int)[_trackOfNotesInGame count];
        int tracking = 0;
        while (counting < _numberOfNotes){
            name = [[_readingLevel objectAtIndex:tracking] objectForKey:@"noteName"];
            if (![_keysArray containsObject:name]) {
                [_keysArray addObject:name];
                counting++;
            }
            tracking++;
        }
    }
    
    // position of the notes
    float x = self.boundingBox.size.width;
    float y = 0;
    
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
    
    if (level >= 15) {
        // duplicating the size of the _keysArray
        int tam = (int)[_keysArray count];
        for(int i = 0 ;i < tam;i++) {
            [_keysArray addObject:[_keysArray objectAtIndex:i]];
        }
    }
    
    _numberOfNotes = (int)[_keysArray count];
    
    for (int i = 0; i < _numberOfNotes; i++) {
        NSString *name = (NSString *)[_keysArray objectAtIndex:i];
        ReadWriteMusicalNote *addThis = [[ReadWriteMusicalNote alloc] initWithNumberOfNote:0 optionalNoteName:name andBubble:FALSE];
        y = [self notePosition:0 optionalNoteName:name];
        addThis.position = ccp(x, y);
         [_notesInGame addObject:addThis];
    }
    
}

// just for setting the position of the note in the musical staff
- (float)notePosition:(int)typeOfNote optionalNoteName:(NSString *)noteName {
    
    if (noteName != Nil) {
        // getting the data
        NSString *compareName;
        int thisIndex = 0;
        BOOL found = FALSE;
        while (!found && thisIndex < _numberOfNotes) {
            compareName = [[_readingLevel objectAtIndex:thisIndex] objectForKey:@"noteName"];
            if ([compareName isEqualToString:noteName]) {
                found = TRUE;
                typeOfNote = thisIndex;
            } else {
                thisIndex++;
            }
        }
    }
    
    float y = 0;
    switch (typeOfNote) {
        case 0: y = -50; break;
        case 1: y = -50; break;
        case 2: y = -33; break;
        case 3: y = -33; break;
        case 4: y = -15; break;
        case 5: y = 3;   break;
        case 6: y = 3;   break;
        case 7: y = 24;  break;
        case 8: y = 24;  break;
        case 9: y = 40;  break;
        case 10: y = 60; break;
        case 11: y = 60; break;
        case 12: y = 74; break;
        case 13: y = 74; break;
        case 14: y = 85; break;
        default: break;
    }
    return y;
}

#pragma mark - UPDATING THE GAME

-(void)update:(CCTime)delta {
    
    _timeSinceNote += delta;
    
    if (_timeSinceNote > _delayInMove) {
        _timeSinceNote = 0;
        
        // moving the notesInGame
        if (nextOne < _numberOfNotes) {
            
            CCNode *thisNow = [_notesInGame objectAtIndex:nextOne]; // acces to the notes
            [self addChild:thisNow];
            
            CGPoint finalPoint = ccp(10, thisNow.position.y); // final position
            // action for moving
            CCActionMoveTo *firstMovement = [CCActionMoveTo actionWithDuration:_durationMove position:finalPoint];
            firstMovement.tag = 101;
            [thisNow runAction:firstMovement];
            
            nextOne++; // for next note
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