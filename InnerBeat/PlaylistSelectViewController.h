//
//  PlaylistSelectViewController.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/5/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ProfileItem.h"

@interface PlaylistSelectViewController : UIViewController <MPMediaPickerControllerDelegate>
{
    __weak IBOutlet UITableView *playlistTable;
    NSInteger selectedRow;
    NSArray *playlistSelection;
    
}
@property (nonatomic, strong) ProfileItem *profile;

- (IBAction)selectPlaylistAndContinue:(id)sender;
- (IBAction)selectPlaylist:(id)sender;
@end
