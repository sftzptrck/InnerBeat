//
//  PlaylistSelectViewController.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/5/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileItem.h"

@interface PlaylistSelectViewController : UIViewController
{
    __weak IBOutlet UITableView *playlistTable;
    NSInteger selectedRow;
}
@property (nonatomic, strong) ProfileItem *profile;

- (IBAction)selectPlaylistAndContinue:(id)sender;
@end
