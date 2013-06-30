//
//  TCSUrlReachabilityWatcher.m
//  People
//
//  Created by Svetlana Brodskaya on 6/28/13.
//  Copyright (c) 2013 Svetlana Brodskaya. All rights reserved.
//

#import "TCSUrlReachabilityWatcher.h"

@implementation TCSUrlReachabilityWatcher

- (void) setNextCheck
{
    switch (_reconnectionInterval) {
        case 0:
            _reconnectionInterval = 2;
            break;
        case 2:
            _reconnectionInterval = 4;
            break;
        case 4:
            _reconnectionInterval = 8;
            break;
        case 8:
            _reconnectionInterval = 60;
            break;
            
        default:
            _reconnectionInterval = 360;
            break;
    }
    
    
}


@end
