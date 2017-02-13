//
//  DisplayName.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 8/6/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

@interface DisplayName : CCSprite

@property (nonatomic, retain) NSString *labelText;

- (void)setText:(NSString *)noteName;
- (void)changeColor;

@end
