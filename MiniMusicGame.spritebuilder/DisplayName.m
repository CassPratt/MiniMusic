//
//  DisplayName.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 8/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "DisplayName.h"

#pragma mark - COMPONENTS AND VARIABLES

@implementation DisplayName {
    CCLabelTTF *_nameLabel; // Changes depending the note
}

#pragma mark - INITIALIZING

- (id)init {
    self = [super init];
    return self;
}

- (void)didLoadFromCCB {
    
    self.userInteractionEnabled = TRUE;

    // random color
    [self changeColor];
}

#pragma mark - METHODS FOR SETTING THE NODE

- (void)setText:(NSString *)noteName {
    _nameLabel.string = noteName;
    _labelText = [NSString stringWithString:noteName];
}

- (void)changeColor {
    // choosing backColor's color randomly
    int rndValue = 0 + arc4random() % (5);
    switch (rndValue) {
        case 0:
            [self setTexture:[CCTexture textureWithFile:@"ReadWriteSceneAssets/blue_one.png"]];
            break;
        case 1:
            [self setTexture:[CCTexture textureWithFile:@"ReadWriteSceneAssets/red_one.png"]];
            break;
        case 2:
            [self setTexture:[CCTexture textureWithFile:@"ReadWriteSceneAssets/green_one.png"]];
            break;
        case 3:
            [self setTexture:[CCTexture textureWithFile:@"ReadWriteSceneAssets/purple_one.png"]];
            break;
        case 4:
            [self setTexture:[CCTexture textureWithFile:@"ReadWriteSceneAssets/violet_one.png"]];
            break;
        case 5:
            [self setTexture:[CCTexture textureWithFile:@"ReadWriteSceneAssets/green_one_two.png"]];
            break;
        default:
            break;
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
