//
//  NewMusicViewController.m
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewMusicViewController.h"
#import "Music.h"

@implementation NewMusicViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

@synthesize theTableView;
@synthesize tableLabelNamesArray;
@synthesize titleTextView, artistTextView, labelTextView, catNoTextView;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	NSLog(@"NewMusicViewController viewDidLoad start");
		
    [super viewDidLoad];
	self.tableLabelNamesArray = [NSArray arrayWithObjects: @"Title", @"Artist", @"Label", @"Cat No", nil];
	self.navigationItem.title = @"Add New Item";
	
	UIBarButtonItem	*addButton = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
								  target:self 
								  action:@selector(addMusic:)];
	
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	
	// TODO: Will this leak?
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(textViewDidChange:) 
												 name:@"UITextViewTextDidChangeNotification" 
											   object:nil];
	
	NSLog(@"NewMusicViewController viewDidLoad end");
}

- (IBAction)save:(id)sender {
	NSLog(@"save");
	[self createNewMusic];
	[self dismissModalViewControllerAnimated:YES];
}
- (IBAction)cancel:(id)sender {
	NSLog(@"cancel");
	[self dismissModalViewControllerAnimated:YES];	
}



/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)textViewDidChange:(id)sender {
	//UITextView *changedTextView = (UITextView *)sender;
	//NSLog(@"%@ changed", [changedTextView tag]);
	NSLog(@"changy");
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	NSLog(@"shouldChangeTextInRange: %@", text);
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];		
		// What should be focussed next?
		switch ([textView tag]) {
			case kTitleTextView: {
				[artistTextView becomeFirstResponder];
			}
				break;
			case kArtistTextView: {
				[labelTextView becomeFirstResponder];
			}
				break;
			case kLabelTextView:{
				[catNoTextView becomeFirstResponder];
			}
				break;
			case kCatNoTextView: {
				[titleTextView becomeFirstResponder];
			}
				break;
			default:
				break;
		}
		return NO;
	}
	else {
		return YES;
	}
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableLabelNamesArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Adding a table cell.");
    static NSString *CellIdentifier = @"AddItemCell";
    AddItemCell *cell = (AddItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddItemCell" owner:self options:nil];
		for (id anObject in nib) {
			if ([anObject isKindOfClass:[AddItemCell class]]) {
				cell = (AddItemCell *)anObject;
			}
		}		
	}
	NSUInteger row = [indexPath row];	
	cell.label.text = [self.tableLabelNamesArray objectAtIndex: row];
	cell.textView.text = @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kTableCellHeight;
}

#pragma mark -
#pragma mark Add Item
- (void)createNewMusic {
	NSLog(@"MOC is %@", [self.managedObjectContext description]);
	Music *newMusic = [NSEntityDescription insertNewObjectForEntityForName:@"Music" 
													inManagedObjectContext:self.managedObjectContext];
	
	// Populate the new item from the table cells.	
	AddItemCell *cell;
	
	cell = (AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kTitleTextView inSection:0]];
	newMusic.title = cell.textView.text;

	cell = (AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kArtistT inSection:0]];
	newMusic.artist = cell.textView.text;

	cell = (AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kLabelTextView inSection:0]];
	newMusic.label = cell.textView.text;

	cell = (AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kCatNoTextView inSection:0]];
	newMusic.catNo = cell.textView.text;
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"Error saving: %@", [error description]);
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
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

