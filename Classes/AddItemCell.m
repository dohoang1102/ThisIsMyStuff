//
//  AddItem.m
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 09/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AddItemCell.h"


@implementation AddItemCell

@synthesize label;
@synthesize textView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {

    }
    return self;
}

- (void)dealloc {
    [super dealloc];
}


@end
