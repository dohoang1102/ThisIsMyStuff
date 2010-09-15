//
//  MusicLabelsViewController.m
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MusicLabelsViewController.h"
#import "MusicArtistsViewController.h"

@implementation MusicLabelsViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];	
	self.navigationItem.title = @"Music by label"; 
	NSError *error;
	
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Error fetching items: %@", [error description]);
	}
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
    NSLog(@"tableView:cellForRowAtIndexPath:");
    static NSString *CellIdentifier = @"LabelCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [[fetchedResultsController objectAtIndexPath:indexPath] valueForKey:@"label"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *selectedLabel = [[fetchedResultsController objectAtIndexPath:indexPath] valueForKey:@"label"];
	MusicArtistsViewController *artistsViewController = [[MusicArtistsViewController alloc] init];
	[artistsViewController setManagedObjectContext:self.managedObjectContext];
	[artistsViewController setLabelFilter:selectedLabel];
	[self.navigationController pushViewController:artistsViewController animated:YES];
	[artistsViewController release];
}
		  
#pragma mark -
#pragma mark Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController {
	NSLog(@"fetchedResultsController");
	if (fetchedResultsController == nil) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *musicEntity = [NSEntityDescription entityForName:@"Music" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:musicEntity];
		[fetchRequest setResultType:NSDictionaryResultType];
		[fetchRequest setReturnsDistinctResults:YES];
		[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"label"]];
		
		// Sort by label.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
											initWithKey:@"label" 
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

