//
//  MusicItemDetailsViewController.h
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 17/09/2010.
//  Copyright (c) 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MusicItemDetailsViewController : UIViewController <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate> {
    UITableView *detailsTableView;
    NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
    NSString *labelFilter, *artistFilter, *titleFilter;
}

@property(nonatomic, retain) IBOutlet UITableView *detailsTableView;
@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, retain) NSString *artistFilter;
@property(nonatomic, retain) NSString *labelFilter;
@property(nonatomic, retain) NSString *titleFilter;

@end
