//
//  Person.h
//  People
//
//  Created by Svetlana Brodskaya on 7/1/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sync;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * imageSync;

@end
