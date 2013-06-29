//
//  TCSRequestDataController.h
//  People
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataReloadDelegate <NSObject>

-(void)createUpdateDoneNotification;
-(void) showAlert;
@end

@interface TCSRequestDataController : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (assign, nonatomic) int syncVersion;

@property (weak, nonatomic) id <DataReloadDelegate> dataReloadDelegate;


-(void) loadData;

@end
