//
//  RunningViewController.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/15/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistItem.h"
#import "ProfileItem.h"

@interface RunningViewController : UIViewController
{
    
}
@property (nonatomic, strong) PlaylistItem *playlist;
@property (nonatomic, strong) ProfileItem *profile;

@end
