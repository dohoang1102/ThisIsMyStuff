//
//  MusicArtistsViewController.m
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MusicArtistsViewController.h"
#import "MusicItemViewController.h"
#import "NewMusicViewController.h"
#import "NSString+Extensions.h"

@implementation MusicArtistsViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize labelFilter;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = (self.labelFilter == nil) ? @"Music by artist" : self.labelFilter;
	
	// Add Button
	UIBarButtonItem *addNewMusicButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																					   target:self 
																					   action:@selector(pushAddMusicView:)];
	self.navigationItem.rightBarButtonItem = addNewMusicButton;
	[addNewMusicButton release];

	// Get the music items by artist.
	NSError *error;
	if(![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Error fetching items: %@", [error description]);
	}
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Add Item
- (void)pushAddMusicView:(id)sender {
	NewMusicViewController *newMusicViewController = [[NewMusicViewController alloc] init];
	newMusicViewController.managedObjectContext = self.managedObjectContext;
	newMusicViewController.itemLabel = self.labelFilter;
	[self presentModalViewController:newMusicViewController animated:YES];
	[newMusicViewController release];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger count = [[fetchedResultsController sections] count];
	if (count == 0) {
		count = 1;
	}
	return count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger numberOfRows = 0;
	if ([[fetchedResultsController sections] count] > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
		numberOfRows = [sectionInfo numberOfObjects];
	}
	return numberOfRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ArtistsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
    cell.textLabel.text = [[fetchedResultsController objectAtIndexPath:indexPath] valueForKey:@"artist"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *artistFilter = [[fetchedResultsController objectAtIndexPath:indexPath] valueForKey:@"artist"];
	
	MusicItemViewController *itemViewController = [[MusicItemViewController alloc] init];
	[itemViewController setManagedObjectContext:self.managedObjectContext];
	itemViewController.artistFilter = artistFilter;
	[self.navigationController pushViewController:itemViewController animated:YES];
	[itemViewController release];
}

#pragma mark -
#pragma mark Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController == nil) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *musicEntity = [NSEntityDescription entityForName:@"Music" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:musicEntity];
		[fetchRequest setResultType:NSDictionaryResultType];
		[fetchRequest setReturnsDistinctResults:YES];
		[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"artist"]];
		
		// Filter by label if necessary.
		if (self.labelFilter != nil) {
			NSPredicate *labelPredicate = [NSPredicate predicateWithFormat:@"label = %@", self.labelFilter];
			[fetchRequest setPredicate:labelPredicate];
		}
		
		// Sort by artist
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
											initWithKey:@"artist" 
											ascending:YES
											selector:@selector(localizedCaseInsensitiveCompare:)];
		NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
		[fetchRequest setSortDescriptors:sortDescriptors];
		
		NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]
																 initWithFetchRequest:fetchRequest 
																 managedObjectContext:managedObjectContext 
																 sectionNameKeyPath:nil 
																 cacheName:nil];
		aFetchedResultsController.delegate = self;
		self.fetchedResultsController = aFetchedResultsController;
		
		[aFetchedResultsController release];
		[fetchRequest release];
		[sortDescriptor release];
		[sortDescriptors release];
	}
	return fetchedResultsController;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

