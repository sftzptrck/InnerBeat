//
//  PlaylistSelectViewController.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/5/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "PlaylistSelectViewController.h"

@interface PlaylistSelectViewController ()

@end

@implementation PlaylistSelectViewController

@synthesize item;

- (void)setItem:(ProfileItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item profileName]];
    
}

@end
