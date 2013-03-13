//
//  ProfileEditViewController.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/9/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileItem.h"

@interface ProfileEditViewController : UIViewController
{
    __weak IBOutlet UITextField *profileName;
    __weak IBOutlet UITextField *targetPace;
    __weak IBOutlet UITextField *minuteChangeDiff;
    __weak IBOutlet UITextField *secondChangeDiff;
    __weak IBOutlet UISlider *sensitivity;
}
@property (nonatomic, strong) ProfileItem *item;

- (IBAction)saveProfile:(id)sender;

@end
