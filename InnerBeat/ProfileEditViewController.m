//
//  ProfileEditViewController.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/9/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "ProfileEditViewController.h"

@interface ProfileEditViewController ()

@end

@implementation ProfileEditViewController

@synthesize item;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [profileName setText:[item profileName]];
    [targetPace setText:[NSString stringWithFormat:@"%02d:%02d", [item targetPaceMinutes], [item targetPaceSeconds]]];
    [minuteChangeDiff setText:[NSString stringWithFormat:@"%d",[item tempoAllowMinutes]]];
    [secondChangeDiff setText:[NSString stringWithFormat:@"%d",[item tempoAllowSeconds]]];
    [sensitivity setValue:[item tempoSensitivity]];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];

}

- (void)setItem:(ProfileItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item profileName]];
    
}

-(IBAction)saveProfile:(id)sender
{
    if ([profileName.text length] == 0){
        [errorMessage setText:@"Please provide a profile name."];
        return;
    }
    
    [item setProfileName:[profileName text]];
    NSArray *targetPaceComponents = [[targetPace text] componentsSeparatedByString: @":"];
    
    int tempMinutes = [(NSString*)[targetPaceComponents objectAtIndex:0] intValue];
    int tempSeconds = 0;
    if ([targetPaceComponents count] > 1){
        tempSeconds = [(NSString*)[targetPaceComponents objectAtIndex:1] intValue];
    } 
    
    if (tempMinutes == 0 && tempSeconds == 0){
        [errorMessage setText:@"Please provide a non-zero target pace."];
        return;
    } else if (minuteChangeDiff < 0 || secondChangeDiff < 0){
        [errorMessage setText:@"Time difference must be a non-negative integer"];
        return;
    }
    
    [item setTargetPaceMinutes:tempMinutes];
    [item setTargetPaceSeconds:tempSeconds];
    
    if ([minuteChangeDiff.text rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound){
        [errorMessage setText:@"Minute difference must be a non-negative integer."];
        return;
    } else if ([secondChangeDiff.text rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location != NSNotFound){
        [errorMessage setText:@"Second difference must be a non-negative integer."];
        return;
    }
    int minChangeDiff = [[minuteChangeDiff text] intValue];
    int secChangeDiff = [[secondChangeDiff text] intValue];
    
    [item setTempoAllowMinutes:minChangeDiff];
    [item setTempoAllowSeconds:secChangeDiff];
    [item setTempoSensitivity:(int)[sensitivity value]];
    
    ProfileItemStore *profileStore = [ProfileItemStore sharedStore];
    
    if ([[profileStore allProfiles] indexOfObject:item] == NSNotFound){
        [profileStore addProfile:item];
    }
    
    [self viewWillDisappear:true];
    
    [[self navigationController] popViewControllerAnimated:YES];
}

-(IBAction)cancelProfile:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
