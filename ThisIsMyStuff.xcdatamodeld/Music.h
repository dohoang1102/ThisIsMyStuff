//
//  Music.h
//  ThisIsMyStuff
//
//  Created by Eifion Bedford on 06/09/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Music :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * label;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * catNo;
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * format;
@property (nonatomic, retain) NSString * grouping;
@property (nonatomic, retain) NSString * notes;

@end



