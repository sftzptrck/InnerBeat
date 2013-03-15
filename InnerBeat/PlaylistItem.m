//
//  PlaylistItem.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/14/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "PlaylistItem.h"

@implementation PlaylistItem

@synthesize playlistName, playlistPath;

- (id)initWithPlaylistName:(NSString *)name playListPath:(NSString *)path
{
    self = [super init];
    
    if (self){
        [self setPlaylistName:name];
        [self setPlaylistPath:path];
    }
    
    return self;
}

- (NSString *)description
{
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@", playlistName];
    
    return descriptionString;
}

@end
