//
//  ProfileEditViewController.h
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/9/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileItem.h"
#import "ProfileItemStore.h"

@interface ProfileEditViewController : UIViewController
{
    __weak IBOutlet UITextField *profileName;
    __weak IBOutlet UITextField *targetPace;
    __weak IBOutlet UITextField *minuteChangeDiff;
    __weak IBOutlet UITextField *secondChangeDiff;
    __weak IBOutlet UISlider *sensitivity;
    __weak IBOutlet UISwitch *tempoChangeOn;
    __weak IBOutlet UISwitch *pitchChangeOn;
    IBOutlet UILabel *errorMessage;
}
@property (nonatomic, strong) ProfileItem *item;

- (IBAction)saveProfile:(id)sender;
- (IBAction)cancelProfile:(id)sender;

@end
