//
//  MusicRootViewController.h
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMusicViewController.h"
#import "MusicArtistsViewController.h"
#import "MusicLabelsViewController.h"

#define kArtistRow	0
#define kLabelRow	1


@interface MusicRootViewController : UITableViewController {
	NSArray *tableItems;
	
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	
}

@property(nonatomic, retain) NSArray *tableItems;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
