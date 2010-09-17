//
//  MusicItemViewController.m
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 07/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MusicItemViewController.h"
#import "NewMusicViewController.h"
#import "MusicItemDetailsViewController.h"


@implementation MusicItemViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize artistFilter;
@synthesize labelFilter;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = self.artistFilter;
	
	// Add Button
	UIBarButtonItem *addNewMusicButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd 
																					   target:self 
																					   action:@selector(pushAddMusicView:)];
	self.navigationItem.rightBarButtonItem = addNewMusicButton;
	[addNewMusicButton release];
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Error fetching items: %@", [error description]);
	}
}


#pragma mark -
#pragma mark Add Item
- (void)pushAddMusicView:(id)sender {
	NewMusicViewController *newMusicViewController = [[NewMusicViewController alloc] init];
	newMusicViewController.managedObjectContext = self.managedObjectContext;
	newMusicViewController.itemArtist = self.artistFilter;
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
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.textLabel.text = [[fetchedResultsController objectAtIndexPath:indexPath] valueForKey:@"title"];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentTitle = [[fetchedResultsController objectAtIndexPath:indexPath] valueForKey:@"title"];
	MusicItemDetailsViewController *detailViewController = [[MusicItemDetailsViewController alloc] init];
    detailViewController.managedObjectContext = self.managedObjectContext;
    detailViewController.labelFilter = self.labelFilter;
    detailViewController.artistFilter = self.artistFilter;
    detailViewController.titleFilter = currentTitle;
   	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];	
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
		[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"title"]];
		
		
		NSMutableArray *subpredicates = [NSMutableArray arrayWithCapacity:2];
		if (self.labelFilter != nil) {
			[subpredicates addObject:[NSPredicate predicateWithFormat:@"label = %@", self.labelFilter]];
		}
		
		if (self.artistFilter != nil) {
			[subpredicates addObject:[NSPredicate predicateWithFormat:@"artist = %@", self.artistFilter]];
		}
		
		NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
		if ([subpredicates count] > 0) {
			NSLog(@"Predicate is %@", [predicate description]);
			[fetchRequest setPredicate:predicate];			
		}
		
		// Sort by title.
		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
											initWithKey:@"title" 
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

