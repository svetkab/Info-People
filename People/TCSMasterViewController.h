//
//  TCSMasterViewController.h
//  People
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "TCSRequestDataController.h"

@class TCSWelcomeViewController;

@interface TCSMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, DataReloadDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) TCSWelcomeViewController * welcomeViewController;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *syncButton;
- (IBAction)syncWithSource:(id)sender;

@property (strong, nonatomic) UILabel * loadProccessDesc;

@property (strong, nonatomic) TCSRequestDataController * requestDataController;

@property (assign, nonatomic) BOOL allowEditRows;
@end
