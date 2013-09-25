//
//  BookDetailViewController.m
//  XML
//
//  Created by iPhone SDK Articles on 11/23/08.
//  Copyright 2008 www.iPhoneSDKArticles.com.
//

#import "RootViewController.h"
#import "XMLAppDelegate.h"
#import "Book.h"
#import "BookDetailViewController.h"

@implementation BookDetailViewController

@synthesize aBook;
@synthesize _text;

/*
// Override initWithNibName:bundle: to load the view using a nib file then perform additional customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view.

- (void)refreshTable{
	NSString * path = _text;
	[self parseXMLFileAtURL:path];
	[tableView reloadData];		
	NSLog(@"table is refreshing ...."); 
} 

- (void)viewDidLoad {
    [super viewDidLoad];
	
	appDelegate = (XMLAppDelegate *)[[UIApplication sharedApplication] delegate];
	
	UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable)];
	self.navigationItem.rightBarButtonItem = refreshButton;
	
	self.title = @"Current";
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[tableView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 14;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [stories count];
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	//Book *aBook = [appDelegate.books objectAtIndex:0];
	
	//bdvController.aBook = aBook;
	
	static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	{
		// Set up the cell
		int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
		[cell setText:[[stories objectAtIndex: 0] objectForKey: @"Block"]];
		
						
		//return cell;
	}
	
	switch(indexPath.section)
	{
		case 0:
			cell.text = currentTitle;
			break;
		case 1:
			cell.text = currentEstop;
			break;
		case 2:
			cell.text = currentMessage;
			break;
		case 3:
			cell.text = currentBlock;
			break;
		case 4:
			cell.text = currentControl;
			break;
		case 5:
			cell.text = currentLine;
			break;
		case 6:
			cell.text = currentProgram;
			break;
		case 7:
			cell.text = currentExec;
			break;
		case 8:
			cell.text = currentPathF;
			break;
		case 9:
			cell.text = currentPathP;
			break;
		case 10:
			cell.text = currentSpindle;
			break;
		case 11:
			cell.text = currentDate;
			break;
		case 12:
			cell.text = currentSummary;
			break;
		case 13:
			cell.text = currentLink;
			break;
				
			
	}
	
	return cell;
}

- (NSString *)tableView:(UITableView *)tblView titleForHeaderInSection:(NSInteger)section {
	
	NSString *sectionName = nil;
	
	switch(section)
	{
		case 0:
			sectionName = [NSString stringWithString:@"Power Status"];
			break;
		case 1:
			sectionName = [NSString stringWithString:@"Emergency Stop"];
			break;
		case 2:
			sectionName = [NSString stringWithString:@"Alarm/Message"];
			break;
		case 3:
			sectionName = [NSString stringWithString:@"Block"];
			break;
		case 4:
			sectionName = [NSString stringWithString:@"Controller Mode"];
			break;
		case 5:
			sectionName = [NSString stringWithString:@"Line"];
			break;
		case 6:
			sectionName = [NSString stringWithString:@"Program"];
			break;
		case 7:
			sectionName = [NSString stringWithString:@"Execution"];
			break;			
		case 8:
			sectionName = [NSString stringWithString:@"Path Feedrate"];
			break;
		case 9:
			sectionName = [NSString stringWithString:@"Path Position"];
			break;
		case 10:
			sectionName = [NSString stringWithString:@"Spindle"];
			break;			
		case 11:
			sectionName = [NSString stringWithString:@"X Linear Position"];
			break;
		case 12:
			sectionName = [NSString stringWithString:@"Y Linear Position"];
			break;
		case 13:
			sectionName = [NSString stringWithString:@"Z Linear Position"];
			break;		
			
			
	}
	
	return sectionName;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Navigation logic
	
	int storyIndex = [indexPath indexAtPosition: [indexPath length] - 1];
	
	NSString * storyLink = [[stories objectAtIndex: storyIndex] objectForKey: @"link"];
	
	// clean up the link - get rid of spaces, returns, and tabs...
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@" " withString:@""];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	storyLink = [storyLink stringByReplacingOccurrencesOfString:@"	" withString:@""];
	
	NSLog(@"link: %@", storyLink);
	// open in Safari
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:storyLink]];
}


- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	if ([stories count] == 0) {
		//NSString * path = @"http://feeds.feedburner.com/TheAppleBlog";
		NSString * path = _text;
		[self parseXMLFileAtURL:path];
	}
	
	//cellSize = CGSizeMake([newsTable bounds].size.width, 60);
}

- (void)viewWillDisappear:(BOOL)animated {
}

- (void)viewDidDisappear:(BOOL)animated {
}

//////////////////////

- (void)parserDidStartDocument:(NSXMLParser *)parser{	
	NSLog(@"found file and started parsing");
	
}

- (void)parseXMLFileAtURL:(NSString *)URL
{	
	stories = [[NSMutableArray alloc] init];
	
    //you must then convert the path to a proper NSURL or it won't work
    NSURL *xmlURL = [NSURL URLWithString:URL];
	
    // here, for some reason you have to use NSClassFromString when trying to alloc NSXMLParser, otherwise you will get an object not found error
    // this may be necessary only for the toolchain
    rssParser = [[NSXMLParser alloc] initWithContentsOfURL:xmlURL];
	
    // Set self as the delegate of the parser so that it will receive the parser delegate methods callbacks.
    [rssParser setDelegate:self];
	
    // Depending on the XML document you're parsing, you may want to enable these features of NSXMLParser.
    [rssParser setShouldProcessNamespaces:NO];
    [rssParser setShouldReportNamespacePrefixes:NO];
    [rssParser setShouldResolveExternalEntities:NO];
	
    [rssParser parse];
	
}
//@"Unable to download stream from agent (Error code %i )"

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	NSString * errorString = [NSString stringWithFormat:@"Unable to download stream from agent (Error code %i )", [parseError code]];
	NSLog(@"error parsing XML: %@", errorString);
	
	UIAlertView * errorAlert = [[UIAlertView alloc] initWithTitle:@"Error loading content" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[errorAlert show];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{			
    //NSLog(@"found this element: %@", elementName);
	currentElement = [elementName copy];
	if ([elementName isEqualToString:@"Streams"]) {
		// clear out our story item caches...
		item = [[NSMutableDictionary alloc] init];
		currentTitle = [[NSMutableString alloc] init];
		currentDate = [[NSMutableString alloc] init];
		currentSummary = [[NSMutableString alloc] init];
		currentLink = [[NSMutableString alloc] init];
		currentSpindle = [[NSMutableString alloc] init];
		currentControl = [[NSMutableString alloc] init];
		currentExec = [[NSMutableString alloc] init];
		currentBlock = [[NSMutableString alloc] init];
		currentEstop = [[NSMutableString alloc] init];
		currentMessage = [[NSMutableString alloc] init];
		currentLine = [[NSMutableString alloc] init];
		currentProgram = [[NSMutableString alloc] init];
		currentPathF = [[NSMutableString alloc] init];
		currentPathP = [[NSMutableString alloc] init];		
		
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{     
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"Streams"]) {
		// save values to an item, then store that item into the array...
		[item setObject:currentTitle forKey:@"PowerState"];
		[item setObject:currentDate forKey:@"Position"];
		[item setObject:currentSummary forKey:@"Position"];
		[item setObject:currentLink forKey:@"Position"];
		[item setObject:currentSpindle forKey:@"SpindleSpeed"];
		[item setObject:currentControl forKey:@"ControllerMode"];
		[item setObject:currentExec forKey:@"Execution"];
		[item setObject:currentBlock forKey:@"Block"];
		[item setObject:currentEstop forKey:@"EmergencyStop"];
		[item setObject:currentMessage forKey:@"Message"];
		[item setObject:currentLine forKey:@"Line"];
		[item setObject:currentProgram forKey:@"Program"];
		[item setObject:currentPathF forKey:@"PathFeedrate"];
		[item setObject:currentPathP forKey:@"PathPosition"];		
		
		[stories addObject:[item copy]];
		NSLog(@"adding story: %@", currentTitle);
	}
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
	//NSLog(@"found characters: %@", string);
	// save the characters for the current item...
	if ([currentElement isEqualToString:@"PowerState"]) {
		[currentTitle appendString:string];
	} else if ([currentElement isEqualToString:@"Position"]) {
			[currentDate appendString:string];
	} else if ([currentElement isEqualToString:@"Position"]) {
			[currentSummary appendString:string];
	} else if ([currentElement isEqualToString:@"Position"]) {
		[currentLink appendString:string];
	} else if ([currentElement isEqualToString:@"SpindleSpeed"]) {
		[currentSpindle appendString:string];
	} else if ([currentElement isEqualToString:@"ControllerMode"]) {
		[currentControl appendString:string];
	} else if ([currentElement isEqualToString:@"Execution"]) {
		[currentExec appendString:string];		
	} else if ([currentElement isEqualToString:@"Block"]) {
		[currentBlock appendString:string];		
	} else if ([currentElement isEqualToString:@"EmergencyStop"]) {
		[currentEstop appendString:string];
	} else if ([currentElement isEqualToString:@"Message"]) {
		[currentMessage appendString:string];
	} else if ([currentElement isEqualToString:@"Line"]) {
		[currentLine appendString:string];
	} else if ([currentElement isEqualToString:@"Program"]) {
		[currentProgram appendString:string];
	} else if ([currentElement isEqualToString:@"PathFeedrate"]) {
		[currentPathF appendString:string];		
	} else if ([currentElement isEqualToString:@"PathPosition"]) {
		[currentPathP appendString:string];		
	}	
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	
	[activityIndicator stopAnimating];
	[activityIndicator removeFromSuperview];
	
	NSLog(@"all done!");
	NSLog(@"stories array has %d items", [stories count]);
	[tableView reloadData];
}





//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
//	return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}


//- (void)didReceiveMemoryWarning {
//	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
//}




- (void)dealloc {
		
	[currentElement release];
	[rssParser release];
	[stories release];
	[item release];
	[currentTitle release];
	[currentDate release];
	[currentSummary release];
	[currentLink release];	
	[bdvController release];
	[appDelegate release];
	[aBook release];
	[tableView release];
	[_text release];	
    [super dealloc];
}


@end
