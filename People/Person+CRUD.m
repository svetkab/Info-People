//
//  Person+CRUD.m
//  People
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import "Person+CRUD.h"

@implementation Person (CRUD)


+ (Person *) insertNewPerson:(NSString*)name
                   withEmail:(NSString*)email
                    imageUrl:(NSString*)url
                       Image:(UIImage*)image
          inManagedObjectContext:(NSManagedObjectContext *)context
                 syncVersion:(int)syncVersion;
{
    Person *person = nil;

    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"email = %@", email];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *matches = [context executeFetchRequest:fetchRequest error:&error];
    
    
    if (!matches || ([matches  count]>0)){
        //HANDLE ERROR??
        return nil;
    }else if ([matches count] == 0) {
        
        
        person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
        
        [person setName:name];
        [person setEmail:email];
        [person setUrl:url];
        [person setImage:image];
        [person setSync:[NSNumber numberWithInt:syncVersion]];
        [person setTimeStamp:[NSDate date]];
        
        
        NSLog(@"INSERTING name: %@",name);
        
        if (![context save:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }
        
    }
    
    return person;
}

+ (int) maxSyncInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    [request setEntity:entity];
    
    // Specify that the request should return dictionaries.
    [request setResultType:NSDictionaryResultType];
    
    // Create an expression for the key path.
    NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"sync"];
    
    // Create an expression to represent the minimum value at the key path 'creationDate'
    NSExpression *maxExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];
    
    // Create an expression description using the minExpression and returning a date.
    NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
    
    // The name is the key that will be used in the dictionary for the return value.
    [expressionDescription setName:@"maxSync"];
    [expressionDescription setExpression:maxExpression];
    [expressionDescription setExpressionResultType:NSInteger64AttributeType];
    
    // Set the request's properties to fetch just the property represented by the expressions.
    [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
    
    // Execute the fetch.
    NSError *error = nil;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if (objects == nil) {
        // Handle the error.
    }
    else {
        if ([objects count] > 0) {
            NSLog(@"MAX sync: %@", [[objects objectAtIndex:0] valueForKey:@"maxSync"]);
            
             NSLog(@"MAX sync: %i", [[[objects objectAtIndex:0] valueForKey:@"maxSync"] intValue]);
        }
    }

    return [[[objects objectAtIndex:0] valueForKey:@"maxSync"] intValue];
    
}
+(int) recordsInSync:(int)syncVersion InManagedObjectContext:(NSManagedObjectContext *)context
{
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sync = %@",[NSNumber numberWithInt: syncVersion]];
    [fetchRequest setPredicate:predicate];
    
    int records = [context countForFetchRequest:fetchRequest error:&error];
    
    return records;
}
@end
