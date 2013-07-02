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


- (id)init
{
    self = [super init];
    
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImagesInDB) name:@"AllImagesLoaded" object:nil];
        
        _urlReachabilityWatcher = [[TCSUrlReachabilityWatcher alloc] init];
    }
    
    return self;
}
////////
-(void) loadData
{
    if (_urlReachabilityWatcher.reconnectionInterval==2) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PROBLEM" message:@"Online data is not available. Could be a connection problem." delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    [_dataReloadDelegate  updateViewBeforeSync];
    _reTry = YES;
    int maxSync = [Person maxSyncInManagedObjectContext:self.managedObjectContext];
    
    NSLog(@"maxSync%i", maxSync);
    
    _syncVersion = maxSync + 1;
    
    _imagesUrls = [Person allImagesURLsInManagedObjectContext:self.managedObjectContext];
    
    
    [self loadDataFromURL:[NSURL URLWithString:@"http://code.laksg.com/challenge/api/people/"]];
    
}
-(void) loadDataFromURL:(NSURL*)url
{
    dispatch_queue_t loadJsonQueue = dispatch_queue_create( "com.tuxedocat.people.loadjson", NULL );

    
    dispatch_async(loadJsonQueue, ^{
                NSData* data = [NSData dataWithContentsOfURL:
                        url];
        
                if (data!=nil) {
                    
                    dispatch_queue_t extactDataFromJsonQueue = dispatch_queue_create( "com.tuxedocat.people.extactDataFromJson", NULL );
                    
                    dispatch_async(extactDataFromJsonQueue,  ^(){
                        [self extactDataFromJson:data];
                    });
                    
                    dispatch_release(extactDataFromJsonQueue);
                    _reTry = NO;
                    _urlReachabilityWatcher.reconnectionInterval=0;

                } else {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        
                        _reTry = YES;
                        [_urlReachabilityWatcher nextReconnectionInterval];
                        
                        [_dataReloadDelegate indicateconnectionProblem];
                        [NSTimer scheduledTimerWithTimeInterval:_urlReachabilityWatcher.reconnectionInterval target:self
                                                       selector:@selector(loadData)
                                                       userInfo:nil
                                                        repeats:NO];
                         
                    });
                }
        
            });
    
    dispatch_release(loadJsonQueue);
    
}

- (void)extactDataFromJson:(NSData *)responseData {
    
    _personsWithNewImageUrl = [NSMutableArray array];
    
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData
                     options:kNilOptions
                     error:&error];
    
    NSLog(@"extactDataFromJson");

    for (NSDictionary *personDesc in json) {

                Person *person =[Person insertUpdatePerson:[personDesc objectForKey:@"name"]
                                 withEmail:[personDesc objectForKey:@"email"]
                                  imageUrl:[personDesc objectForKey:@"avatar_url"]
                    inManagedObjectContext:self.managedObjectContext
                               syncVersion:_syncVersion];
            
                
                if (person!=nil) {
                    [_personsWithNewImageUrl addObject:person];
                }
        
                int recordsInSync = [Person recordsInSync:_syncVersion InManagedObjectContext:self.managedObjectContext];
        
            //    NSLog(@"recordsInSync%i", recordsInSync);
                
                if (recordsInSync==json.count) {
                    [Person deleteRecordsNotInCurrent:_syncVersion InManagedObjectContext:self.managedObjectContext];
                }
    
   
    }
    
    [self loadNewImagesForPeople:_personsWithNewImageUrl];
    
}
- (void)sentEventAllImagesLoaded {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AllImagesLoaded" object:nil];
}
-(void)updateImagesInDB {
    
    NSLog(@"updateImagesInDB");
    
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
         NSLog(@"updateImagesInDB -INSIDE GUEUE");
        
        for (Person * person in _peopleWithCorruptImages) {
            
            [person setImageSync:[NSNumber numberWithBool:NO]];
            
        }
        
         NSError *error = nil;
        
        if (![self.managedObjectContext save:&error]) {
            // Update to handle the error appropriately.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            exit(-1);  // Fail
        }
        dispatch_async(dispatch_get_main_queue(), ^(){
            
            [_dataReloadDelegate updateViewAfterSync];

        });
        
    });  
}
-(void) loadNewImagesForPeople:(NSArray*)peopleArray
{
    _peopleWithCorruptImages = [NSMutableArray array];
    
    NSLog(@"loadNewImagesForPeople");
    
    __block volatile int personImagesCount = 0;
    if (peopleArray.count == 0) {
        [self sentEventAllImagesLoaded];
    } else {
        
        for (Person * person in peopleArray) {
            dispatch_async(dispatch_get_global_queue(
                                                     DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage * image = [self loadImageFromURL:person.url];
                
                //test:
              //  UIImage * image = [self loadImageFromURL:@"www.lala"];
                
                if (image==nil) {
                    [_peopleWithCorruptImages addObject:person];
                    
                    image = [[UIImage alloc] init];
                }else{
                     //if new image is corrupted - old image remains
                  
                    [person setImage:image];
                    [person setImageSync:[NSNumber numberWithBool:YES]];
       
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    
                    
                    //personImagesCount=personImagesCount+1;
                    //to be more secure
                    __sync_fetch_and_add( &personImagesCount, 1 );
                    
                    if (personImagesCount == peopleArray.count) {
                        [self sentEventAllImagesLoaded];
                    }
                    
                });
                
            });
            
        }
    }
    
}
-(UIImage*) loadImageFromURL:(NSString*) url
{
    
    
    NSURL *nsurl = [NSURL URLWithString:url];
    NSData *data = [NSData dataWithContentsOfURL:nsurl];
    if (data!=nil) {
        UIImage * img = [[UIImage alloc] initWithData:data scale:1.0];

        return img;

        
    }else{
        return nil;
    }
   
}


@end
