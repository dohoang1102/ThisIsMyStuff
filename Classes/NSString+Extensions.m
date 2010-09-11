//
//  NSString+Extensions.m
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 10/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+Extensions.h"


@implementation NSString (Extensions)
- (NSString *)trim {
	return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)isEmpty {
	NSString *trimmedString = [self trim];
	return [trimmedString isEqualToString: @""];
}

@end
