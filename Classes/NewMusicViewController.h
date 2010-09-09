//
//  NewMusicViewController.h
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kPlaceHolderTextKey	@"PlaceHolderText"
#define kTextViewKey		@"textView"

#define kTitleTextView		0
#define kArtistTextView		1
#define kLabelTextView		2
#define kCatNoTextView		3

@interface NewMusicViewController : UIViewController <UITextViewDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	NSArray		*tableDataSourceArray;
	UITextView *titleTextView, *artistTextView, *labelTextView, *catNoTextView;
	
}

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, retain) IBOutlet UITextView *titleTextView;
@property(nonatomic, retain) IBOutlet UITextView *artistTextView;
@property(nonatomic, retain) IBOutlet UITextView *labelTextView;
@property(nonatomic, retain) IBOutlet UITextView *catNoTextView;

@property(nonatomic, retain) NSArray *tableDataSourceArray;

@end
