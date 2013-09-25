//
//  Book.h
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import <UIKit/UIKit.h>


@interface Book : NSObject {
	
	NSInteger bookID;
	NSString *PathFeedrate;	//Same name as the Entity Name.
	NSString *PathPosition;	//Same name as the Entity Name.
	NSString *Position;	//Same name as the Entity Name.
	NSString *Amperage;	//Same name as the Entity Name.	
	NSString *Voltage;	//Same name as the Entity Name.
	NSString *Frequency; //Same name as the Entity Name.
	NSString *SpindleSpeed; //Same name as the Entity Name.
	NSString *Watts; //Same name as the Entity Name.	
	
}

@property (nonatomic, readwrite) NSInteger bookID;
@property (nonatomic, retain) NSString *PathFeedrate;
@property (nonatomic, retain) NSString *PathPosition;
@property (nonatomic, retain) NSString *Position;
@property (nonatomic, retain) NSString *Amperage;
@property (nonatomic, retain) NSString *Voltage;
@property (nonatomic, retain) NSString *Frequency;
@property (nonatomic, retain) NSString *SpindleSpeed;
@property (nonatomic, retain) NSString *Watts;

@end
