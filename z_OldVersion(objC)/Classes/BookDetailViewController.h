//
//  BookDetailViewController.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class Book, XMLAppDelegate, BookDetailViewController;

@interface BookDetailViewController : UIViewController {

	IBOutlet UITableView *tableView;
	
	UIActivityIndicatorView *activityIndicator;
	
	Book *aBook;
	
	CGSize cellSize;
	
	XMLAppDelegate *appDelegate;

	BookDetailViewController *bdvController;
	
	NSXMLParser *rssParser;
	
	NSMutableArray *stories;
	
	NSString *_text;	
	
	// a temporary item; added to the "stories" array one at a time, and cleared for the next one
	NSMutableDictionary * item;
	
	// it parses through the document, from top to bottom...
	// we collect and cache each sub-element value, and then save each item to our array.
	// we use these to track each current item, until it's ready to be added to the "stories" array
	NSString * currentElement;
	NSMutableString * currentTitle, * currentDate, * currentSummary, * currentLink, *currentSpindle, *currentControl, *currentExec, *currentBlock, *currentEstop, *currentMessage, *currentLine, *currentProgram, *currentPathF, *currentPathP;	
		
}

@property (nonatomic, retain) Book *aBook;
@property (nonatomic,retain) NSString *_text;

@end
