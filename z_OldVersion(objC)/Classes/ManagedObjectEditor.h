#import <UIKit/UIKit.h>

#define kToManyRelationship    @"ManagedObjectToManyRelationship"
#define kSelectorKey            @"selector"
@class XMLAppDelegate, BookDetailViewController;
@interface ManagedObjectEditor : UITableViewController {
    NSManagedObject *managedObject;
    BOOL            showSaveCancelButtons;
	XMLAppDelegate *appDelegate;
	BookDetailViewController *bdvController;	
	
    
@private   
    NSArray         *sectionNames;
    NSArray         *rowLabels;
    NSArray         *rowKeys;
    NSArray         *rowControllers;
    NSArray         *rowArguments; 
    
}
@property (nonatomic, retain) NSManagedObject *managedObject;
@property BOOL showSaveCancelButtons;
- (IBAction)save;
- (IBAction)cancel;
@end
