//
//  AddItem.h
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 09/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddItemCell : UITableViewCell {
	UILabel *label;
	UITextView *textView;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UITextView *textView;

@end
