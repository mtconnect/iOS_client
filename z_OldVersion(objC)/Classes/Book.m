//
//  Book.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "Book.h"


@implementation Book

@synthesize PathFeedrate, PathPosition, Amperage, Frequency, Watts, Voltage, Position, SpindleSpeed, bookID;



- (void) dealloc {
	
	[PathFeedrate release];	
	[PathPosition release];
	[Amperage release];
	[Frequency release];
	[Watts release];
	[Position release];
	[Voltage release];		
	[SpindleSpeed release];	
	[super dealloc];
}

@end
