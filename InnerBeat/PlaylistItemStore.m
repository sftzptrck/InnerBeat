//
//  PlaylistItemStore.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/14/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "PlaylistItemStore.h"

@implementation PlaylistItemStore

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (PlaylistItemStore *)sharedStore
{
    static PlaylistItemStore *sharedStore = nil;
    if (!sharedStore){
        sharedStore = [[super allocWithZone:nil] init];
    }
    
    return sharedStore;
}

- (NSArray *)allPlaylists
{
    return allPlaylists;
}

- (PlaylistItem *)addPlaylist:(NSString *)name playlistPath:(NSString *)playlistPath
{
    PlaylistItem *p = [[PlaylistItem alloc] initWithPlaylistName:name playListPath:playlistPath];
    
    [allPlaylists addObject:p];
    
    return p;
}

- (int)addPlaylist:(PlaylistItem *)playlist
{
    [allPlaylists addObject:playlist];
    
    return [allPlaylists count] - 1;
}

- (void)removePlaylist:(PlaylistItem *)p
{
    [allPlaylists removeObjectIdenticalTo:p];
}

@end
