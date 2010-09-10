//
//  NewMusicViewController.h
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddItemCell.h"

#define kPlaceHolderTextKey	@"PlaceHolderText"
#define kTextViewKey		@"textView"

#define kTitleTextView		0
#define kArtistTextView		1
#define kLabelTextView		2
#define kCatNoTextView		3

#define kTableCellHeight	52

@interface NewMusicViewController : UIViewController <UITextViewDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext     *managedObjectContext;

	NSArray		*tableLabelNamesArray;	
	UITableView *theTableView;	
	UITextView  *titleTextView, *artistTextView, *labelTextView, *catNoTextView;
}

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, retain) IBOutlet UITableView *theTableView;
@property(nonatomic, retain) IBOutlet UITextView  *titleTextView;
@property(nonatomic, retain) IBOutlet UITextView  *artistTextView;
@property(nonatomic, retain) IBOutlet UITextView  *labelTextView;
@property(nonatomic, retain) IBOutlet UITextView  *catNoTextView;

@property(nonatomic, retain) NSArray *tableLabelNamesArray;

- (void)createNewMusic;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

@end
