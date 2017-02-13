//
//  ButtonMethods.m
//  MiniMusicGame
//
//  Created by Cassandra Pratt Romero on 7/7/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ButtonMethods.h"

@implementation ButtonMethods {
    CCButton *_backButton;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

// Checks the PopUp status
- (void)update:(CCTime)delta {
    if ([self children].count > 1) {
        _backButton.visible = FALSE;
    } else {
        _backButton.visible = TRUE;
    }
}

@end
