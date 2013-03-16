//
//  RunningViewController.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/15/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "RunningViewController.h"

@interface RunningViewController ()

@end

@implementation RunningViewController

@synthesize playlist;
@synthesize profile;

- (void)setPlaylist:(PlaylistItem *)p
{
    playlist = p;
    [[self navigationItem] setTitle:[playlist playlistName]];
    
}

- (void)setProfile:(ProfileItem *)p
{
    profile = p;
    [[self navigationItem] setTitle:[profile profileName]];
    
}

@end
