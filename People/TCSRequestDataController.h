//
//  TCSRequestDataController.h
//  People
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCSUrlReachabilityWatcher.h"

@protocol DataReloadDelegate <NSObject>

-(void) updateViewAfterSync;
-(void) indicateconnectionProblem:(int)reconnectionInterval;
@end

@interface TCSRequestDataController : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (assign, nonatomic) int syncVersion;

@property (weak, nonatomic) id <DataReloadDelegate> dataReloadDelegate;

@property (strong, nonatomic) TCSUrlReachabilityWatcher *urlReachabilityWatcher;

@property (assign, nonatomic) BOOL reTry;

@property (strong, nonatomic) NSArray * imagesUrls;

@property (strong, nonatomic) NSMutableArray * personsWithNewImageUrl;

@property (strong, nonatomic) NSMutableDictionary * personImages;

-(void) loadData;

@end
