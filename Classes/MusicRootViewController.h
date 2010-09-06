//
//  MusicRootViewController.h
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMusicViewController.h"


@interface MusicRootViewController : UITableViewController {
	NSArray *tableItems;
}

@property(nonatomic, retain) NSArray *tableItems;

@end
