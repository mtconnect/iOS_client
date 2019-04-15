//
//  XMLParser.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class XMLAppDelegate, Book;

@interface XMLParser : NSObject {

	NSMutableString *currentElementValue;
		
	XMLAppDelegate *appDelegate;
	Book *aBook; 
}

- (XMLParser *) initXMLParser;

@end
