//
//  TCSUrlReachabilityWatcher.h
//  People
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TCSUrlReachabilityWatcher : NSObject


@property (nonatomic, assign) int reconnectionInterval;

- (void) setNextCheck;
@end
