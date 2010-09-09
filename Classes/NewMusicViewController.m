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

@synthesize titleTextView, artistTextView, labelTextView, catNoTextView;
@synthesize tableDataSourceArray;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	NSLog(@"NewMusicViewController viewDidLoad start");
    [super viewDidLoad];
	self.tableDataSourceArray = [NSArray arrayWithObjects:
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  @"Title",				kPlaceHolderTextKey,
								  self.titleTextView,	kTextViewKey,
								  nil],
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  @"Artist",			kPlaceHolderTextKey,
								  self.artistTextView,	kTextViewKey,
								  nil],
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  @"Label",				kPlaceHolderTextKey,
								  self.labelTextView,	kTextViewKey,
								  nil],
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  @"Catalogue Number",	kPlaceHolderTextKey,
								  self.catNoTextView,	kTextViewKey,
								  nil],
								 nil];
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
    return [self.tableDataSourceArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"NewMusicCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	
	NSUInteger row = [indexPath row];
	UITextView *textView = [[self.tableDataSourceArray objectAtIndex:row] valueForKey:kTextViewKey];
    // textView.placeholder =  [[self.tableDataSourceArray objectAtIndex:row] valueForKey:kPlaceHolderTextKey];
    [cell.contentView addSubview:textView];
    return cell;
}

#pragma mark -
#pragma mark Add Item
-(void)addMusic:(id)selector {
	NSLog(@"MOC is %@", [self.managedObjectContext description]);
	Music *newMusic = [NSEntityDescription insertNewObjectForEntityForName:@"Music" 
													inManagedObjectContext:self.managedObjectContext];

	[newMusic setTitle:[titleTextView text]];
	[newMusic setArtist:[artistTextView text]];
	[newMusic setLabel:[labelTextView text]];
	[newMusic setCatNo:[catNoTextView text]];
	
	NSLog(@"NewMusic is %@", [newMusic description]);
	
	NSError *error;
	if (![managedObjectContext save:&error]) {
		NSLog(@"Error saving: %@", [error description]);
	}
	[self.navigationController popViewControllerAnimated:YES];
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

