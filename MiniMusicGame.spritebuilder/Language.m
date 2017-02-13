//
//  Language.m
//  MiniMusic
//
//  Created by Cassandra Pratt Romero on 11/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Language.h"

@implementation Language

static Language *sharedData = nil;

+(Language*) sharedData
{
    //If our singleton instance has not been created (first time it is being accessed)
    if(sharedData == nil)
    {
        //create our singleton instance for Languages
        sharedData = [[Language alloc] init];
        
        //collections (Sets, Dictionaries, Arrays) must be initialized
        NSString *plist;
        plist = [[NSBundle mainBundle] pathForResource:@"englishNotes" ofType:@"plist"];
        sharedData.englishNotes = [NSArray arrayWithContentsOfFile:plist];
        plist = [[NSBundle mainBundle] pathForResource:@"spanishNotes" ofType:@"plist"];
        sharedData.spanishNotes = [NSArray arrayWithContentsOfFile:plist];
        plist = [[NSBundle mainBundle] pathForResource:@"startMenuLang" ofType:@"plist"];
        sharedData.startMenuLang = [NSArray arrayWithContentsOfFile:plist];
    }
    //if the singleton instance is already created, return it
    return sharedData;
}

@end
