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
    }
    
    return self;
}
////////
-(void) loadData
{
    

    _reTry = YES;
    int maxSync = [Person maxSyncInManagedObjectContext:self.managedObjectContext];
    
    NSLog(@"maxSync%i", maxSync);
    
    _syncVersion = maxSync + 1;
    
    _urlReachabilityWatcher = [[TCSUrlReachabilityWatcher alloc] init];
    
    _imagesUrls = [Person allImagesURLsInManagedObjectContext:self.managedObjectContext];
    
    
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
                    _reTry = NO;

                } else {
                    dispatch_async(dispatch_get_main_queue(), ^(){
                        /*
                        _reTry = YES;
                        [_urlReachabilityWatcher setNextCheck];
                        
                        [_dataReloadDelegate indicateconnectionProblem:_urlReachabilityWatcher.reconnectionInterval ];
                        [NSTimer scheduledTimerWithTimeInterval:_urlReachabilityWatcher.reconnectionInterval target:self
                                                       selector:@selector(loadData)
                                                       userInfo:nil
                                                        repeats:NO];
                         */
                    });
                }
        
            });
}
- (void)extactDataFromJson:(NSData *)responseData {
    
    _personsWithNewImageUrl = [NSMutableArray array];
    
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData
                     options:kNilOptions
                     error:&error];
    
    NSLog(@"json%@",json);

    for (NSDictionary *personDesc in json) {

                Person *person =[Person insertUpdatePerson:[personDesc objectForKey:@"name"]
                                 withEmail:[personDesc objectForKey:@"email"]
                                  imageUrl:[personDesc objectForKey:@"avatar_url"]
                    inManagedObjectContext:self.managedObjectContext
                               syncVersion:_syncVersion];
            
                
                if (person!=nil) {
                    [_personsWithNewImageUrl addObject:person];
                }
          
                
                if ([Person recordsInSync:_syncVersion InManagedObjectContext:self.managedObjectContext]==json.count) {
                    [Person deleteRecordsNotInCurrent:_syncVersion InManagedObjectContext:self.managedObjectContext];
                    [_dataReloadDelegate createUpdateDoneNotification];
                }
    
   
    }
    
    [self loadNewImages];
    
}
- (void)sentEventAllImagesLoaded {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AllImagesLoaded" object:nil];
}
-(void)updateImagesInDB {
    
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    [_personImages enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
        //Here: key = person.email ; obj = image
        [Person updatePersonWithEmail:key newImage:obj inManagedObjectContext:self.managedObjectContext syncVersion:_syncVersion ];
        
    }];
        
        
    });
    
    
   // [_dataReloadDelegate createUpdateDoneNotification];
    
}
-(void) loadNewImages
{
   _personImages = [NSMutableDictionary dictionary];
    
    for (Person * person in _personsWithNewImageUrl) {
        dispatch_async(dispatch_get_global_queue(
                                                 DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
                UIImage * image = [self loadImageFromURL:person.url];

            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                [_personImages setObject:image forKey:person.email];
                
                if (_personImages.count == _personsWithNewImageUrl.count) {
                    [self sentEventAllImagesLoaded];
                }  
                
            });
            
        });
    }
        
}


- (void)extactDataFromJsonWithImages:(NSData *)responseData {
    
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
            
            [Person insertUpdatePerson:[personDesc objectForKey:@"name"]
                             withEmail:[personDesc objectForKey:@"email"]
                              imageUrl:[personDesc objectForKey:@"avatar_url"]
                                 Image:image
                inManagedObjectContext:self.managedObjectContext
                           syncVersion:_syncVersion];
            
            dispatch_async(dispatch_get_main_queue(), ^(){
                
                if ([Person recordsInSync:_syncVersion InManagedObjectContext:self.managedObjectContext]==json.count) {
                    [Person deleteRecordsNotInCurrent:_syncVersion InManagedObjectContext:self.managedObjectContext];
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
