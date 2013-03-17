//
//  PlaylistSelectViewController.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/5/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "PlaylistSelectViewController.h"
#import "RunningViewController.h"
#import "PlaylistItemStore.h"

@interface PlaylistSelectViewController ()

@end

@implementation PlaylistSelectViewController

@synthesize profile;

- (id)init
{
    self = [super init];
    if (self){
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Playlist"];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)setProfile:(ProfileItem *)p
{
    profile = p;
    
}

- (IBAction)selectPlaylist:(id)sender
{
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] init];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES;
    mediaPicker.prompt = @"Select songs to play";
    [self presentViewController:mediaPicker animated:YES completion:nil];
}

- (void) mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection
{
    if (mediaItemCollection){
        playlistSelection = [mediaItemCollection items];
        
        for (MPMediaItem *m in playlistSelection){
            NSString *temp = [m valueForProperty:MPMediaItemPropertyTitle];
            NSLog(@"%@", temp);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectPlaylistAndContinue:(id)sender
{
    if ([playlistSelection count] > 0){
        RunningViewController *runningViewController = [[RunningViewController alloc] init];
        
        // Give detail view controller a pointer to the item object in row
        [runningViewController setPlaylist:playlistSelection];
        [runningViewController setProfile:profile];
        
        [[self navigationController] pushViewController:runningViewController animated:YES];
    }
    
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = [indexPath row];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[PlaylistItemStore sharedStore] allPlaylists] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    ProfileItem *p = [[[PlaylistItemStore sharedStore] allPlaylists] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[p description]];
    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [playlistTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (selectedRow >= 0){
        NSIndexPath *path = [NSIndexPath indexPathForRow:selectedRow inSection:0];
        [playlistTable deselectRowAtIndexPath:path animated:NO];
    }
}


@end
