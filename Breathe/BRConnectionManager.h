//
//  BRConnectionManager.h
//  Breathe
//
//  Created by Tiago Janela on 9/19/15.
//  Copyright © 2015 Bliss Applications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RigLeConnectionManager.h"
#import "RigAvailableDeviceData.h"
#import "RigLeBaseDevice.h"

@interface BRConnectionManager : NSObject <RigLeConnectionManagerDelegate, RigLeBaseDeviceDelegate>
{
    NSTimeInterval _packet0Epoch;
    NSTimer *_networkDispatcher;
}
@property (strong) RigAvailableDeviceData *connectedDeviceData;
@property (strong) NSDateFormatter *dateFormatter;
@property (strong) NSMutableArray *measurementsArray;

+ (BRConnectionManager*) sharedInstance;

- (void) connectToDevice:(RigAvailableDeviceData*)deviceData;

@end
