//
//  UITextView+Extensions.m
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 11/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "UITextView+Extensions.h"


@implementation UITextView (Extensions)
- (NSString*)unselectedText {
	if (self.selectedRange.length == 0) {
		NSLog(@"No selection. Returning %@", self.text);
		return self.text;
	}
	else {
		NSLog(@"Selection. Returning %@", [self.text substringToIndex:self.selectedRange.location]);
		return [self.text substringToIndex:self.selectedRange.location];
	}
}
@end
