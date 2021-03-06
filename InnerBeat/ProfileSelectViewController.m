//
//  ProfileSelectViewController.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/5/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "ProfileSelectViewController.h"
#import "ProfileEditViewController.h"
#import "ProfileItemStore.h"

@interface ProfileSelectViewController ()

@end

@implementation ProfileSelectViewController

- (id)init
{
    self = [super init];
    if (self){
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Profiles"];
        
        UIImage *gradientImage44 = [[UIImage imageNamed:@"background_color.png"]
                                    resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        // Set the background image for *all* UINavigationBars
        [[UINavigationBar appearance] setBackgroundImage:gradientImage44
                                           forBarMetrics:UIBarMetricsDefault];
        
        [[UIBarButtonItem appearance] setTintColor:[UIColor colorWithRed:51.0f/255.0f green:204.0f/255.0f blue:0.0f/255.0f alpha:0.4f]];
        
        selectedRow = -1;
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (IBAction)selectProfileAndContinue:(id)sender
{
    if (selectedRow >= 0){
        PlaylistSelectViewController *playlistSelectViewController = [[PlaylistSelectViewController alloc] init];
        
        NSArray *profiles = [[ProfileItemStore sharedStore] allProfiles];
        
        ProfileItem *selectedProfile = [profiles objectAtIndex:selectedRow];
        
        // Give detail view controller a pointer to the item object in row
        [playlistSelectViewController setProfile:selectedProfile];
        
        [[self navigationController] pushViewController:playlistSelectViewController animated:YES];
    }
}

- (IBAction)newProfile:(id)sender
{
    ProfileItem *newProfile = [[ProfileItem alloc] init];
    
    ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] init];
    
    [profileEditViewController setItem:newProfile];
    
    [[self navigationController] pushViewController:profileEditViewController animated:YES];
}

- (IBAction)editProfile:(id)sender
{
    if (selectedRow >= 0){
        ProfileEditViewController *profileEditViewController = [[ProfileEditViewController alloc] init];
    
        NSArray *items = [[ProfileItemStore sharedStore] allProfiles];
    
        ProfileItem *selectedItem = [items objectAtIndex:selectedRow];
    
        // Give detail view controller a pointer to the item object in row
        [profileEditViewController setItem:selectedItem];
    
        [[self navigationController] pushViewController:profileEditViewController animated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[ProfileItemStore sharedStore] allProfiles] count];
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ProfileItemStore *ps = [ProfileItemStore sharedStore];
        NSArray *items = [ps allProfiles];
        ProfileItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeProfile:p];
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    ProfileItem *p = [[[ProfileItemStore sharedStore] allProfiles] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[p description]];
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = [indexPath row];
    ProfileItem *selectedProfile = [[[ProfileItemStore sharedStore] allProfiles] objectAtIndex:selectedRow];
    [profilePreview setText:[NSString stringWithFormat:@"Name: %@\nTarget Pace: %02d:%02d min/mi\nTime Difference Before Change: %02d:%02d", selectedProfile.profileName, selectedProfile.targetPaceMinutes, selectedProfile.targetPaceSeconds, selectedProfile.audioAllowMinutes, selectedProfile.audioAllowSeconds]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [profileTable reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (selectedRow >= 0){
        NSIndexPath *path = [NSIndexPath indexPathForRow:selectedRow inSection:0];
        [profileTable deselectRowAtIndexPath:path animated:NO];
        [profilePreview setText:@""];
    }
}

@end
