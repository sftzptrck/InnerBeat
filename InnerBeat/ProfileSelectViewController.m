//
//  ProfileSelectViewController.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/5/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "ProfileSelectViewController.h"
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
        
        // Create a new bar button item that will send
        // addNewItem: to ItemsViewController
        /*UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(addNewItem:)];*/
        // Set this bar button item as the right item in the navigationItem
        //[[self navigationItem] setRightBarButtonItem:bbi];
        //[[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
       // NSArray *profiles = [[ProfileItemStore sharedStore] allProfiles];
        
        /*[profileTable insertRowsAtIndexPaths:profiles withRowAnimation:UITableViewRowAnimationAutomatic];*/
        
        /*[profileTable insertRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>]
        
        // Create a new BNRItem and add it to the store
        BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
        // Figure out where that item is in the array
        int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
        // Insert this new row into the table.
        [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                                withRowAnimation:UITableViewRowAnimationTop];*/
    }
    return self;
}

- (IBAction)selectProfileAndContinue:(id)sender
{
    PlaylistSelectViewController *playlistSelectViewController = [[PlaylistSelectViewController alloc] init];
    
    //NSArray *items = [[BNRItemStore sharedStore] allItems];
    //BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    // Give detail view controller a pointer to the item object in row
    //[detailViewController setItem:selectedItem];
    
    [[self navigationController] pushViewController:playlistSelectViewController
                                           animated:YES];
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
    /*if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }*/
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
    /*DetailViewController *detailViewController = [[DetailViewController alloc] init];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    // Give detail view controller a pointer to the item object in row
    [detailViewController setItem:selectedItem];
    
    [[self navigationController] pushViewController:detailViewController
                                           animated:YES];*/
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [profileTable reloadData];
    //[[self tableView] reloadData];
}

@end
