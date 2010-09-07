//
//  MusicArtistsViewController.h
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Music.h"

@interface MusicArtistsViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	NSString *labelFilter;
}

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSString *labelFilter;

@end
