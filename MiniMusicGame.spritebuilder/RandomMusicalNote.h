//
//  RandomMusicalNote.h
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperMusicalNoteClass.h"
#import <Foundation/Foundation.h>
#import "RandomNoteView.h"

@interface RandomMusicalNote : SuperMusicalNoteClass

@property (nonatomic, assign) int noteColor;
@property (nonatomic, strong) NSString *imageFileName;
@property (nonatomic, assign) CGPoint notePosition;
@property (nonatomic, assign) BOOL firstTimeImpulsed;
@property (nonatomic, assign) BOOL failedTouch;
@property (nonatomic, assign) BOOL scaleChanged;

- (id)initWithColor:(int)color;

@end
