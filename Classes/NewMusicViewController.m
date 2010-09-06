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

@synthesize titleTextField, artistTextField, labelTextField, catNoTextField;
@synthesize tableDataSourceArray;

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad {
	NSLog(@"NewMusicViewController viewDidLoad start");
    [super viewDidLoad];
	self.tableDataSourceArray = [NSArray arrayWithObjects:
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  @"Title",				kPlaceHolderTextKey,
								  self.titleTextField,	kTextFieldKey,
								  nil],
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  @"Artist",			kPlaceHolderTextKey,
								  self.artistTextField,	kTextFieldKey,
								  nil],
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  @"Label",				kPlaceHolderTextKey,
								  self.labelTextField,	kTextFieldKey,
								  nil],
								 [NSDictionary dictionaryWithObjectsAndKeys:
								  @"Catalogue Number",	kPlaceHolderTextKey,
								  self.catNoTextField,	kTextFieldKey,
								  nil],
								 nil];
	self.navigationItem.title = @"Add New Item";
	
	UIBarButtonItem	*addButton = [[UIBarButtonItem alloc]
								  initWithBarButtonSystemItem:UIBarButtonSystemItemDone 
								  target:self 
								  action:@selector(addMusic:)];
	
	self.navigationItem.rightBarButtonItem = addButton;
	[addButton release];
	NSLog(@"NewMusicViewController viewDidLoad end");
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

#pragma mark -
#pragma mark TextFields

- (UITextField *)titleTextField {
	if (titleTextField == nil) {
		CGRect frame = CGRectMake(25, 8.0, 260, 30); // TODO: Constants. Also, rotation.
		titleTextField = [[UITextField alloc] initWithFrame:frame];
		titleTextField.borderStyle = UITextBorderStyleNone;
		titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		titleTextField.delegate = self;
	}
	return titleTextField;
}

- (UITextField *)artistTextField {
	if (artistTextField == nil) {
		CGRect frame = CGRectMake(25, 8.0, 260, 30); // TODO: Constants. Also, rotation.
		artistTextField = [[UITextField alloc] initWithFrame:frame];
		artistTextField.borderStyle = UITextBorderStyleNone;
		artistTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		artistTextField.delegate = self;
	}
	return artistTextField;
}

- (UITextField *)labelTextField {
	if (labelTextField == nil) {
		CGRect frame = CGRectMake(25, 8.0, 260, 30); // TODO: Constants. Also, rotation.
		labelTextField = [[UITextField alloc] initWithFrame:frame];
		labelTextField.borderStyle = UITextBorderStyleNone;
		labelTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		labelTextField.delegate = self;
	}
	return labelTextField;
	
}

- (UITextField *)catNoTextField {
	if (catNoTextField == nil) {
		CGRect frame = CGRectMake(25, 8.0, 260, 30); // TODO: Constants. Also, rotation.
		catNoTextField = [[UITextField alloc] initWithFrame:frame];
		catNoTextField.borderStyle = UITextBorderStyleNone;
		catNoTextField.autocorrectionType = UITextAutocorrectionTypeNo;
		catNoTextField.delegate = self;
	}
	return catNoTextField;
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
	UITextField *textField = [[self.tableDataSourceArray objectAtIndex:row] valueForKey:kTextFieldKey];
    textField.placeholder =  [[self.tableDataSourceArray objectAtIndex:row] valueForKey:kPlaceHolderTextKey];
    [cell.contentView addSubview:textField];
    return cell;
}

#pragma mark -
#pragma mark Create Text Field For Cell
- (UITextField *) defineTextFieldForTableCell:(UITextField *)textField {
	if (textField == nil) {
		CGRect frame = CGRectMake(25, 8.0, 260, 30); // TODO: Constants. Also, rotation.
		textField = [[UITextField alloc] initWithFrame:frame];
		textField.borderStyle = UITextBorderStyleNone;
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.delegate = self;
	}
	return textField;
}

#pragma mark -
#pragma mark Add Item
-(void)addMusic:(id)selector {
	NSLog(@"MOC is %@", [self.managedObjectContext description]);
	Music *newMusic = [NSEntityDescription insertNewObjectForEntityForName:@"Music" 
													inManagedObjectContext:self.managedObjectContext];

	[newMusic setTitle:[titleTextField text]];
	[newMusic setArtist:[artistTextField text]];
	[newMusic setLabel:[labelTextField text]];
	[newMusic setCatNo:[catNoTextField text]];
	
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

