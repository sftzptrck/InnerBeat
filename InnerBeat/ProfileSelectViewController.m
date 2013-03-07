//
//  ProfileSelectViewController.m
//  InnerBeat
//
//  Created by Shawn Fitzpatrick on 3/5/13.
//  Copyright (c) 2013 Shawn Fitzpatrick. All rights reserved.
//

#import "ProfileSelectViewController.h"

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
        
        
        [profileTable insertRowsAtIndexPaths:<#(NSArray *)#> withRowAnimation:<#(UITableViewRowAnimation)#>]
        
        // Create a new BNRItem and add it to the store
        BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
        // Figure out where that item is in the array
        int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
        // Insert this new row into the table.
        [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip]
                                withRowAnimation:UITableViewRowAnimationTop];
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

@end
