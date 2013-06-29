//
//  Person+CRUD.h
//  People
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import "Person.h"

@interface Person (CRUD)

+ (Person *) insertUpdatePerson:(NSString*)name
                   withEmail:(NSString*)email
                    imageUrl:(NSString*)url
                       Image:(UIImage*)image
      inManagedObjectContext:(NSManagedObjectContext *)context
                 syncVersion:(int)syncVersion;

+ (int) maxSyncInManagedObjectContext:(NSManagedObjectContext *)context;
+ (int) recordsInSync:(int)syncVersion InManagedObjectContext:(NSManagedObjectContext *)context;
+ (void) deleteRecordsNotInCurrent:(int)syncVersion InManagedObjectContext:(NSManagedObjectContext *)context;
@end
