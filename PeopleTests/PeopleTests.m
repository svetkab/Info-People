//
//  PeopleTests.m
//  PeopleTests
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import "PeopleTests.h"

@implementation PeopleTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
//    STFail(@"Unit tests are not implemented yet in PeopleTests");
}
- (void) testDataLoad
{
    [self loadData];
}
-(void) loadData
{
    
    [self loadDataFromURL:[NSURL URLWithString:@"http://code.laksg.com/challenge/api/people/"]];
    
}
-(void) loadDataFromURL:(NSURL*)url

{
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        url];
        [self performSelectorOnMainThread:@selector(extactDataFromJson:)
                               withObject:data waitUntilDone:YES];
    });
}
- (void)extactDataFromJson:(NSData *)responseData {
    
    NSError* error;
    NSArray* json = [NSJSONSerialization
                     JSONObjectWithData:responseData //1
                     
                     options:kNilOptions
                     error:&error];
    
    NSLog(@"json%@",json);
    
    
    //  NSArray* latestLoans = [json objectForKey:@"loans"]; //2
    
    //  NSLog(@"loans: %@", latestLoans); //3
}
@end
