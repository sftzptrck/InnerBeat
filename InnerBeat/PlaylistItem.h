//
//  PlaylistItem.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/14/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaylistItem : NSObject

- (id)initWithPlaylistName:(NSString *)name
             playListPath:(NSString *)playlistPath;

@property (nonatomic, copy) NSString *playlistName;
@property (nonatomic, copy) NSString *playlistPath;

@end
