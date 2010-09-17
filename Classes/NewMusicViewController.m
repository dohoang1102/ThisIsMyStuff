//
//  NewMusicViewController.m
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NewMusicViewController.h"
#import "Music.h"
#import "NSString+Extensions.h"
#import "UITextView+Extensions.h"

@implementation NewMusicViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

@synthesize theTableView;
@synthesize tableLabelNamesArray;
@synthesize itemLabel;
@synthesize itemArtist;
@synthesize caller;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {		
    [super viewDidLoad];
	self.tableLabelNamesArray = [NSArray arrayWithObjects: @"Title", @"Artist", @"Label", @"Cat No", @"Format", @"Grouping", @"Notes", nil];
	self.navigationItem.title = @"Add New Item";
	
	UIBarButtonItem	*addButton = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
								  target:self 
								  action:@selector(addMusic:)];
	
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
		
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(textViewDidChange:) 
												 name:@"UITextViewTextDidChangeNotification" 
											   object:nil];	
}


- (IBAction)save:(id)sender {
	if ([self createNewMusic]) {
		[self dismissModalViewControllerAnimated:YES];
		// Update the data for the page that opened this one.
		if ([caller respondsToSelector:@selector(reloadTableData)]) {
			[caller performSelector:@selector(reloadTableData)];
		}
	}
}


- (IBAction)cancel:(id)sender {
	[self dismissModalViewControllerAnimated:YES];	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark -
#pragma mark Text View Delegate methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
	AddItemCell *cell = (AddItemCell*) [[textView superview] superview];
	NSLog(@"textViewDidBeginEditing %@", cell);
	[theTableView setFrame:CGRectMake(0, 0, 320, 260)];
	[theTableView scrollToRowAtIndexPath:[theTableView indexPathForCell:cell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
	[theTableView setFrame:CGRectMake(0, 0, 320, 480)];
}

- (void)textViewDidChange:(UITextView *)textView {
	
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	// These are multi-line text fields that we're making behave like a single line ones
	// So if Enter is pressed moved to the next field.
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];		

		// What should be focussed next?
		NSUInteger nextTextField = 0;
		switch ([textView tag]) {
			case kTitleTextView: {
				nextTextField = kArtistTextView;
			}
				break;
			case kArtistTextView: {
				nextTextField = kLabelTextView;
			}
				break;
			case kLabelTextView:{
				nextTextField = kCatNoTextView;
			}
				break;
			case kCatNoTextView: {
				nextTextField = kFormatTextView;
			}
				break;
			case kFormatTextView: {
				nextTextField = kGroupingTextView;
			}
				break;
			case kGroupingTextView: {
				nextTextField = kNotesTextView;
			}
				break;
			case kNotesTextView: {
				nextTextField = kTitleTextView;
			}
				break;
			default:
				break;
		}
		AddItemCell *cell = (AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nextTextField inSection:0]];
		[cell.textView becomeFirstResponder];
		return NO;
	}
	else {
		// If a character has been added then try to get a match from the DB.

		// Don't match on the Cat No or Notes fields.
		if (([textView tag] == kCatNoTextView ) || ([textView tag] == kNotesTextView)) {
			return YES;
		}

		NSString *searchField;
		switch ([textView tag]) {
			case kTitleTextView:
				searchField = @"title";
				break;
			case kArtistTextView:
				searchField = @"artist";
				break;
			case kLabelTextView:
				searchField = @"label";
				break;
			case kFormatTextView:
				searchField = @"format";
				break;
			case kGroupingTextView:
				searchField = @"grouping";
				break;
		}
			 
		if	([text isEqualToString:@" "] || ![text isEmpty]) { 			
			NSString *searchTerm = [[textView unselectedText] stringByAppendingString: text];
			NSMutableArray *resultsArray = [self resultsForSearchString: searchTerm forField: searchField];
			
			if ([resultsArray count] == 0) {
				return YES;
			}
			else {
				NSString *firstMatch = [[resultsArray objectAtIndex: 0] valueForKey: searchField];
				[textView setText: firstMatch];
				[textView setSelectedRange: NSMakeRange([searchTerm length], [firstMatch length] - [searchTerm length])];
				return NO;
			}			
		}
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
	NSUInteger row = [indexPath row];	
    static NSString *CellIdentifier = @"AddItemCell";
    AddItemCell *cell = (AddItemCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AddItemCell" owner:self options:nil];
		for (id anObject in nib) {
			if ([anObject isKindOfClass:[AddItemCell class]]) {
				cell = (AddItemCell *)anObject;
				cell.textView.delegate = self;
				cell.textView.tag = row;
				cell.textView.text = [NSString stringWithFormat:@"%d", cell.tag];
			}
		}		
	}
	cell.label.text = [self.tableLabelNamesArray objectAtIndex: row];
	
	switch (row) {
		case kArtistTextView: {
			cell.textView.text = self.itemArtist;
		}
			break;
		case kLabelTextView: {
			cell.textView.text = self.itemLabel;
		}
			break;
		default: {
			cell.textView.text = @"";
		}
			break;
	}
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kTableCellHeight;
}

#pragma mark -
#pragma mark Add Item
- (BOOL)createNewMusic {
	AddItemCell *titleItemCell    = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kTitleTextView    inSection:0]]);
	AddItemCell *artistItemCell   = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kArtistTextView   inSection:0]]);
	AddItemCell *labelItemCell    = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kLabelTextView    inSection:0]]); 
	AddItemCell *catNoItemCell    = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kCatNoTextView    inSection:0]]);
	AddItemCell *formatItemCell   = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kFormatTextView   inSection:0]]);
	AddItemCell *groupingItemCell = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kGroupingTextView inSection:0]]);
	AddItemCell *notesItemCell    = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kNotesTextView    inSection:0]]);
		
	// Title and Artist need to be populated.
	BOOL itemIsValid = YES;
	UIColor *errorColor = [UIColor colorWithRed:0.7 green:0 blue:0 alpha:1.0];
	
	if ([titleItemCell.textView.text isEmpty]) {
		titleItemCell.label.textColor = errorColor;
		itemIsValid = NO;
	}
	else {
		titleItemCell.label.textColor = [UIColor blackColor];
	}
	
	if ([artistItemCell.textView.text isEmpty]) {
		artistItemCell.label.textColor = errorColor;
		itemIsValid = NO;
	}
	else {
		artistItemCell.label.textColor = [UIColor blackColor];
	}
	
	if (!itemIsValid) {
		return NO;
	}
	
	Music *newMusic = [NSEntityDescription insertNewObjectForEntityForName:@"Music" 
													inManagedObjectContext:self.managedObjectContext];
	
	// Populate the new item from the table cells.	
	newMusic.title    = titleItemCell.textView.text;
	newMusic.artist   = artistItemCell.textView.text;
	newMusic.label    = labelItemCell.textView.text;
	newMusic.catNo    = catNoItemCell.textView.text;
	newMusic.format   = formatItemCell.textView.text;
	newMusic.grouping = groupingItemCell.textView.text;
	newMusic.notes    = notesItemCell.textView.text;
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"Error saving: %@", [error description]);
	}
	return YES;
}

#pragma mark -
#pragma mark Get Item
- (NSMutableArray*)resultsForSearchString:(NSString *)searchTerm forField:(NSString *) field {
	NSFetchRequest *request = [[NSFetchRequest alloc] init]; 
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Music" 
											  inManagedObjectContext:managedObjectContext]; 
	[request setEntity:entity];
	[request setFetchLimit: 1];
	[request setResultType:NSDictionaryResultType];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:field ascending:YES]; 
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil]; 
	[request setSortDescriptors:sortDescriptors]; 
	
	NSPredicate *labelPredicate = [NSPredicate predicateWithFormat:@"%K BEGINSWITH[cd] %@", field, searchTerm];
	[request setPredicate:labelPredicate];
	
	NSError *error; 
	NSMutableArray *resultsArray = [[managedObjectContext executeFetchRequest:request error:&error] mutableCopy]; 
	if (resultsArray == nil) {
		// Handle the error.
	}

	[sortDescriptors release]; 
	[sortDescriptor release];
	return resultsArray;
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    self.tableLabelNamesArray = nil;
	self.theTableView = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end

