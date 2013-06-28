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
        
        NSLog(@"INSERTING name: %@",name);
        
        if (![context save:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }
        
    }
    
    return person;
}

@end
