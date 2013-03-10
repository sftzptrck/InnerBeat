//
//  ProfileSelectViewController.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/5/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistSelectViewController.h"

@interface ProfileSelectViewController : UIViewController
{
    __weak IBOutlet UITableView *profileTable;
    IBOutlet UITextView *profilePreview;
}

- (IBAction)selectProfileAndContinue:(id)sender;

@end
