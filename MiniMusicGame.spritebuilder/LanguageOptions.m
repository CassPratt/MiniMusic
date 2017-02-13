//
//  LanguageOptions.m
//  MiniMusic
//
//  Created by Cassandra Pratt Romero on 11/17/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LanguageOptions.h"

@implementation LanguageOptions {
    CCButton *_engButton, *_spaButton;
    int _language;
}

- (id)init {
    self = [super init];
    NSLog(@"LanguagePopUp showing up!");
    _language = [Language sharedData].language;
    return self;
}

- (void)didLoadFromCCB {
    [self checkLanguage];
    self.scale = 1.25;
}

- (void)update:(CCTime)delta {
    [self checkLanguage];
}

- (void)checkLanguage {
    if (_language == 0) {
        _engButton.selected = TRUE;
        _spaButton.selected = FALSE;
    } else {
        _engButton.selected = FALSE;
        _spaButton.selected = TRUE;
    }
}

#pragma mark LANGUAGE OPTIONS
- (void)chooseEnglish {
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"language"];
    [Language sharedData].language = _language = 0;
}
- (void)chooseSpanish {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"language"];
    [Language sharedData].language = _language = 1;
}

@end
