//
//  RootViewController.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>

@class XMLAppDelegate, BookDetailViewController;

@interface RootViewController : UITableViewController {
	
	XMLAppDelegate *appDelegate;
	BookDetailViewController *bdvController;
}

@end
