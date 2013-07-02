//
//  TCSUrlReachabilityWatcher.m
//  People
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import "TCSUrlReachabilityWatcher.h"

@implementation TCSUrlReachabilityWatcher

- (void) nextReconnectionInterval
{
    switch (_reconnectionInterval) {
        case 0:
            _reconnectionInterval = 2;
            break;
        case 2:
            _reconnectionInterval = 4;
            break;
            
        default:
            _reconnectionInterval = 4;
            break;
    }
    
}


@end
