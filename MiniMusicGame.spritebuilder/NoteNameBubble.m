//
//  NoteNameBubble.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "NoteNameBubble.h"

@implementation NoteNameBubble {
        CCLabelTTF *_noteNameLabel;
}
    
// Initializing the Layer
- (id)init {
    if (self = [super init]) {
        CCLOG(@"Bubble showing up!");
    }
    return self;
}
    
// The instructions changes depending on the MiniGame
- (void)setLabelText:(NSString *)noteName {
    [_noteNameLabel setString:noteName];
}
    
// The text color changes depending on the MiniGame
- (void)setLabelColor:(CCColor *)newColor {
    [_noteNameLabel setColor:newColor];
}

// The font size can change...
- (void)setFontSize:(CGFloat)sizeF {
    [_noteNameLabel setFontSize:sizeF];
}

// we change the visibility
- (void)settingBubbleVisibility:(BOOL)touched {
    if (touched) {
        self.visible = TRUE;
    }
    else {
        self.visible = FALSE;
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
