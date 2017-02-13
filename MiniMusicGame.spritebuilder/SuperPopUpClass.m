//
//  SuperPopUpClass.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SuperPopUpClass.h"

@implementation SuperPopUpClass {
    CCButton *_onlyOne;
}

// Initializing the SuperPopUpClass
- (id)init {
    if (self = [super init]) {
        CCLOG(@"SuperPopUpClass loaded.");
    }
    return self;
}

- (void)update:(CCTime)delta {
    if (self.parent == Nil) {
    }
}

@end
