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
    NSUInteger _lastChestValue;
    NSUInteger _lastBellyValue;

    NSUInteger _inhaleChestAccumulator;
    NSUInteger _exhaleChestAccumulator;
    
    NSUInteger _inhaleBellyAccumulator;
    NSUInteger _exhaleBellyAccumulator;

    NSInteger _currentChestSlope;
    NSInteger _currentBellySlope;

    double _currentBellyAverage;
    double _currentChestAverage;

    BOOL _didInhale;
    BOOL _didExhale;

    BOOL _breatheCycleComplete;
}
@property (strong) RigAvailableDeviceData *connectedDeviceData;
@property (strong) NSDateFormatter *dateFormatter;
@property (strong) NSMutableArray *measurementsArray;

@property (readonly) BOOL breatheCycleComplete;

- (void) acknowledgeBreatheCycle;

+ (BRConnectionManager*) sharedInstance;

- (double) bellyRatio;

- (void) connectToDevice:(RigAvailableDeviceData*)deviceData;

@end
