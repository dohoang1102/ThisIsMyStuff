//
//  MusicRootViewController.m
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MusicRootViewController.h"

@implementation MusicRootViewController

@synthesize tableItems;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize theTableView;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
								  target:self 
								  action:@selector(pushAddMusicView:)];
	self.navigationItem.rightBarButtonItem = addButton;
	self.navigationItem.title = @"Music";
	
	self.tableItems = [NSArray arrayWithObjects:@"Artist", @"Label", @"Title", @"Format", nil];
	
	[addButton release];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Add Item
- (void)pushAddMusicView:(id)sender {
	NewMusicViewController *newMusicViewController = [[NewMusicViewController alloc] init];
	newMusicViewController.managedObjectContext = self.managedObjectContext;
	NSLog(@"Passing in %@", [self description]);
	newMusicViewController.caller = self;
	[self presentModalViewController:newMusicViewController animated:YES];
	[newMusicViewController release];
}

- (void)reloadTableData {
	NSLog(@"Reloading data!");
	[theTableView reloadData];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.tableItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MusicRootCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.textLabel.text = [self.tableItems objectAtIndex:[indexPath row]];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	switch ([indexPath row]) {
		case kArtistRow: {
			MusicArtistsViewController *artistsViewController = [[MusicArtistsViewController alloc] init];
			[artistsViewController setManagedObjectContext:self.managedObjectContext];
			[self.navigationController pushViewController:artistsViewController animated:YES];
			[artistsViewController release];
		}
			break;
		case kLabelRow: {
			MusicLabelsViewController *labelsViewController = [[MusicLabelsViewController alloc] init];
			[labelsViewController setManagedObjectContext:self.managedObjectContext];
			[self.navigationController pushViewController:labelsViewController animated:YES];
			[labelsViewController release];
		}
		case kTitleRow: {
			MusicItemViewController *itemViewController = [[MusicItemViewController alloc] init];
			[itemViewController setManagedObjectContext:self.managedObjectContext];
			[self.navigationController pushViewController:itemViewController animated:YES];
			[itemViewController release];
		}
			break;
		default:
			break;
	}
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.tableItems = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

