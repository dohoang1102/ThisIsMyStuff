//
//  NewMusicViewController.h
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kPlaceHolderTextKey	@"PlaceHolderText"
#define kTextFieldKey		@"textField"

@interface NewMusicViewController : UITableViewController <UITextFieldDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	NSManagedObjectContext *managedObjectContext;
	
	NSArray		*tableDataSourceArray;
	UITextField *titleTextField, *artistTextField, *labelTextField, *catNoTextField;
	
}

@property(nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property(nonatomic, retain) UITextField *titleTextField;
@property(nonatomic, retain) UITextField *artistTextField;
@property(nonatomic, retain) UITextField *labelTextField;
@property(nonatomic, retain) UITextField *catNoTextField;

@property(nonatomic, retain) NSArray *tableDataSourceArray;

- (UITextField *) defineTextFieldForTableCell:(UITextField *)textField;

@end
