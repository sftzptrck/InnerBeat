//
//  ProfileSelectViewController.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/5/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PlaylistSelectViewController.h"

@interface ProfileSelectViewController : UIViewController
{
    __weak IBOutlet UITableView *profileTable;
    IBOutlet UITextView *profilePreview;
    IBOutlet UIButton *contButton;
    NSInteger selectedRow;
}

- (IBAction)selectProfileAndContinue:(id)sender;
- (IBAction)newProfile:(id)sender;
- (IBAction)editProfile:(id)sender;

@end
