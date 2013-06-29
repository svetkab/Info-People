//
//  TCSRequestDataController.m
//  People
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import "TCSRequestDataController.h"

#import "Person+CRUD.h"

@implementation TCSRequestDataController



////////
-(void) loadData
{
    
    int maxSync = [Person maxSyncInManagedObjectContext:self.managedObjectContext];
    
    NSLog(@"maxSync%i", maxSync);
    
    _syncVersion = maxSync + 1;
    
    
    [self loadDataFromURL:[NSURL URLWithString:@"http://code.laksg.com/challenge/api/people/"]];
    
}
-(void) loadDataFromURL:(NSURL*)url

{
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData* data = [NSData dataWithContentsOfURL:
                        url];
        
                if (data!=nil) {
                        [self performSelectorOnMainThread:@selector(extactDataFromJson:)
                                   withObject:data waitUntilDone:YES];

                } else {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        [_dataReloadDelegate showAlert];
                    });
                }
        
            });
}
- (void)extactDataFromJson:(NSData *)responseData {
    
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData
                     options:kNilOptions
                     error:&error];
    
    NSLog(@"json%@",json);
    
    
    
    
    for (NSDictionary *personDesc in json) {
        
        dispatch_async(dispatch_get_global_queue(
                                                 DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage * image = [self loadImageFromURL:[personDesc objectForKey:@"avatar_url"]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                [Person insertNewPerson:[personDesc objectForKey:@"name"]
                              withEmail:[personDesc objectForKey:@"email"]
                               imageUrl:[personDesc objectForKey:@"avatar_url"]
                                  Image:image
                 inManagedObjectContext:self.managedObjectContext
                            syncVersion:_syncVersion];
                
                if ([Person recordsInSync:_syncVersion InManagedObjectContext:self.managedObjectContext]==json.count) {
                    [_dataReloadDelegate createUpdateDoneNotification];
                }
                
                
                
            });
            
        });
        
        
    }
    
    
}
-(UIImage*) loadImageFromURL:(NSString*) url
{
    NSURL *nsurl = [NSURL URLWithString:url];
    NSData *data = [NSData dataWithContentsOfURL:nsurl];
    return [[UIImage alloc] initWithData:data scale:1.0];
}


@end
