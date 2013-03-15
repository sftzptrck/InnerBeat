//
//  PlaylistItemStore.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/14/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlaylistItem.h"

@interface PlaylistItemStore : NSObject
{
    NSMutableArray *allPlaylists;
}

+ (PlaylistItemStore *)sharedStore;

- (NSArray *)allPlaylists;
- (PlaylistItem *)addPlaylist:(NSString *)name
                 playlistPath:(NSString *)playlistPath;
- (int)addPlaylist:(PlaylistItem *)playlist;
- (void)removePlaylist:(PlaylistItem *)p;

@end
