//
//  MusicItemDetailsViewController.m
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 17/09/2010.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import "MusicItemDetailsViewController.h"


@implementation MusicItemDetailsViewController

@synthesize detailsTableView;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize artistFilter;
@synthesize labelFilter;
@synthesize titleFilter;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationItem.title = self.titleFilter;
	
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		NSLog(@"Error fetching item: %@", [error description]);
	}
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (NSInteger) tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 0;
	if ([[fetchedResultsController sections] count] > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
		numberOfRows = [sectionInfo numberOfObjects];
	}
	NSLog(@"Number of rows in details section is %d", numberOfRows);
	return numberOfRows;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ItemDetailsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	cell.textLabel.text = [[fetchedResultsController objectAtIndexPath:indexPath] valueForKey:@"format"];
    return cell;
}

#pragma mark -
#pragma mark Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController {
	if (fetchedResultsController == nil) {
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		NSEntityDescription *musicEntity = [NSEntityDescription entityForName:@"Music" inManagedObjectContext:managedObjectContext];
		[fetchRequest setEntity:musicEntity];
		[fetchRequest setResultType:NSDictionaryResultType];
		[fetchRequest setPropertiesToFetch:[NSArray arrayWithObject:@"format"]];
		
		
		NSMutableArray *subpredicates = [NSMutableArray arrayWithCapacity:3];
		if (self.labelFilter != nil) {
			[subpredicates addObject:[NSPredicate predicateWithFormat:@"label = %@", self.labelFilter]];
		}
		
		if (self.artistFilter != nil) {
			[subpredicates addObject:[NSPredicate predicateWithFormat:@"artist = %@", self.artistFilter]];
		}
		
		if (self.titleFilter != nil) {
			[subpredicates addObject:[NSPredicate predicateWithFormat:@"title = %@", self.titleFilter]];
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








@end
