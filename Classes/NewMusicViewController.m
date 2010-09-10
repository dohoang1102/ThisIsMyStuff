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

@implementation NewMusicViewController

@synthesize fetchedResultsController;
@synthesize managedObjectContext;

@synthesize theTableView;
@synthesize tableLabelNamesArray;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {		
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
}


- (IBAction)save:(id)sender {
	if ([self createNewMusic]) {
		[self dismissModalViewControllerAnimated:YES];
	}
}


- (IBAction)cancel:(id)sender {
	NSLog(@"cancel");
	[self dismissModalViewControllerAnimated:YES];	
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)textViewDidChange:(id)sender {
	
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	NSLog(@"shouldChangeTextInRange: %@", text);
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];		

		// What should be focussed next?
		NSUInteger nextTextField = 0;
		NSLog(@"Current text view's tag is %d", [textView tag]);
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
				nextTextField = kTitleTextView;
			}
				break;
			default:
				break;
		}
		NSLog(@"Next field is %d", nextTextField);
		AddItemCell *cell = (AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nextTextField inSection:0]];
		[cell.textView becomeFirstResponder];
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
	cell.textView.text = @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return kTableCellHeight;
}

#pragma mark -
#pragma mark Add Item
- (BOOL)createNewMusic {
	AddItemCell *titleItemCell  = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kTitleTextView inSection:0]]);
	AddItemCell *artistItemCell = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kArtistTextView inSection:0]]);
	AddItemCell *labelItemCell  = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kLabelTextView inSection:0]]); 
	AddItemCell *catNoItemCell  = ((AddItemCell *)[self.theTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kCatNoTextView inSection:0]]);
		
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
	newMusic.title  = titleItemCell.textView.text;
	newMusic.artist = artistItemCell.textView.text;
	newMusic.label  = labelItemCell.textView.text;
	newMusic.catNo  = catNoItemCell.textView.text;
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"Error saving: %@", [error description]);
	}
	
	return YES;
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

