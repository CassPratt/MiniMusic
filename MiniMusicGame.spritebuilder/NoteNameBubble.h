//
//  NoteNameBubble.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface NoteNameBubble : CCNode

@property (nonatomic, assign) BOOL hasBeenRemoved;
@property (nonatomic, assign) BOOL hasBeenTouched;

- (void)setLabelText:(NSString *)noteName;
- (void)setLabelColor:(CCColor *)newColor;
- (void)setFontSize:(CGFloat)sizeF;
- (void)settingBubbleVisibility:(BOOL)touched;

@end
