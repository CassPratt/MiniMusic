//
//  Language.h
//  MiniMusic
//
//  Created by Cassandra Pratt Romero on 11/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Language : NSObject

// properties
@property (nonatomic, assign) int language;
@property (nonatomic, strong) NSArray *startMenuLang;
@property (nonatomic, strong) NSDictionary *gameLabels;
@property (nonatomic, strong) NSArray *englishNotes;
@property (nonatomic, strong) NSArray *spanishNotes;

//Static (class) method:
+(Language*) sharedData;

@end
