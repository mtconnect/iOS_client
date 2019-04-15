//
//  XMLAppDelegate.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "XMLAppDelegate.h"
#import "XMLParser.h"
#import "ManagedObjectEditor.h"

@implementation XMLAppDelegate

@synthesize window;
@synthesize navigationController, books;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	
	NSURL *url = [[NSURL alloc] initWithString:@"http://www.itamco.com/current2.xml"];
	NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithContentsOfURL:url];
	
	//Initialize the delegate.
	XMLParser *parser = [[XMLParser alloc] initXMLParser];
	
	//Set delegate
	[xmlParser setDelegate:parser];
	
	//Start parsing the XML file.
	BOOL success = [xmlParser parse];
	
	if(success)
		NSLog(@"No Errors");
	else
		NSLog(@"Error Error Error!!!");
	
	// Configure and show the window
	[window addSubview:[navigationController view]];
	[window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


- (void)dealloc {
	[books release];
	[navigationController release];
	[window release];
	[super dealloc];
}

@end
