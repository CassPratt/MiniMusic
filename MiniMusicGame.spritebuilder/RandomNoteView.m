//
//  RandomNoteView.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RandomNoteView.h"

@implementation RandomNoteView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)viewDidLoad {
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop)];
    [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.img == nil) {
        CGRect bounds = [self bounds];
        [[UIColor blackColor]set];
        UIRectFill(bounds);
    }else {
        CGRect bounds = [self bounds];
        [[UIColor whiteColor]set];
        UIRectFill(bounds);
        [self.img drawInRect:rect];
    }
}

@end
