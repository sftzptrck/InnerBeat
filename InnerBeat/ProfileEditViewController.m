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
    [targetPace setText:[NSString stringWithFormat:@"%d:%d", [item targetPaceMinutes], [item targetPaceSeconds]]];
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
    [self viewWillDisappear:true];
    
    [item setProfileName:[profileName text]];
    NSArray *targetPaceComponents = [[targetPace text] componentsSeparatedByString: @":"];
    
    int tempMinutes = [(NSString*)[targetPaceComponents objectAtIndex:0] intValue];
    int tempSeconds = [(NSString*)[targetPaceComponents objectAtIndex:1] intValue];
    
    [item setTargetPaceMinutes:tempMinutes];
    [item setTargetPaceSeconds:tempSeconds];
    [item setTempoAllowMinutes:[[minuteChangeDiff text] intValue]];
    [item setTempoAllowSeconds:[[secondChangeDiff text] intValue]];
    [item setTempoSensitivity:(int)[sensitivity value]];
    
    ProfileItemStore *profileStore = [ProfileItemStore sharedStore];
    
    if ([[profileStore allProfiles] indexOfObject:item] == NSNotFound){
        [profileStore addProfile:item];
    }
    
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
